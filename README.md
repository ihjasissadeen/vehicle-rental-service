# 🚗 Vehicle Rental Service

A full-stack Java web application for renting vehicles (cars, bikes, and vans), built as a group project for the **Object-Oriented Programming (OOP)** module at SLIIT. The system supports customer-facing booking, checkout, and reviews, along with a dedicated admin dashboard for managing vehicles, users, bookings, payments, and reviews.

This project was designed primarily to demonstrate strong **OOP fundamentals** — inheritance, polymorphism, abstraction, and encapsulation — applied to a realistic, layered web application.

---

## ✨ Features

**Customer**
- Register / login with secure password hashing
- Browse and search the vehicle catalog by category, brand, and availability
- Book a vehicle for a date range
- Checkout with card or cash payment, and view a generated receipt
- View booking history and submit reviews (verified renters vs. public reviewers)

**Admin**
- Dashboard overview of the system
- Manage vehicles, categories, users, bookings, payments, and reviews (full CRUD)
- View and confirm/reject payments
- Moderate reviews

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Framework | Spring Boot 3.2.0 (`spring-boot-starter-web`) |
| Web Layer | Jakarta Servlets + JSP (JavaServer Pages) |
| Server | Embedded Tomcat (`tomcat-embed-jasper`) |
| Build Tool | Maven (packaged as `.war`) |
| Data Storage | Flat CSV-style text files (`/data`) — no external database required |
| Testing | JUnit + Maven Surefire |
| Frontend | HTML, JSP, CSS |

> The project intentionally uses file-based storage instead of a database, keeping the focus on core Java/OOP design rather than persistence frameworks.

---

## 🧱 Architecture & OOP Design

The application follows a layered architecture:

```
Browser → Servlet (Controller) → Service (Business Logic) → FileHandler (Data Access) → JSP (View)
```

Key OOP concepts demonstrated in the model layer:

- **Inheritance & Polymorphism**
  - `Vehicle` → `Car`, `Bike`, `Van` (each overrides `getDescription()`)
  - `Payment` → `CardPayment`, `CashPayment` (each overrides `generateReceipt()`)
  - `Review` → `VerifiedReview`, `PublicReview` (each overrides `displayReview()`)
- **Abstraction & Factory Pattern**
  - `User` is an abstract class → `CustomerUser`, `AdminUser`, created via a static factory method `User.createUser(...)`
- **Encapsulation**
  - All model fields are private with controlled access via getters/setters, plus built-in data sanitization (e.g. comma-escaping to protect the CSV file format)
- **Concurrency safety**
  - `FileHandler` uses `synchronized` methods to safely generate unique IDs under concurrent requests

Security highlights:
- Passwords are hashed with **PBKDF2WithHmacSHA256** (salted, 120,000 iterations) rather than stored in plaintext
- User input is HTML-escaped to prevent XSS

---

## 📁 Project Structure

```
src/main/java/com/vehiclerental/
├── model/       # Vehicle, User, Payment, Review, Booking, Category, VehicleDetails
├── service/     # Business logic per entity (UserService, VehicleService, BookingService, ...)
├── servlet/     # HTTP controllers (@WebServlet) — UserServlet, VehicleServlet, BookingServlet, ...
├── util/        # PasswordUtil (hashing), HtmlUtils (escaping)
└── FileHandler.java   # Central file read/write/ID-generation utility

src/main/webapp/
├── *.html                 # Public pages (login, register, index)
└── WEB-INF/views/*.jsp    # Customer & admin views

data/            # Flat-file "database" (users, vehicles, bookings, payments, reviews, categories)
src/test/java/   # JUnit unit tests
```

---

## 🚀 Getting Started

### Prerequisites
- Java 21 (JDK)
- Maven 3.8+

### Run locally
```bash
git clone https://github.com/IT25101174/vehicle-rental-service.git
cd vehicle-rental-service
mvn spring-boot:run
```
The app will start on **http://localhost:8080**.

### Run tests
```bash
mvn test
```

### Build a deployable WAR
```bash
mvn clean package
```
The generated `.war` file (in `target/`) can also be deployed to an external Tomcat server.

---

## 🧪 Testing

Unit tests cover core service logic and utilities:
- `UserServiceTest` — registration & login logic
- `VehicleServiceTest` — vehicle CRUD operations
- `BookingServiceTest` — booking creation & validation
- `PasswordUtilTest` — password hashing correctness

Run with `mvn test`; reports are generated under `target/surefire-reports`.

---

## 👥 Team

This project was built collaboratively as an OOP module group assignment:

- Ihjas
- Thamira 
- Punara
- Praveen 
- Nirmani
- Budhima

---

## 📌 Notes

- This project uses flat text files instead of a relational database — a deliberate scope decision for the OOP module. A natural next step would be migrating to a real database (e.g. via Spring Data JPA) and exposing a REST API.
- Sample data in `/data` is for demo purposes only.

---

## 📄 License

This project was created for academic purposes as part of the SLIIT OOP module coursework.
