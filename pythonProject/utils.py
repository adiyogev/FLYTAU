from abc import ABC, abstractmethod
from datetime import datetime, date, timedelta

class User(ABC):
    def __init__(self, email):
        self.email = email

    def user_cancel_order(self, order):
        order.status = 'cancelled by user'
        # נוסיף אחרי זה עדכון של הDB בסטטוס ההזמנה
        return

class Customer(User):
    def __init__(self, email, first_name, last_name, passport, birth_date, password, phone_numbers, reg_date):
        super().__init__(email)
        self.first_name = first_name
        self.last_name = last_name
        self.passport = passport
        self.birth_date = birth_date
        self.password = password
        self.phone_numbers = phone_numbers
        self.reg_date = reg_date


class Guest(User):
    def __init__(self, email):
        super().__init__(email)
        self.email = email
        # will be added when details from checkout will be received:
        self.passport = ""
        self.name = ""


class Pilot:
    def __init__(self, id, first_name, last_name, phone_num, start_date, city, street, st_num, long_flight_qualified):
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.phone_num = phone_num
        self.start_date = start_date
        self.city = city
        self.street = street
        self.st_num = st_num
        self.long_flight_qualified = long_flight_qualified

    def is_qualified_for(self, duration_hours):
        if duration_hours > 6:
            return self.long_flight_qualified == 1 # long flight qualification needed
        return True  # everyone can


class FlightAttendant:
    def __init__(self, id, first_name, last_name, phone_num, start_date, city, street, st_num, long_flight_qualified):
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.phone_num = phone_num
        self.start_date = start_date
        self.city = city
        self.street = street
        self.st_num = st_num
        self.long_flight_qualified = long_flight_qualified

    def is_qualified_for(self, duration_hours):
        if duration_hours > 6:
            return self.long_flight_qualified == 1 # long flight qualification needed
        return True  # everyone can


class Manager:
    def __init__(self, id, first_name, last_name, phone_num, start_date, city, street, st_num, password):
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.phone_num = phone_num
        self.start_date = start_date
        self.city = city
        self.street = street
        self.st_num = st_num
        self.password = password

    def cancel_flight(self, flight):
        flight.status = 'cancelled'
        return

    def cancel_order(self, order):
        order.status = 'cancelled by system'
        # ייכנס בתוך כפתור ביטול טיסה של מנהל עבור כל ההזמנות שבטיסה הזאת (שאילתה מתאימה)
        return

    def can_cancel_flight(self, departure_time):
        from datetime import datetime, timedelta
        return (departure_time - datetime.now()) >= timedelta(hours=72)

    def calculate_refund(self, original_price, is_manager_cancel=True):
        if is_manager_cancel:
            return 0  #full refund
        # 5% cancellation fees
        return original_price * 0.05

    def add_staff_member(self, cursor, staff_data):
        staff_type = staff_data.get('staff_type')
        # determine if pilot or flight attendant and insert to DB
        if staff_type == 'pilot':
            table_name = 'Pilot'
            id_column = 'pilot_id'
        else:
            table_name = 'Flight_Attendant'
            id_column = 'fa_id'
        query = f"""INSERT INTO {table_name} 
            ({id_column}, first_name, last_name, phone_num, start_date, city, street, st_num, long_flight_qualified)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        params = (staff_data['staff_id'], staff_data['f_name'], staff_data['l_name'],
                  staff_data['phone'], staff_data['start_date'], staff_data['city'],
                  staff_data['street'], staff_data['st_num'], staff_data['is_long_qualified'])
        cursor.execute(query, params)

class Flight:
    def __init__(self, flight_id, origin, destination, duration, departure, plane_id, business_seat_price, economy_seat_price, capacity=0, occupied=0, is_cancelled=False):
        self.flight_id = flight_id
        self.origin = origin
        self.destination = destination
        self.duration = duration
        self.departure = departure
        self.plane_id = plane_id
        self.business_seat_price = business_seat_price
        self.economy_seat_price = economy_seat_price
        self.capacity = capacity
        self.occupied = occupied
        self.is_cancelled = is_cancelled

    @property
    def status(self):
        now = datetime.now()
        if self.is_cancelled:
            return "cancelled"
        if now > self.departure:
            return "completed"
        if self.occupied >= self.capacity:
            return "full"
        return "active"

    @property
    def arrival_time(self):
        try:
            hours, minutes = map(int, self.duration.split(':'))
            return self.departure + timedelta(hours=hours, minutes=minutes)
        except (ValueError, AttributeError):
            return None

    @property
    def available_seats(self):
        return self.capacity - self.occupied

    def is_long_flight(self):
        return self.duration.total_seconds() > 6 * 3600

    def get_crew_requirements(self, plane_size):
        if plane_size == 'large':
            return {'pilots': 3, 'attendants': 6}
        return {'pilots': 2, 'attendants': 3}

    def validate_pricing(self, plane_size, price_business):
        if plane_size == 'small' and price_business is not None:
            return False, "מטוס קטן כולל מושבים רגילים בלבד, לא ניתן לתמחר מחלקת עסקים [cite: 24]"
        return True, ""


class Plane:
    def __init__(self, plane_id, size, purchase_date, manufacturer):
        self.plane_id = plane_id
        self.size = size
        self.purchase_date = purchase_date
        self.manufacturer = manufacturer


class Class:
    def __init__(self, seat_row, seat_position, class_type):
        self.seat_row = seat_row
        self.seat_position = seat_position
        self.class_type = class_type


class Order:
    def __init__(self, code, seats, flight_id, email):
        self.code = code
        self.order_date = datetime.now()
        self.seats = seats
        self.status = 'active'
        self.flight_id = flight_id
        self.email = email

    def total_order_price(self):
        total_price = 0
        for seat in self.seats:
            total_price += seat.seat_price
        return total_price

    def is_eligible_for_cancel(self, flight_departure):
        return (flight_departure - datetime.now()) >= timedelta(hours=36)


def get_available_resources(table, id_col, origin, is_long, cursor):
    """
    finding available planes and employees:
    1. current location = origin or first flight
    2. for staff - check if long_flight_qualified
    3. for planes - only large planes for long flights
    """
    # long flight - staff qualification and large plane
    additional_filters = ""
    if is_long:
        if table in ['Pilot', 'Flight_Attendant']:
            additional_filters = " AND long_flight_qualified = 1"
        elif table == 'Plane':
            additional_filters = " AND type = 'large'"

    relation_table = f"{table}s_on_Flight" if table != 'Plane' else "Flight"
    query = f"""
            SELECT * FROM {table} 
            WHERE 1=1 {additional_filters}
            AND (
            -- first flight
            {id_col} NOT IN (SELECT DISTINCT {id_col} FROM {relation_table})
            OR
            -- last arrival is the origin
            (
                SELECT f.destination_airport 
                FROM Flight f
                {"JOIN " + relation_table + " rf ON f.flight_id = rf.flight_id" if table != 'Plane' else ""}
                WHERE {"rf." if table != 'Plane' else "f."}{id_col} = {table}.{id_col}
                ORDER BY f.arrival DESC
                LIMIT 1
            ) = %s
        )
    """

    cursor.execute(query, (origin,))
    return cursor.fetchall()



