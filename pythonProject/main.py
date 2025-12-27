from flask import Flask, render_template, redirect, request, session
from flask_session import Session
import mysql.connector
from utils import *
from datetime import datetime, date

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)


mydb = mysql.connector.connect(host="localhost", user="root", password="root", database="db_team46")
cursor = mydb.cursor()

@app.route('/', methods=['POST', 'GET'])
def landingpage():
    if session.get("customer_email"): # checking if user is already connected
        return redirect('/homepage')

    return render_template('landing_page.html')

@app.route('/homepage', methods=['POST', 'GET'])
def homepage():
    if not session.get("customer_email"): # checking if user is connected
        return redirect("/")


@app.route('/login', methods=['POST', 'GET'])
def login():
    ''' login from different pages - each login will redirect to the correct page:
        order -> checkout
        homepage -> back to homepage'''
    if session.get("customer_email"): # checking if user is already connected
        return redirect('/homepage')
    target_destination = request.args.get('next')
    error_msg = None
    if request.method == 'POST':
        customer_email = request.form.get('customer_email').lower()
        password = request.form.get('password')
        destination_after_login = request.form.get('next_url_hidden') # from hidden destination in HTML
        cursor.execute("SELECT customer_email, password, first_name FROM Customer WHERE customer_email = %s AND password = %s",(customer_email, password))
        customer = cursor.fetchone() # either one result or None
        if customer: # find if entered email is in Customer DB, and if so - login the user
            session['role'] = 'registered'
            session['customer_email'] = customer[0]
            session['first_name'] = customer[2] # for the homepage display
            # check whether the next page will be homepage or checkout
            if destination_after_login:
                return redirect(destination_after_login)
            else:
                return redirect('/homepage')
        error_msg = "one of the details you provided are incorrect"  # If either the id or the password entered are incorrect or don't match
    return render_template("login.html", message=error_msg, next_param = target_destination)


@app.route('/login_guest', methods=['POST'])
def login_guest():
    ''' login from different pages - each login will redirect to the correct page:
            order -> checkout
            homepage -> back to homepage'''
    guest_email = request.form.get('guest_email')
    destination_after_login = request.form.get('next_url_hidden')  # from hidden destination in HTML
    session['role'] = 'guest'
    session['guest_email'] = guest_email
    # check whether the next page will be homepage or checkout
    if destination_after_login:
        return redirect(destination_after_login)
    else:
        return redirect('/homepage'))

@app.route('/login_manager', methods=['POST', 'GET'])
def login_manager():
    if session.get("manager_id"):  # checking if manager is already connected
        return redirect("/manager")  # להבין אם מעביר לדף בית מחובר
    error_msg = None
    if request.method == 'POST':
        manager_id = request.form.get('manager_id')
        password = request.form.get('password')
        cursor.execute("SELECT manager_id, password FROM Manager WHERE manager_id = %s AND password = %s", (manager_id, password))
        manager = cursor.fetchone() # either one result or None
        if manager: # Find if entered id is in Manager DB, and if so - login the manager
            session['role'] = 'manager'
            session['manager_id'] = manager_id
            return redirect('/manager')
        error_msg = "incorrect ID or password" # If either the id or the password entered are incorrect or don't match
    return render_template('login_manager.html', message=error_msg)

@app.route('/register', methods=['POST', 'GET'])
def register():
    target_destination = request.args.get('next')
    if request.method == 'POST':
        # Retrieves the needed information to enter customer into DB
        customer_email = request.form.get('customer_email').lower()
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        passport = request.form.get('passport')
        birth_date = request.form.get('birth_date')
        password = request.form.get('password')
        phone_numbers_form = request.form.getlist('phone_numbers')
        phone_numbers = [p for p in phone_numbers_form if p != ""]
        reg_date = date.today()

        destination_after_login = request.form.get('next_url_hidden')  # from hidden destination in HTML
        cursor.execute("SELECT customer_email FROM Customer WHERE customer_email = %s", (customer_email,)) # We won't allow the same email to have 2 different accounts
        if cursor.fetchone():
            return render_template('register.html', message="User Already Exists")
        cursor.execute("INSERT INTO Customer(customer_email, first_name, last_name, passport, birth_date, password, reg_date) VALUES(%s, %s, "
                       "%s, %s, %s, %s, %s)", (customer_email, first_name, last_name, passport, birth_date, password, phone_numbers, reg_date))
        for phone in phone_numbers:
            cursor.execute("INSERT INTO Customer_Phone_Numbers(phone_customer_email, phone_num) VALUES(%s, %s)",(customer_email, phone))
        mydb.commit()
        session['role'] = 'registered'
        session['customer_email'] = customer_email
        if destination_after_login:
            return redirect(destination_after_login)
        else:
            return redirect('/homepage')
    return render_template("register.html")

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

@app.route('/search_flights', methods=['POST', 'GET'])
def search_flights():
    if request.method == 'POST':
        origin = request.form.get('origin')
        destination = request.form.get('destination')
        departure_date = request.form.get('departure_date')
        num_passengers = int(request.form.get('num_passengers', 1))

        session['search_origin'] = origin
        session['search_destination'] = destination
        session['num_passengers'] = num_passengers

        query = """
            SELECT 
                f.flight_id, f.origin_airport, f.destination_airport, 
                f.duration, f.departure,
                (SELECT COUNT(*) FROM Class as c WHERE c.plane_id = f.plane_id) as capacity,
                COALESCE(occupied_counts.booked_count, 0) as occupied
            FROM Flight as f
            LEFT JOIN (
                SELECT o.flight_id, COUNT(sio.seat_row) as booked_count
                FROM Orders as o
                JOIN Seats_in_Order sio ON o.code = sio.code
                WHERE o.status != 'cancelled'
                GROUP BY o.flight_id
            ) occupied_counts ON f.flight_id = occupied_counts.flight_id
            WHERE f.origin_airport = %s 
              AND f.destination_airport = %s 
              AND DATE(f.departure) = %s
              AND f.status = 'active'
              HAVING (capacity - occupied) >= %s
        """

        cursor.execute(query, (origin, destination, departure_date, num_passengers))
        flights_from_db = cursor.fetchall()

        available_flights = []
        for f in flights_from_db:
            flight_obj = Flight(
                flight_id=f[0], origin=f[1], destination=f[2],
                duration=f[3], departure=f[4],
                capacity=f[5], occupied=f[6]
            )
            available_flights.append(flight_obj)

        return render_template('flight_results.html', flights=available_flights)

    return redirect('/homepage')


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
        departure_dt = datetime.strptime(dep_str, '%Y-%m-%dT%H:%M')

        # search for this route in DB
        cursor.execute("SELECT duration, is_long FROM Route WHERE origin_airport = %s AND destination_airport = %s", (origin, dest))
        route = cursor.fetchone()

        if not route:
            # if it is a new route - fill duration and insert to DB
            duration_str = request.form.get('duration')
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
# choosing plane and crew
    f_data = session.get('temp_flight')
    dep_dt = datetime.strptime(f_data['departure'], '%Y-%m-%dT%H:%M')
    is_long = f_data['is_long']

    if request.method == 'POST':
        session['temp_flight'].update({
            'plane_id': request.form.get('plane_id'),
            'pilots': request.form.getlist('pilots'),
            'fas': request.form.getlist('fas')})
        return redirect('/manager/add_flight/step3')

    # available and suitable planes
    plane_query = """
        SELECT plane_id, size 
        FROM Plane 
        WHERE plane_id NOT IN (SELECT plane_id 
                                FROM Flight
                                WHERE ABS(TIMESTAMPDIFF(HOUR, departure, %s)) < 24)
    """
    if is_long:
        plane_query += " AND size = 'large'"
    cursor.execute(plane_query, (dep_dt,))
    available_planes = cursor.fetchall()
    available_pilots = get_available_staff('Pilot', 'pilot_id')
    available_fas = get_available_staff('Flight_Attendant', 'fa_id')

    return render_template('add_flight_s2.html', planes=available_planes, pilots=available_pilots, fas=available_fas, is_long=is_long)


@app.route('/manager/add_flight/step3', methods=['GET', 'POST'])
def add_flight_step3():
# insert prices for economy and business (if there are) seats
    f_data = session.get('temp_flight')
    # chosen plane size
    cursor.execute("SELECT size FROM Plane WHERE plane_id = %s", (f_data['plane_id'],))
    plane_size = cursor.fetchone()[0]

    if request.method == 'POST':
        p_eco = int(request.form.get('price_economy'))
        p_bus = request.form.get('price_business')
        p_bus = int(p_bus) if p_bus else None

        # pricing validation
        temp_f = Flight(f_data['flight_id'], f_data['origin'], f_data['destination'], f_data['duration'],
                        f_data['departure'], f_data['plane_id'], p_bus, p_eco)
        valid, msg = temp_f.validate_pricing(plane_size, p_bus)

        if not valid:
            return render_template('add_flight_s3.html', error=msg, plane_size=plane_size)

        # calculate the derived attribute 'arrival' and insert to DB
        h, m = map(int, f_data['duration'].split(':'))
        arrival = datetime.strptime(f_data['departure'], '%Y-%m-%dT%H:%M') + timedelta(hours=h, minutes=m)
        try:
            cursor.execute("""INSERT INTO Flight (flight_id, origin_airport, destination_airport, departure, arrival, plane_id, economy_seat_price, business_seat_price)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""", (f_data['flight_id'], f_data['origin'], f_data['destination'], f_data['departure'], arrival, f_data['plane_id'], p_eco, p_bus))
            for pid in f_data['pilots']: cursor.execute("INSERT INTO Pilots_on_Flight VALUES (%s, %s)", (f_data['flight_id'], pid))
            for fid in f_data['fas']: cursor.execute("INSERT INTO FA_on_Flight VALUES (%s, %s)", (f_data['flight_id'], fid))
            mydb.commit()
            session.pop('temp_flight')
            return redirect('/manager')
        except Exception as e:
            mydb.rollback()
            return f"Error: {e}"

    return render_template('add_flight_s3.html', plane_size=plane_size)


@app.errorhandler(404)
def error(e):
    return redirect('/')

if __name__ == "__main__":
    app.run(debug=True)

cursor.close()
mydb.close()