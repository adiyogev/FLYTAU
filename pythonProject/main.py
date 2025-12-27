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

@app.errorhandler(404)
def error(e):
    return redirect('/')

if __name__ == "__main__":
    app.run(debug=True)

cursor.close()
mydb.close()