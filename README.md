# 🎓 Digital Nurture 5.0 - Full Stack & QA Engineering

<div align="center">

![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)
![Selenium](https://img.shields.io/badge/Selenium-43B02A?style=for-the-badge&logo=selenium&logoColor=white)
![Pytest](https://img.shields.io/badge/Pytest-0A9EDC?style=for-the-badge&logo=pytest&logoColor=white)

</div>

---

## 📌 Project Overview

This repository contains my comprehensive coursework for the **Cognizant Digital Nurture 5.0** program. The project is a complete **Student Course Registration & Management System** built across four major modules:

1. **Frontend Development (10 Hands-On)**
2. **Database Integration (10 Hands-On)**
3. **Python Backend Frameworks (10 Hands-On)**
4. **QA Concepts & Selenium Basics (7 Hands-On)**

Together, these modules demonstrate a full end-to-end understanding of modern web development, UI/UX, database modeling, scalable API architecture, microservices, and robust UI automation testing.

---

## 🚀 Technologies Used

| Category | Technologies |
|----------|-------------|
| **Frontend** | HTML5, CSS3, JavaScript (ES6+), React.js |
| **Databases** | PostgreSQL, MySQL, MongoDB |
| **Backend Frameworks** | FastAPI, Django, Flask |
| **ORM & Migrations** | SQLAlchemy, Alembic |
| **Security** | JWT, passlib (Bcrypt), OAuth2 |
| **QA Automation** | Selenium WebDriver, Pytest, pytest-html, webdriver-manager |

---

## 🗂️ Module 1: Frontend Development (10 Hands-On)

This module focused on building responsive, dynamic, and accessible user interfaces.

### 🔹 Hands-On 1 to 4: UI Foundations & JavaScript
- Designed responsive layouts using modern HTML5 and CSS3 (Flexbox, Grid).
- Implemented DOM manipulation, event handling, and ES6+ features in vanilla JavaScript.

### 🔹 Hands-On 5 to 7: React.js & State Management
- Built reusable functional components in React.js.
- Managed component lifecycle and state using Hooks (`useState`, `useEffect`).
- Implemented client-side routing using React Router.

### 🔹 Hands-On 8 to 10: API Integration & Advanced UI
- Integrated the frontend with backend REST APIs using Axios/Fetch.
- Managed complex form state, validation, and user authentication flows (JWT tokens).
- Optimized frontend rendering performance and built the final UI dashboard.

---

## 🗂️ Module 2: Database Integration (10 Hands-On)

This module focused on relational database design, query optimization, NoSQL concepts, and database migrations.

### 🔹 Hands-On 1 to 4: Schema Design, SQL Queries & Optimization
- Designed the relational schema (Students, Courses, Enrollments) and applied Normalization (1NF, 2NF, 3NF).
- Wrote advanced SQL DML/DDL, JOINS, subqueries, and stored procedures.
- Analyzed `EXPLAIN` plans and created Composite/Partial Indexes to optimize N+1 query problems.

### 🔹 Hands-On 5 to 7: MongoDB, SQLAlchemy & Alembic
- Modeled NoSQL BSON documents and utilized the MongoDB Aggregation Pipeline.
- Integrated SQLAlchemy, configuring relationships and sessions.
- Set up **Alembic** to manage database schema version control (`upgrade head`, `downgrade -1`, auto-generation).

### 🔹 Hands-On 8 to 10: Advanced DB Concepts
- Managed Data Integrity via Transactions (`COMMIT`, `ROLLBACK`, `SAVEPOINT`).
- Explored advanced data caching strategies and completed the database capstone integration.

---

## 🗂️ Module 3: Python Backend Frameworks (10 Hands-On)

This module focused on building the backend logic, exploring REST APIs, and transitioning to microservices.

### 🔹 Hands-On 1 to 4: API Foundations & CRUD
- Initialized **Django**, **Flask**, and **FastAPI** projects to compare framework philosophies.
- Implemented core routing, path parameters, query parameters, and Pydantic models.

### 🔹 Hands-On 5 to 7: Dependency Injection & Advanced FastAPI
- Mastered **FastAPI Dependency Injection** for database sessions.
- Integrated SQLAlchemy ORM directly into the API routes.
- Implemented **Background Tasks** for asynchronous processing.

### 🔹 Hands-On 8 & 9: REST Best Practices & Security
- Audited endpoints for RESTful naming conventions, standardized HTTP status codes, and API versioning.
- Secured the API using **OAuth2** with **JWT tokens**.
- Hashed passwords using **Bcrypt** and configured **CORS** against the OWASP top 10.

### 🔹 Hands-On 10: Microservices Architecture
- Decomposed the monolithic API into an **API Gateway**, a **Course Service** (Port 5001), and a **Student Service** (Port 5002).
- Implemented synchronous inter-service communication and handled fallback network faults (503 Service Unavailable).

---

## 🗂️ Module 4: QA Concepts & Selenium Basics (7 Hands-On)

This module established a theoretical testing foundation and implemented a highly scalable UI automation suite.

### 🔹 Hands-On 1 to 3: QA Theory & Strategy
- Explored the Defect Lifecycle, V-Model SDLC/TDLC mapping, and Shift-Left Agile testing strategies.
- Designed an Automation Strategy evaluating ROI and comparing framework architectures (Modular, Data-Driven, Hybrid).

### 🔹 Hands-On 4 & 5: Selenium WebDriver & Explicit Waits
- Configured Selenium WebDriver with Headless Chrome.
- Mastered robust locator strategies (ID, CSS, XPath).
- Eliminated test flakiness by replacing `time.sleep()` with intelligent **Explicit Waits** (`WebDriverWait`).

### 🔹 Hands-On 6: Pytest Integration
- Migrated scripts into a formal **pytest** suite using `conftest.py` for shared fixtures.
- Configured a dynamic hook to automatically capture and save screenshots on test failure.
- Generated rich HTML test reports using `pytest-html`.

### 🔹 Hands-On 7: Page Object Model (POM)
- Architected a highly maintainable test framework by completely separating UI locators from test logic.
- Built a reusable `BasePage` and specific page classes (`SimpleFormPage`, `CheckboxPage`), resulting in **zero** raw `driver.find_element` calls in the test files.

---

## 🎯 Learning Outcomes

Through this project, I gained production-ready experience in:
- Building responsive user interfaces using modern Frontend technologies.
- Designing normalized relational databases and optimizing complex queries.
- Managing database migrations through code (Alembic).
- Architecting and securing robust, versioned RESTful APIs and Microservices.
- Implementing scalable, non-flaky automation testing using the Page Object Model and Pytest.

---

## 👨‍💻 Author
**Jaswanth Prasanna**  
*Digital Nurture 5.0 – Full Stack Engineering Track*
