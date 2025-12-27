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


@app.route('/manager')
def manager_home():


@app.route('/manager/flights')
def manager_flights():
    if session.get("role") != 'manager':
        return redirect('/login_manager')
    cursor.execute("""
        SELECT f.flight_id, f.origin_airport, f.destination_airport, 
               f.departure, r.duration, p.size, f.status,
               (SELECT COUNT(*) FROM Class WHERE plane_id = f.plane_id) as capacity,
               (SELECT COUNT(*) FROM Seats_in_Order WHERE code IN 
                    (SELECT code FROM Orders WHERE flight_id = f.flight_id)) as occupied,
                f.plane_id
        FROM Flight as f JOIN Route as r ON f.origin_airport = r.origin_airport AND f.destination_airport = r.destination_airport
            JOIN Plane as p ON f.plane_id = p.plane_id
        ORDER BY f.departure DESC
    """)
    flights_data = cursor.fetchall()
    flights_list = []
    for row in flights_data:
        f = Flight(flight_id=row[0], origin=row[1], destination=row[2],
            departure=row[3], duration=str(row[4]),
            capacity=row[7], occupied=row[8],
            is_cancelled=(row[6] == 'cancelled'),
            plane_id=row[9])
        flights_list.append(f)
    return render_template('manager_flights.html', flights=flights_list)


@app.route('/manager/manage_flight/<flight_id>')
def manage_flight(flight_id):
    if session.get("role") != 'manager':
        return redirect('/login_manager')
    cursor.execute("""
        SELECT f.*, r.duration, p.size 
        FROM Flight as f JOIN Route as r ON f.origin_airport = r.origin_airport AND f.destination_airport = r.destination_airport
            JOIN Plane as p ON f.plane_id = p.plane_id WHERE f.flight_id = %s""", (flight_id,))
    flight_row = cursor.fetchone()
    if not flight_row:
        return "Flight not found", 404
    # Employees on the flight:
    cursor.execute("SELECT pilot_id FROM Pilots_on_Flight WHERE flight_id = %s", (flight_id,))
    current_pilots = [p[0] for p in cursor.fetchall()]
    cursor.execute("SELECT fa_id FROM FA_on_Flight WHERE flight_id = %s", (flight_id,))
    current_fa = [fa[0] for fa in cursor.fetchall()]
    return render_template('manage_specific_flight.html',
                           flight_id=flight_id,
                           flight_details=flight_row,
                           current_pilots=current_pilots,
                           current_fa=current_fa)

@app.errorhandler(404)
def error(e):
    return redirect('/')

if __name__ == "__main__":
    app.run(debug=True)

cursor.close()
mydb.close()