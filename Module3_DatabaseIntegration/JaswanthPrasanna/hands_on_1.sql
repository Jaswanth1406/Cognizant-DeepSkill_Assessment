-- ============================================================
-- TASK 1 — Create the Database and All Five Tables
-- ============================================================

-- ----------------------------------------------------------------
-- Table 1: departments 
-- ----------------------------------------------------------------
CREATE TABLE departments (
    dept_id     SERIAL          PRIMARY KEY,          
    dept_name   VARCHAR(100)    NOT NULL UNIQUE,
    hod_name    VARCHAR(100)    NOT NULL,             
    location    VARCHAR(100)
);

-- ----------------------------------------------------------------
-- Table 2: students
-- ----------------------------------------------------------------
CREATE TABLE students (
    student_id  SERIAL          PRIMARY KEY,          
    first_name  VARCHAR(50)     NOT NULL,
    last_name   VARCHAR(50)     NOT NULL,
    email       VARCHAR(100)    NOT NULL UNIQUE,
    dob         DATE            NOT NULL,
    dept_id     INT             NOT NULL,
    CONSTRAINT fk_student_dept
        FOREIGN KEY (dept_id)
        REFERENCES departments (dept_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ----------------------------------------------------------------
-- Table 3: courses
-- ----------------------------------------------------------------
CREATE TABLE courses (
    course_id   SERIAL          PRIMARY KEY,          
    course_name VARCHAR(150)    NOT NULL,
    credits     INT             NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id     INT             NOT NULL,
    CONSTRAINT fk_course_dept
        FOREIGN KEY (dept_id)
        REFERENCES departments (dept_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ----------------------------------------------------------------
-- Table 4: professors
-- ----------------------------------------------------------------
CREATE TABLE professors (
    professor_id    SERIAL          PRIMARY KEY,      
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    email           VARCHAR(100)    NOT NULL UNIQUE,
    hire_date       DATE,
    dept_id         INT             NOT NULL,
    CONSTRAINT fk_prof_dept
        FOREIGN KEY (dept_id)
        REFERENCES departments (dept_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ----------------------------------------------------------------
-- Table 5: enrollments  (composite candidate key: student_id + course_id)
-- ----------------------------------------------------------------
CREATE TABLE enrollments (
    enrollment_id   SERIAL      PRIMARY KEY,          
    student_id      INT         NOT NULL,
    course_id       INT         NOT NULL,
    enrolled_on     DATE        NOT NULL DEFAULT CURRENT_DATE,
    grade           CHAR(1),                          
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES students (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course
        FOREIGN KEY (course_id)
        REFERENCES courses (course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- TASK 2 — Normalisation Analysis (documented as SQL comments)
-- ============================================================

-- -----------------------------------------------------------------------
-- 1NF — First Normal Form
-- -----------------------------------------------------------------------
-- Rule: Every column must hold a single, atomic (indivisible) value.
--       Each row must be uniquely identifiable (primary key exists).
--
-- COMPLIANT:
--   • All columns store exactly one value per cell.
--     e.g., students.email holds ONE email address, not a comma-separated list.
--   • Every table has a single-column SERIAL PRIMARY KEY.
--
-- HYPOTHETICAL VIOLATION (not in our schema):
--   If we had stored  phones VARCHAR(200) = '9876543210,9123456789'
--   that would break 1NF because one cell holds multiple phone numbers.
--   Fix: move phone numbers to a separate students_phones(student_id, phone) table.
-- -----------------------------------------------------------------------


-- -----------------------------------------------------------------------
-- 2NF — Second Normal Form
-- -----------------------------------------------------------------------
-- Rule: Must be in 1NF AND every non-key column must depend on the
--       WHOLE primary key (no partial dependency).
--       Partial dependency is only possible when the primary key is composite.
--
-- FOCUS TABLE: enrollments
--   Natural composite key (business key) = (student_id, course_id).
--   Our schema uses enrollment_id as a surrogate PK, but the UNIQUE constraint
--   on (student_id, course_id) preserves the business key semantics.
--
-- COMPLIANT:
--   • enrolled_on — the date a specific student enrolled in a specific course.
--     It depends on BOTH student_id AND course_id together. ✓
--   • grade        — the grade a specific student earned in a specific course.
--     It depends on BOTH student_id AND course_id together. ✓
--
-- HYPOTHETICAL VIOLATION:
--   If we added  student_name VARCHAR(100)  to enrollments,
--   that would partially depend on student_id alone (not on course_id).
--   Fix: student_name already lives in students table — join when needed.
-- -----------------------------------------------------------------------


-- -----------------------------------------------------------------------
-- 3NF — Third Normal Form
-- -----------------------------------------------------------------------
-- Rule: Must be in 2NF AND there must be NO transitive dependencies.
--       A transitive dependency is: non-key column C depends on non-key
--       column B, which depends on the primary key A.
--
-- FOCUS TABLE: enrollments (and students)
--
-- COMPLIANT — enrollments:
--   • grade and enrolled_on depend directly on enrollment_id (or the
--     composite business key). Neither depends on another non-key column.
--     No transitive dependency exists here. ✓
--
-- COMPLIANT — students:
--   • dept_id is a FK to departments. We store ONLY dept_id in students,
--     NOT dept_name.
--   • If we had stored dept_name in students, that would be a transitive
--     dependency:  student_id → dept_id → dept_name
--     Fix already applied: dept_name lives only in departments table;
--     obtain it via JOIN. ✓
--
-- COMPLIANT — courses:
--   • Similarly, courses stores dept_id (FK), not dept_name. ✓
-- -----------------------------------------------------------------------


-- ============================================================
-- TASK 3 — Alter and Extend the Schema
-- ============================================================

-- Step 10: Add phone_number to students
ALTER TABLE students
    ADD COLUMN phone_number VARCHAR(15);

-- Verify (PostgreSQL):
--   SELECT column_name, data_type FROM information_schema.columns
--   WHERE table_name = 'students' AND column_name = 'phone_number';


-- ----------------------------------------------------------------
-- Step 11: Add max_seats to courses with default 60
-- ----------------------------------------------------------------
ALTER TABLE courses
    ADD COLUMN max_seats INT DEFAULT 60;

-- ----------------------------------------------------------------
-- Step 12: Add CHECK constraint on enrollments.grade
-- ----------------------------------------------------------------
-- PostgreSQL / MySQL 8+: CHECK constraints are enforced.
ALTER TABLE enrollments
    ADD CONSTRAINT chk_grade
        CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

-- ----------------------------------------------------------------
-- Step 13: Rename hod_name → head_of_dept in departments
-- ----------------------------------------------------------------

-- PostgreSQL syntax:
ALTER TABLE departments
    RENAME COLUMN hod_name TO head_of_dept;

-- MySQL syntax (uncomment if using MySQL):
-- ALTER TABLE departments
--     CHANGE hod_name head_of_dept VARCHAR(100) NOT NULL;

-- ----------------------------------------------------------------
-- Step 14: Drop phone_number (schema rollback simulation)
-- ----------------------------------------------------------------
ALTER TABLE departments
    DROP COLUMN IF EXISTS phone_number;   -- safety guard: no-op if absent

ALTER TABLE students
    DROP COLUMN IF EXISTS phone_number;

-- PostgreSQL: DROP COLUMN IF EXISTS is supported.
-- MySQL:      DROP COLUMN IF EXISTS supported from MySQL 8.0.29+.
--             For older MySQL use:  ALTER TABLE students DROP COLUMN phone_number;


-- ============================================================
-- Final Schema Verification Queries
-- ============================================================

-- PostgreSQL — list all columns for every table:
-- \d departments
-- \d students
-- \d courses
-- \d professors
-- \d enrollments

-- Universal INFORMATION_SCHEMA query (works in both PostgreSQL & MySQL):
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'          -- PostgreSQL uses 'public'; MySQL: use database name
  AND table_name IN ('departments','students','courses','professors','enrollments')
ORDER BY table_name, ordinal_position;

