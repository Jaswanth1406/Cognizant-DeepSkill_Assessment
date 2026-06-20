# 🎓 Student Course Registration System

<div align="center">

![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)
![Alembic](https://img.shields.io/badge/Alembic-Migrations-orange?style=for-the-badge)
![VS Code](https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)

</div>

---

## 📌 Project Overview

This project implements a **Student Course Registration System** using multiple database technologies as part of the **Digital Nurture 5.0 – Database Integration Module**.

The project demonstrates:

- Relational Database Design
- SQL Querying and Optimization
- MongoDB Document Modeling
- SQLAlchemy ORM Integration
- Database Migrations using Alembic
- Transaction Management
- Indexing and Performance Optimization

---

## 🚀 Technologies Used

| Technology | Purpose |
|------------|----------|
| PostgreSQL | Relational Database |
| MySQL | Relational Database |
| MongoDB | NoSQL Database |
| Python | Backend Development |
| SQLAlchemy | ORM Integration |
| Alembic | Database Migrations |
| VS Code | Development Environment |

---

## 🗂️ Project Structure

```text
DatabaseIntegration/
│
├── HandsOn1/
│   └── Schema Design & Normalization
│
├── HandsOn2/
│   └── SQL Queries, Joins & Aggregations
│
├── HandsOn3/
│   └── Subqueries, Views & Transactions
│
├── HandsOn4/
│   └── Query Optimization & Indexing
│
├── HandsOn5/
│   └── MongoDB CRUD & Aggregation Pipeline
│
├── HandsOn6/
│   ├── models.py
│   └── crud.py
│
├── HandsOn7/
│   ├── migrations/
│   └── alembic.ini
│
└── README.md
```

---

# 📚 Hands-On Exercises

## 🔹 Hands-On 1
### Database Schema Design & Normalization

Implemented:

- Database creation
- Table creation using DDL
- Primary Keys
- Foreign Keys
- Unique Constraints
- Check Constraints
- 1NF, 2NF, 3NF Analysis
- ALTER TABLE Operations

---

## 🔹 Hands-On 2
### SQL Queries & Aggregations

Implemented:

✅ INSERT

✅ UPDATE

✅ DELETE

✅ SELECT

✅ WHERE

✅ ORDER BY

✅ GROUP BY

✅ HAVING

✅ INNER JOIN

✅ LEFT JOIN

✅ Aggregate Functions

---

## 🔹 Hands-On 3
### Advanced SQL

Implemented:

- Subqueries
- Correlated Subqueries
- Views
- Stored Procedures / Functions
- Transactions
- COMMIT
- ROLLBACK
- SAVEPOINT

---

## 🔹 Hands-On 4
### Query Optimization

Implemented:

- EXPLAIN Plans
- Index Creation
- Composite Indexes
- Partial Indexes
- Query Analysis
- N+1 Query Problem Simulation

---

## 🔹 Hands-On 5
### MongoDB Integration

Implemented:

- Database Creation
- Collections
- CRUD Operations
- Aggregation Pipeline
- BSON Documents
- Array Queries
- MongoDB Indexing

Example Document:

```json
{
  "student_id": 1,
  "course_code": "CS101",
  "rating": 5,
  "comments": "Excellent teaching",
  "tags": ["challenging", "well-structured"]
}
```

---

## 🔹 Hands-On 6
### SQLAlchemy ORM

Implemented:

- ORM Models
- Relationships
- CRUD Operations
- Sessions
- joinedload()
- N+1 Query Fix

Example:

```python
session.query(Enrollment).options(
    joinedload(Enrollment.student),
    joinedload(Enrollment.course)
).all()
```

---

## 🔹 Hands-On 7
### Alembic Migrations

Implemented:

- Alembic Setup
- Initial Migration
- Auto-generated Migrations
- Upgrade & Downgrade
- Schema Version Control
- Rollback Recovery

Commands Used:

```bash
alembic revision --autogenerate -m "initial schema"

alembic upgrade head

alembic downgrade -1
```

---

## 🏗️ Database Schema

```text
Departments
    │
    ├── Students
    │       │
    │       └── Enrollments
    │               │
    │               └── Courses
    │
    └── Professors
```

---

## 🎯 Learning Outcomes

Through this project, I gained hands-on experience in:

- Relational Database Design
- Database Normalization
- Advanced SQL Queries
- Query Optimization
- MongoDB Development
- ORM Development using SQLAlchemy
- Database Version Control using Alembic
- Transaction Management
- Performance Tuning

---

## 📖 Concepts Covered

- DDL & DML Commands
- Joins and Aggregations
- Subqueries and Views
- Stored Procedures
- Transactions and Savepoints
- Indexing Strategies
- MongoDB Aggregation Pipelines
- SQLAlchemy ORM
- Alembic Migrations
- N+1 Query Optimization

---

## 👨‍💻 Author

**Jaswanth Prasanna**

Digital Nurture 5.0 – Python Full Stack Engineer Track

---

