from flask import Flask, render_template, redirect, request, session, url_for
from flask_session import Session
import random
import string
import mysql.connector
from utils import *
from datetime import datetime, date, timedelta

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

mydb = mysql.connector.connect(host="localhost", user="root", password="root", database="FLYTAU")
cursor = mydb.cursor()


# ============================================================================
#                                 MAIN ROUTES
# ============================================================================
@app.route('/', methods=['GET'])
def index():
    """
    Renders the main landing page which includes the search form.
    Checks if a user is logged in to adjust the Header display.
    """
    user_name = session.get('first_name')
    is_logged_in = session.get('customer_email') is not None
    # All origin and destination options from Route
    cursor.execute("""
        SELECT DISTINCT origin_airport FROM Route 
        UNION 
        SELECT DISTINCT destination_airport FROM Route
    """)
    routes = [row[0] for row in cursor.fetchall()]
    return render_template('index.html', user_name=user_name, is_logged_in=is_logged_in, available_routes=routes)


# USER PAGES
@app.route('/search_flights', methods=['GET'])
def search_flights():
    """
    Fetches flights matching criteria, creates Flight objects, and renders results.
    """
    # 1. Retrieve search parameters from URL
    origin = request.args.get('origin')
    destination = request.args.get('destination')
    departure_date = request.args.get('departure_date')
    num_passengers = request.args.get('num_passengers', 1, type=int)

    # 2. Validation
    if not origin or not destination or not departure_date:
        return redirect(url_for('index'))

    # 3. Store search context in session for later steps
    session['search_origin'] = origin
    session['search_destination'] = destination
    session['num_passengers'] = num_passengers

    # 4. Query DB: Get Flight info + Prices + Plane ID + Capacity/Occupancy calculation
    query = """
            SELECT f.flight_id, f.origin_airport, f.destination_airport, r.duration, f.departure, 
                   f.plane_id, f.business_seat_price, f.economy_seat_price,
                   (SELECT COUNT(*) FROM Class as c WHERE c.plane_id = f.plane_id) as capacity,
                   COALESCE(occupied_counts.booked_count, 0) as occupied
            FROM Flight as f
            JOIN Route as r ON f.origin_airport = r.origin_airport 
                           AND f.destination_airport = r.destination_airport
            LEFT JOIN (
                SELECT o.flight_id, COUNT(sio.seat_row) as booked_count
                FROM Orders as o
                JOIN Seats_in_Order sio ON o.code = sio.code
                WHERE o.status != 'cancelled'
                GROUP BY o.flight_id
            ) occupied_counts ON f.flight_id = occupied_counts.flight_id
            WHERE f.origin_airport = %s AND f.destination_airport = %s 
              AND DATE(f.departure) = %s AND f.status = 'active'
              HAVING (capacity - occupied) >= %s
        """
    cursor.execute(query, (origin, destination, departure_date, num_passengers))
    flights_from_db = cursor.fetchall()

    # 5. Create Flight Objects (OOP)
    available_flights = []
    for f in flights_from_db:
        # Utilizing the Flight class from utils.py
        flight_obj = Flight(
            flight_id=f[0], origin=f[1], destination=f[2],
            duration=str(f[3]), departure=f[4], plane_id=f[5],
            business_seat_price=f[6], economy_seat_price=f[7],
            capacity=f[8], occupied=f[9]
        )
        available_flights.append(flight_obj)

    # 6. Render Results
    return render_template('flight_results.html',
                           flights=available_flights,
                           user_name=session.get('first_name'),
                           is_logged_in=session.get('customer_email') is not None)


@app.route('/select_seats/<flight_id>', methods=['GET', 'POST'])
def select_seats(flight_id):
    """
    Displays the plane layout (GET) and processes seat selection (POST).
    """
    num_passengers = session.get('num_passengers', 1)

    # POST: Handle Selection Submission
    if request.method == 'POST':
        raw_seats = request.form.getlist('selected_seats_raw')
        # Validation
        if len(raw_seats) != num_passengers:
            return redirect(url_for('select_seats', flight_id=flight_id))
        # Parse data and store in Session (avoiding DB lookups in Checkout)
        final_seats_list = []
        for item in raw_seats:
            try:
                code, seat_type, price = item.split('|')
                final_seats_list.append({
                    'code': code,
                    'type': seat_type,
                    'price': float(price)
                })
            except (ValueError, IndexError):
                # Invalid seat data format, skip this item
                continue

        session['selected_seats_data'] = final_seats_list
        session['selected_flight_id'] = flight_id

        return redirect(url_for('checkout'))

    # GET: Render Plane Layout
    # 1. Fetch Flight & Price Info
    cursor.execute(
        "SELECT plane_id, economy_seat_price, business_seat_price, origin_airport, destination_airport FROM Flight WHERE flight_id = %s",
        (flight_id,))
    flight_data = cursor.fetchone()
    if not flight_data: return redirect('/')
    # 2. Fetch plane layout (rows, positions, classes)
    plane_id, eco_price, bus_price, origin, dest = flight_data

    cursor.execute(
        "SELECT seat_row, seat_position, class_type FROM Class WHERE plane_id = %s ORDER BY seat_row, seat_position",
        (plane_id,))
    all_seats = cursor.fetchall()
    # 3. Fetch Occupied Seats
    cursor.execute("""
        SELECT sio.seat_row, sio.seat_position 
        FROM Seats_in_Order sio
        JOIN Orders o ON sio.code = o.code
        WHERE o.flight_id = %s AND o.status != 'cancelled'
    """, (flight_id,))
    occupied_set = {(r, p) for r, p in cursor.fetchall()}
    # 4. Build Logic Maps for Jinja Template (Separating Business/Economy)
    biz_seats_map = {}
    eco_seats_map = {}

    for row, pos, c_type in all_seats:
        is_occupied = (row, pos) in occupied_set
        curr_price = bus_price if c_type == 'business' else eco_price

        # Creation of FlightClass object
        seat_obj = FlightClass(
            seat_row=row,
            seat_position=pos,
            class_type=c_type,
            plane_id=plane_id,
            price=curr_price,
            is_occupied=is_occupied
        )
        # Sort into correct dictionary for the UI grid
        target_map = biz_seats_map if c_type == 'business' else eco_seats_map
        if row not in target_map:
            target_map[row] = []
        target_map[row].append(seat_obj)

    return render_template('select_seat.html',
                           biz_map=biz_seats_map,
                           eco_map=eco_seats_map,
                           flight_id=flight_id,
                           num_passengers=num_passengers,
                           origin=origin, dest=dest,
                           eco_price=eco_price, bus_price=bus_price)


@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
    """
    Handles passenger details (Guest/Registered) and order creation.
    """
    # 1. Session Data
    flight_id = session.get('selected_flight_id')
    selected_seats_data = session.get('selected_seats_data')

    if not flight_id or not selected_seats_data:
        return redirect(url_for('index'))

    # 2. Seats objects
    seat_objects = []
    total_price = 0
    for s_data in selected_seats_data:
        code = s_data['code']
        price = s_data['price']
        total_price += price
        seat = FlightClass(seat_row=int(code[:-1]), seat_position=code[-1],
                           class_type=s_data['type'], plane_id=None, price=price)
        seat_objects.append(seat)

    # 3. Check if user is logged in
    user_data = None
    is_logged_in = 'customer_email' in session
    if is_logged_in:
        # if logged - auto fill details from DB
        cursor.execute("SELECT first_name, last_name, passport, birth_date FROM Customer WHERE customer_email = %s",
                       (session['customer_email'],))
        row = cursor.fetchone()
        if row:
            user_data = {
                'first_name': row[0],
                'last_name': row[1],
                'passport': row[2],
                'birth_date': row[3],
                'phone': ""
            }
            cursor.execute("SELECT phone_num FROM customer_phone_numbers WHERE phone_customer_email = %s",
                           (session['customer_email'],))
            p_row = cursor.fetchone()
            if p_row: user_data['phone'] = p_row[0]

    # POST: Finalize Order
    if request.method == 'POST':
        email = request.form.get('email').lower()
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        phone = request.form.get('phone')
        passport = request.form.get('passport')
        birth_date = request.form.get('birth_date')

        # 1. Check if already registered and validate details
        cursor.execute("SELECT customer_email FROM Customer WHERE customer_email = %s", (email,))
        is_registered_db = cursor.fetchone()

        if is_registered_db:
            final_customer_email = email
            final_guest_email = None
        else:
            valid, msg = validate_guest_data(first_name, last_name, phone)
            if not valid:
                cursor.execute(
                    "SELECT flight_id, origin_airport, destination_airport, departure FROM Flight WHERE flight_id = %s",
                    (flight_id,))
                f_db = cursor.fetchone()
                flight_obj = Flight(f_db[0], f_db[1], f_db[2], None, f_db[3], None, 0, 0)
                return render_template('checkout.html',
                                       error=msg,
                                       flight=flight_obj,
                                       seats=seat_objects,
                                       total_price=total_price,
                                       is_guest=True)
            # 2. Guest DB insert
            try:
                # dont save the email if exists
                cursor.execute("INSERT IGNORE INTO Guest (guest_email, first_name, last_name) VALUES (%s, %s, %s)",
                               (email, first_name, last_name))
                cursor.execute("INSERT INTO guest_phone_numbers (phone_guest_email, phone_num) VALUES (%s, %s)",
                               (email, phone))
                mydb.commit()
                final_customer_email = None
                final_guest_email = email
            except Exception as e:
                mydb.rollback()
                return f"שגיאה בשמירת פרטי אורח: {e}"

            # 3. Creating order code and DB insert
            order_code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
            try:
                cursor.execute("""
                        INSERT INTO Orders (code, status, total_price, order_date, flight_id, customer_email, guest_email)
                        VALUES (%s, 'active', %s, %s, %s, %s, %s)
                    """, (order_code, total_price, datetime.now(), flight_id, final_customer_email, final_guest_email))

                # 4. Insert seats to Seats_in_Order
                cursor.execute("SELECT plane_id FROM Flight WHERE flight_id=%s", (flight_id,))
                plane_result = cursor.fetchone()
                if not plane_result:
                    raise ValueError("Flight not found")
                real_plane_id = plane_result[0]

                for seat in seat_objects:
                    cursor.execute("""
                            INSERT INTO Seats_in_Order (seat_row, seat_position, code, seats_plane_id)
                            VALUES (%s, %s, %s, %s)
                         """, (seat.seat_row, seat.seat_position, order_code, real_plane_id))

                mydb.commit()

                # 6. Session sleaning
                session.pop('selected_seats_data', None)
                session.pop('selected_flight_id', None)

                # route information for confirmation
                cursor.execute("SELECT origin_airport, destination_airport FROM Flight WHERE flight_id=%s",
                               (flight_id,))
                f_info = cursor.fetchone()

                return render_template('confirmation.html',
                                       order_code=order_code,
                                       first_name=first_name,
                                       last_name=last_name,
                                       passport=passport,
                                       birth_date=birth_date,
                                       flight_id=flight_id,
                                       origin=f_info[0],
                                       dest=f_info[1])

            except Exception as e:
                mydb.rollback()
                return f"שגיאה ביצירת הזמנה: {e}"

    # GET: Render Checkout Page
    # 1. Fetch user details for auto fill (if registered)
    user_details = {}
    if is_logged_in:
        cursor.execute("""SELECT first_name, last_name, passport, birth_date FROM Customer WHERE customer_email = %s""", (session['customer_email'],))
        cust_data = cursor.fetchone()
        if cust_data:
            user_details = {'first_name': cust_data[0], 'last_name': cust_data[1], 'passport': cust_data[2], 'birth_date': cust_data[3]}
            cursor.execute("SELECT phone_num FROM Customer_Phone_Numbers WHERE phone_customer_email = %s LIMIT 1",
                           (session['customer_email'],))
            p_data = cursor.fetchone()
            user_details['phone'] = p_data[0] if p_data else ""

    # 2. Prepare flight object for display
    query = """
        SELECT f.flight_id, f.origin_airport, f.destination_airport, r.duration, f.departure 
        FROM Flight f
        JOIN Route r ON f.origin_airport = r.origin_airport 
                     AND f.destination_airport = r.destination_airport
        WHERE f.flight_id = %s
    """
    cursor.execute(query, (flight_id,))
    f_data = cursor.fetchone()
    if not f_data:
        return redirect(url_for('index'))
    flight_display = Flight(f_data[0], f_data[1], f_data[2], str(f_data[3]), f_data[4], None, 0, 0)

    return render_template('checkout.html',
                           flight=flight_display,
                           seats=seat_objects,
                           total_price=total_price,
                           user=user_data,
                           is_guest=(not is_logged_in),
                           user_name=session.get('first_name'))


@app.route('/my_orders', methods=['GET', 'POST'])
def my_orders():
    # check session if user is logged in
    role = session.get('role')
    if not role:
        # login and remember my path
        return redirect('/login?next=/my_orders')

    # get email - customer or guest?
    email = session.get('customer_email') if role == 'registered' else session.get('guest_email')
    if not email:
        return redirect('/login?next=/my_orders')

    # 1. define the filter so it's available for the query
    status_filter = request.args.get('status', 'active')

    # 2. handle cancellation before fetching data
    message = None
    if request.method == 'POST' and request.form.get('action') == 'cancel':
        order_code = request.form.get('order_code')
        # user object (Polymorphism)
        user = Customer(email, "", "", "", "") if role == 'registered' else User(email, first_name, last_name, phone_numbers)
        success, message = user.cancel_order(cursor, mydb, order_code)

    # 3. fetch the updated data for display
    query = """
        SELECT o.code, o.order_date, o.total_price, o.status, 
               f.origin_airport, f.destination_airport, f.departure, f.flight_id
        FROM Orders o
        JOIN Flight f ON o.flight_id = f.flight_id
        WHERE (o.customer_email = %s OR o.guest_email = %s)
    """
    params = [email, email]

    if role == 'guest':
        # only future active orders
        query += " AND o.status = 'active' AND f.departure > NOW()"
    else:
        # all orders + status filter option
        if status_filter != 'all':
            query += " AND o.status = %s"
            params.append(status_filter)

    query += " ORDER BY f.departure DESC"

    cursor.execute(query, tuple(params))
    orders_data = cursor.fetchall()

    # convert to Order objects for template (OOP)
    orders_list = []
    for row in orders_data:
        # Create Order object
        order_obj = Order(
            code=row[0],
            seats=[],  # Seats not needed for display
            flight_id=row[7],
            email=email if role == 'registered' else None,
            guest_email=email if role == 'guest' else None
        )
        # Set additional attributes from DB query for display
        order_obj.order_date = row[1]  # Override default datetime.now()
        order_obj.status = row[3]  # Override default 'active'
        # Add flight display attributes
        order_obj.origin = row[4]
        order_obj.dest = row[5]
        order_obj.departure = row[6]
        order_obj.total_price = row[2]  # From DB, not calculated
        # Check if order can be canceled using the class method
        order_obj.can_cancel = order_obj.is_eligible_for_cancel(row[6]) and row[3] == 'active'
        orders_list.append(order_obj)

    return render_template('my_orders.html',
                           orders=orders_list,
                           role=role,
                           current_filter=status_filter,
                           message=message)


# ============================================================================
#                           LOGIN, REGISTER, LOGOUT
# ============================================================================
@app.route('/login', methods=['POST', 'GET'])
def login():
    ''' login from different pages - each login will redirect to the correct page:
        order -> checkout
        homepage -> back to homepage'''
    target_destination = request.args.get('next')
    if session.get("customer_email"):  # checking if user is already connected
        return redirect(target_destination if target_destination else '/')
    error_msg = None
    if request.method == 'POST':
        customer_email = request.form.get('customer_email')
        password = request.form.get('password')
        if not customer_email or not password:
            error_msg = "אנא מלא את כל השדות"
            return render_template("login.html", message=error_msg, next_param=target_destination)
        customer_email = customer_email.lower()
        destination_after_login = request.form.get('next_url_hidden')  # from hidden destination in HTML
        cursor.execute(
            "SELECT customer_email, password, first_name FROM Customer WHERE customer_email = %s AND password = %s",
            (customer_email, password))
        customer = cursor.fetchone()  # either one result or None
        if customer:  # find if entered email is in Customer DB, and if so - login the user
            session['role'] = 'registered'
            session['customer_email'] = customer[0]
            session['first_name'] = customer[2]  # for the homepage display
            # check whether the next page will be homepage or checkout
            if destination_after_login:
                return redirect(destination_after_login)
            else:
                return redirect('/')
        error_msg = "one of the details you provided are incorrect"  # If either the id or the password entered are incorrect or don't match
    return render_template("login.html", message=error_msg, next_param=target_destination)


@app.route('/login_manager', methods=['POST', 'GET'])
def login_manager():
    if session.get("manager_id"):  # checking if manager is already connected
        return redirect("/manager")  # להבין אם מעביר לדף בית מחובר
    error_msg = None
    if request.method == 'POST':
        manager_id = request.form.get('manager_id')
        password = request.form.get('password')
        cursor.execute("SELECT manager_id, password FROM Manager WHERE manager_id = %s AND password = %s",
                       (manager_id, password))
        manager = cursor.fetchone()  # either one result or None
        if manager:  # Find if entered id is in Manager DB, and if so - login the manager
            session['role'] = 'manager'
            session['manager_id'] = manager_id
            return redirect('/manager')
        error_msg = "incorrect ID or password"  # If either the id or the password entered are incorrect or don't match
    return render_template('login_manager.html', message=error_msg)


@app.route('/register', methods=['POST', 'GET'])
def register():
    target_destination = request.args.get('next')
    if request.method == 'POST':
        # Retrieves the needed information to enter customer into DB
        customer_email = request.form.get('customer_email')
        if not customer_email:
            return render_template('register.html', message="אימייל הוא שדה חובה")
        customer_email = customer_email.lower()
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        passport = request.form.get('passport')
        birth_date = request.form.get('birth_date')
        password = request.form.get('password')
        phone_numbers_form = request.form.getlist('phone_numbers')
        phone_numbers = [p for p in phone_numbers_form if p != ""]
        reg_date = date.today()

        destination_after_login = request.form.get('next_url_hidden')
        cursor.execute("SELECT customer_email FROM Customer WHERE customer_email = %s",
                       (customer_email,))  # We won't allow the same email to have 2 different accounts
        if cursor.fetchone():
            return render_template('register.html', message="User Already Exists")
        cursor.execute(
            "INSERT INTO Customer(customer_email, first_name, last_name, passport, birth_date, password, reg_date) VALUES(%s, %s, "
            "%s, %s, %s, %s, %s)",
            (customer_email, first_name, last_name, passport, birth_date, password, phone_numbers, reg_date))
        for phone in phone_numbers:
            cursor.execute("INSERT INTO Customer_Phone_Numbers(phone_customer_email, phone_num) VALUES(%s, %s)",
                           (customer_email, phone))
        mydb.commit()
        session['role'] = 'registered'
        session['customer_email'] = customer_email
        if destination_after_login:
            return redirect(destination_after_login)
        return redirect('/')
    return render_template("register.html", next_param=target_destination)


@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')


# ============================================================================
#                               MANAGER ROUTES
# ============================================================================
@app.route('/manager', methods=['GET', 'POST'])
def manager_flights():
    if session.get("role") != 'manager':
        return redirect('/login_manager')

    # POST - request for flight cancelling
    if request.method == 'POST':
        flight_id = request.form.get('flight_id')

        # verifying at least 72 hours in advance
        cursor.execute("SELECT departure FROM Flight WHERE flight_id = %s", (flight_id,))
        flight_dep = cursor.fetchone()
        if flight_dep:
            departure_time = flight_dep[0]
            # verifying at least 72 hours in advance
            if departure_time - datetime.now() >= timedelta(hours=72):
                try:
                    # update flight status to 'cancelled'
                    cursor.execute("UPDATE Flight SET status = 'cancelled' WHERE flight_id = %s", (flight_id,))
                    # full refund for all customers
                    cursor.execute("""UPDATE Orders SET total_price = 0, status = 'cancelled by system'
                        WHERE flight_id = %s AND status = 'active'""", (flight_id,))
                    mydb.commit()
                    message = "הטיסה בוטלה בהצלחה וכל הלקוחות זוכו."
                except Exception as e:
                    mydb.rollback()
                    message = f"error while updating data in DB {e}"
            else:
                message = "לא ניתן לבטל טיסה פחות מ-72 שעות לפני מועד קיומה."[cite: 47]

    # GET - presenting all flights with important details for the manager to review
    cursor.execute("""
        SELECT f.flight_id, f.origin_airport, f.destination_airport, 
               f.departure, r.duration, p.size, f.status, f.plane_id,
               (SELECT COUNT(*) FROM Class WHERE plane_id = f.plane_id) as capacity,
               (SELECT COUNT(*) FROM Seats_in_Order WHERE code IN 
                    (SELECT code FROM Orders WHERE flight_id = f.flight_id)) as occupied
        FROM Flight as f JOIN Route as r ON f.origin_airport = r.origin_airport 
            AND f.destination_airport = r.destination_airport
            JOIN Plane as p ON f.plane_id = p.plane_id
        ORDER BY f.departure DESC
    """)
    flights_data = cursor.fetchall()
    flights_list = []
    for row in flights_data:
        f = Flight(
            flight_id=row[0], origin=row[1], destination=row[2],
            departure=row[3], duration=str(row[4]),
            capacity=row[8], occupied=row[9],
            is_cancelled=(row[6] == 'cancelled'),
            plane_id=row[7]
        )
        flights_list.append(f)
    return render_template('manager_flights.html', flights=flights_list)


@app.route('/manager/add_flight/step1', methods=['GET', 'POST'])
def add_flight_step1():
    # inserting the "basic details" of the flight
    if session.get("role") != 'manager':
        return redirect('/login_manager')

    if request.method == 'POST':
        origin = request.form.get('origin')
        dest = request.form.get('destination')
        dep_str = request.form.get('departure')
        if not origin or not dest or not dep_str:
            return render_template('add_flight_s1.html', error="אנא מלא את כל השדות")
        try:
            departure_dt = datetime.strptime(dep_str, '%Y-%m-%dT%H:%M')
        except ValueError:
            return render_template('add_flight_s1.html', error="פורמט תאריך לא תקין")

        # search for this route in DB
        cursor.execute("SELECT duration, is_long FROM Route WHERE origin_airport = %s AND destination_airport = %s",
                       (origin, dest))
        route = cursor.fetchone()

        if not route:
            # if it is a new route - fill duration and insert to DB
            duration_str = request.form.get('duration')
            if not duration_str:
                return render_template('add_flight_s1.html', error="נדרש להזין משך טיסה")
            try:
                # Validate duration format
                parts = duration_str.split(':')
                if len(parts) < 2:
                    raise ValueError
                int(parts[0])  # Validate hours
                int(parts[1])  # Validate minutes
            except (ValueError, IndexError):
                return render_template('add_flight_s1.html', error="פורמט משך טיסה לא תקין (נדרש: HH:MM)")
            cursor.execute("INSERT INTO Route (origin_airport, destination_airport, duration) VALUES (%s, %s, %s)",
                           (origin, dest, duration_str))
            mydb.commit()
            duration = duration_str
            is_long = int(duration.split(':')[0]) > 6
        else:
            duration = str(route[0])
            is_long = route[1]

        session['temp_flight'] = {
            'flight_id': request.form.get('flight_id'),
            'origin': origin,
            'destination': dest,
            'departure': dep_str,
            'duration': duration,
            'is_long': is_long
        }
        return redirect('/manager/add_flight/step2')
    return render_template('add_flight_s1.html')


@app.route('/manager/add_flight/step2', methods=['GET', 'POST'])
def add_flight_step2():
    if session.get("role") != 'manager':
        return redirect('/login_manager')

    f_data = session.get('temp_flight')
    if not f_data:
        return redirect('/manager/add_flight/step1')

    # filter the available resources (planes, pilots and flight attendants)
    planes = get_available_resources('Plane', 'plane_id', f_data['origin'], f_data['is_long'], cursor)
    pilots = get_available_resources('Pilot', 'pilot_id', f_data['origin'], f_data['is_long'], cursor)
    fas = get_available_resources('Flight_Attendant', 'fa_id', f_data['origin'], f_data['is_long'], cursor)

    return render_template('add_flight_s2.html', planes=planes, pilots=pilots, fas=fas)


@app.route('/manager/add_flight/step3', methods=['GET', 'POST'])
def add_flight_step3():
    if session.get("role") != 'manager':
        return redirect('/login_manager')

    # insert prices for economy and business (if there are) seats
    f_data = session.get('temp_flight')
    if not f_data or 'plane_id' not in f_data:
        return redirect('/manager/add_flight/step1')

    # chosen plane size
    cursor.execute("SELECT size FROM Plane WHERE plane_id = %s", (f_data['plane_id'],))
    plane_result = cursor.fetchone()
    if not plane_result:
        return render_template('add_flight_s3.html', error="מטוס לא נמצא", plane_size=None)
    plane_size = plane_result[0]

    if request.method == 'POST':
        try:
            p_eco = int(request.form.get('price_economy', 0))
        except (ValueError, TypeError):
            return render_template('add_flight_s3.html', error="מחיר כלכלה חייב להיות מספר", plane_size=plane_size)

        p_bus = request.form.get('price_business')
        p_bus = int(p_bus) if p_bus else None

        # pricing validation
        temp_f = Flight(f_data['flight_id'], f_data['origin'], f_data['destination'], f_data['duration'],
                        f_data['departure'], f_data['plane_id'], p_bus, p_eco)
        valid, msg = temp_f.validate_pricing(plane_size, p_bus)

        if not valid:
            return render_template('add_flight_s3.html', error=msg, plane_size=plane_size)

        # calculate the derived attribute 'arrival' and insert to DB
        try:
            h, m = map(int, f_data['duration'].split(':'))
            arrival = datetime.strptime(f_data['departure'], '%Y-%m-%dT%H:%M') + timedelta(hours=h, minutes=m)
        except (ValueError, KeyError) as e:
            return render_template('add_flight_s3.html', error=f"שגיאה בפורמט תאריך/זמן: {e}", plane_size=plane_size)

        try:
            cursor.execute("""INSERT INTO Flight (flight_id, origin_airport, destination_airport, departure, arrival, plane_id, economy_seat_price, business_seat_price)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""", (
            f_data['flight_id'], f_data['origin'], f_data['destination'], f_data['departure'], arrival,
            f_data['plane_id'], p_eco, p_bus))
            # Insert pilots and flight attendants if they exist
            if 'pilots' in f_data:
                for pid in f_data['pilots']:
                    cursor.execute("INSERT INTO Pilots_on_Flight VALUES (%s, %s)", (f_data['flight_id'], pid))
            if 'fas' in f_data:
                for fid in f_data['fas']:
                    cursor.execute("INSERT INTO FA_on_Flight VALUES (%s, %s)", (f_data['flight_id'], fid))
            mydb.commit()
            session.pop('temp_flight')
            return redirect('/manager')
        except Exception as e:
            mydb.rollback()
            return f"Error: {e}"

    return render_template('add_flight_s3.html', plane_size=plane_size)


@app.route('/manager/add_staff', methods=['GET', 'POST'])
def add_staff():
    if session.get("role") != 'manager':
        return redirect('/login_manager')

    if request.method == 'POST':
        staff_data = {
            'staff_type': request.form.get('staff_type'),
            'staff_id': request.form.get('staff_id'),
            'f_name': request.form.get('first_name'),
            'l_name': request.form.get('last_name'),
            'phone': request.form.get('phone'),
            'city': request.form.get('city'),
            'street': request.form.get('street'),
            'st_num': request.form.get('st_num'),
            'start_date': request.form.get('start_date'),
            'is_long_qualified': 1 if request.form.get('is_long_qualified') else 0
        }

        # creating manager object and using 'add_staff_member'
        try:
            current_manager = Manager(session['manager_id'], "", "", "", "", "", "", "", "")
            current_manager.add_staff_member(cursor, staff_data)
            mydb.commit()
            return redirect('/manager')
        except Exception as e:
            mydb.rollback()
            return f"שגיאה בהוספת עובד: {e}"
    return render_template('add_staff.html')


# ERROR HANDLER
@app.errorhandler(404)
def error(e):
    return redirect('/')


if __name__ == "__main__":
    app.run(debug=True)

cursor.close()
mydb.close()