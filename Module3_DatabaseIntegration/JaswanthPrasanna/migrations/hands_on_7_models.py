# ============================================================
# TASK 1 — SQLAlchemy Models (Baseline for Alembic)
# TASK 2 — Updated: added is_active to Student, added CourseSchedule
# ============================================================

from sqlalchemy import (
    create_engine, Column, Integer, String, Date, Numeric,
    ForeignKey, UniqueConstraint, Boolean, Time
)
from sqlalchemy.orm import declarative_base, relationship

engine = create_engine(
    "postgresql+psycopg2://postgres:your_password@localhost:5432/college_db_orm",
    echo=True
)

Base = declarative_base()


class Department(Base):
    __tablename__ = "departments"

    dept_id = Column(Integer, primary_key=True, autoincrement=True)
    dept_name = Column(String(100), nullable=False, unique=True)
    head_of_dept = Column(String(100), nullable=False)
    location = Column(String(100))
    budget = Column(Numeric(12, 2))

    students = relationship("Student", back_populates="department")
    courses = relationship("Course", back_populates="department")
    professors = relationship("Professor", back_populates="department")


class Student(Base):
    __tablename__ = "students"

    student_id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    dob = Column(Date, nullable=False)
    dept_id = Column(Integer, ForeignKey("departments.dept_id"), nullable=False)
    enrollment_year = Column(Integer)
    is_active = Column(Boolean, default=True)   # added in Task 2 Step 98

    department = relationship("Department", back_populates="students")
    enrollments = relationship("Enrollment", back_populates="student")


class Course(Base):
    __tablename__ = "courses"

    course_id = Column(Integer, primary_key=True, autoincrement=True)
    course_name = Column(String(150), nullable=False)
    credits = Column(Integer, nullable=False)
    dept_id = Column(Integer, ForeignKey("departments.dept_id"), nullable=False)
    max_seats = Column(Integer, default=60)

    department = relationship("Department", back_populates="courses")
    enrollments = relationship("Enrollment", back_populates="course")
    schedules = relationship("CourseSchedule", back_populates="course")


class Professor(Base):
    __tablename__ = "professors"

    professor_id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    hire_date = Column(Date)
    dept_id = Column(Integer, ForeignKey("departments.dept_id"), nullable=False)
    salary = Column(Numeric(10, 2))

    department = relationship("Department", back_populates="professors")


class Enrollment(Base):
    __tablename__ = "enrollments"
    __table_args__ = (UniqueConstraint("student_id", "course_id"),)

    enrollment_id = Column(Integer, primary_key=True, autoincrement=True)
    student_id = Column(Integer, ForeignKey("students.student_id"), nullable=False)
    course_id = Column(Integer, ForeignKey("courses.course_id"), nullable=False)
    enrolled_on = Column(Date)
    grade = Column(String(1))

    student = relationship("Student", back_populates="enrollments")
    course = relationship("Course", back_populates="enrollments")


class CourseSchedule(Base):                     # added in Task 2 Step 102
    __tablename__ = "course_schedules"

    schedule_id = Column(Integer, primary_key=True, autoincrement=True)
    course_id = Column(Integer, ForeignKey("courses.course_id"), nullable=False)
    day_of_week = Column(String(10), nullable=False)
    start_time = Column(Time, nullable=False)
    end_time = Column(Time, nullable=False)

    course = relationship("Course", back_populates="schedules")


if __name__ == "__main__":
    Base.metadata.create_all(engine)
    print("All tables created in college_db_orm.")