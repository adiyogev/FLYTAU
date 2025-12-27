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
        if self.seats_booked >= self.plane_capacity:
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

# check for available and suitable staff members (pilots and flight attendants)
def get_available_staff(table, id_col):
    query = f"""
        SELECT * FROM {table} 
        WHERE {id_col} NOT IN (
            SELECT {id_col} FROM {table}s_on_Flight sf
            JOIN Flight f ON sf.flight_id = f.flight_id
            WHERE ABS(TIMESTAMPDIFF(HOUR, f.departure, %s)) < 24
        )
    """
    if is_long:
        query += " AND long_flight_qualified = 1"
    cursor.execute(query, (dep_dt,))
    return cursor.fetchall()




