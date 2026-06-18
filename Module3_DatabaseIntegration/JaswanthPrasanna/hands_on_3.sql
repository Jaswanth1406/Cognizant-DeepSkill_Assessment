-- ============================================================
-- TASK 1 — Subqueries
-- ============================================================

SELECT s.student_id,
       s.first_name || ' ' || s.last_name AS full_name,
       COUNT(e.course_id)                 AS courses_enrolled
FROM   students    s
JOIN   enrollments e ON s.student_id = e.student_id
GROUP  BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > (
    -- non-correlated: runs once, returns a single scalar
    SELECT AVG(course_count)
    FROM  (
        SELECT COUNT(course_id) AS course_count
        FROM   enrollments
        GROUP  BY student_id
    ) AS per_student
)
ORDER  BY courses_enrolled DESC;

SELECT c.course_id,
       c.course_name
FROM   courses c
WHERE  EXISTS (
    -- course has at least one enrollment
    SELECT 1 FROM enrollments e WHERE e.course_id = c.course_id
)
AND NOT EXISTS (
    -- no enrollment exists for this course where grade <> 'A'
    SELECT 1
    FROM   enrollments e
    WHERE  e.course_id = c.course_id
      AND  (e.grade <> 'A' OR e.grade IS NULL)
)
ORDER  BY c.course_name;

SELECT p.professor_id,
       p.first_name || ' ' || p.last_name AS professor_name,
       d.dept_name,
       p.salary
FROM   professors  p
JOIN   departments d ON p.dept_id = d.dept_id
WHERE  p.salary = (
    -- correlated: finds max salary within the same dept as outer row
    SELECT MAX(p2.salary)
    FROM   professors p2
    WHERE  p2.dept_id = p.dept_id
)
ORDER  BY d.dept_name;

SELECT dept_summary.dept_name,
       dept_summary.avg_salary
FROM  (
    -- derived table: must have an alias
    SELECT d.dept_name,
           ROUND(AVG(p.salary), 2) AS avg_salary
    FROM   departments d
    JOIN   professors  p ON d.dept_id = p.dept_id
    GROUP  BY d.dept_name
) AS dept_summary
WHERE  dept_summary.avg_salary > 85000
ORDER  BY dept_summary.avg_salary DESC;

-- ============================================================
-- TASK 2 — Creating and Using Views
-- ============================================================

CREATE OR REPLACE VIEW vw_student_enrollment_summary AS
SELECT
    s.student_id,
    s.first_name || ' ' || s.last_name                        AS full_name,
    d.dept_name,
    COUNT(e.course_id)                                         AS courses_enrolled,
    ROUND(
        AVG(
            CASE e.grade
                WHEN 'A' THEN 4
                WHEN 'B' THEN 3
                WHEN 'C' THEN 2
                WHEN 'D' THEN 1
                WHEN 'F' THEN 0
                ELSE NULL          -- NULL grades excluded from AVG
            END
        ), 2
    )                                                          AS gpa
FROM   students    s
JOIN   departments d  ON s.dept_id    = d.dept_id
LEFT   JOIN enrollments e ON s.student_id = e.student_id
GROUP  BY s.student_id, s.first_name, s.last_name, d.dept_name;

CREATE OR REPLACE VIEW vw_course_stats AS
SELECT
    c.course_id,
    c.course_name,
    COUNT(e.enrollment_id)                                     AS total_enrollments,
    ROUND(
        AVG(
            CASE e.grade
                WHEN 'A' THEN 4
                WHEN 'B' THEN 3
                WHEN 'C' THEN 2
                WHEN 'D' THEN 1
                WHEN 'F' THEN 0
                ELSE NULL
            END
        ), 2
    )                                                          AS avg_gpa
FROM   courses     c
LEFT   JOIN enrollments e ON c.course_id = e.course_id
GROUP  BY c.course_id, c.course_name;

SELECT * FROM vw_course_stats ORDER BY total_enrollments DESC;

SELECT full_name,
       dept_name,
       courses_enrolled,
       gpa
FROM   vw_student_enrollment_summary
WHERE  gpa > 3.0
ORDER  BY gpa DESC;

-- Uncomment to test:
-- UPDATE vw_student_enrollment_summary
-- SET    dept_name = 'Mathematics'
-- WHERE  student_id = 1;
--
-- ERROR: cannot update a view that involves multiple base tables.
-- PostgreSQL raises: "cannot update view vw_student_enrollment_summary"
--
-- WHY MULTI-TABLE VIEWS ARE NOT UPDATABLE:
-- A view spanning multiple tables (here: students + departments + enrollments)
-- cannot propagate an UPDATE unambiguously because the database engine cannot
-- determine which underlying base table row to modify.
-- For example, setting dept_name = 'Mathematics' could mean:
--   (a) update students.dept_id  — changes the student's FK reference, or
--   (b) update departments.dept_name — renames the whole department.
-- PostgreSQL (and the SQL standard) therefore disallows DML on such views.
-- A single-table view WITH no aggregation, DISTINCT, or GROUP BY IS updatable.

DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;

CREATE OR REPLACE VIEW vw_cs_students AS
SELECT student_id,
       first_name,
       last_name,
       email,
       dept_id,
       enrollment_year
FROM   students
WHERE  dept_id = 1
WITH   CHECK OPTION;
-- WITH CHECK OPTION: any INSERT or UPDATE through this view that would
-- produce a row with dept_id <> 1 is rejected, keeping the view consistent.

-- INSERT INTO vw_cs_students (first_name, last_name, email, dob, dept_id, enrollment_year)
-- VALUES ('Test', 'User', 'test@college.edu', '2001-01-01', 2, 2023);
-- ERROR: new row violates check option for view "vw_cs_students"

CREATE OR REPLACE VIEW vw_student_enrollment_summary AS
SELECT
    s.student_id,
    s.first_name || ' ' || s.last_name                        AS full_name,
    d.dept_name,
    COUNT(e.course_id)                                         AS courses_enrolled,
    ROUND(
        AVG(
            CASE e.grade
                WHEN 'A' THEN 4
                WHEN 'B' THEN 3
                WHEN 'C' THEN 2
                WHEN 'D' THEN 1
                WHEN 'F' THEN 0
                ELSE NULL
            END
        ), 2
    )                                                          AS gpa
FROM   students    s
JOIN   departments d  ON s.dept_id    = d.dept_id
LEFT   JOIN enrollments e ON s.student_id = e.student_id
GROUP  BY s.student_id, s.first_name, s.last_name, d.dept_name;

CREATE OR REPLACE VIEW vw_course_stats AS
SELECT
    c.course_id,
    c.course_name,
    COUNT(e.enrollment_id)                                     AS total_enrollments,
    ROUND(
        AVG(
            CASE e.grade
                WHEN 'A' THEN 4
                WHEN 'B' THEN 3
                WHEN 'C' THEN 2
                WHEN 'D' THEN 1
                WHEN 'F' THEN 0
                ELSE NULL
            END
        ), 2
    )                                                          AS avg_gpa
FROM   courses     c
LEFT   JOIN enrollments e ON c.course_id = e.course_id
GROUP  BY c.course_id, c.course_name;

-- ============================================================
-- TASK 3 — Functions & Transactions
-- ============================================================

CREATE TABLE IF NOT EXISTS department_transfer_log (
    log_id          SERIAL      PRIMARY KEY,
    student_id      INT         NOT NULL,
    from_dept_id    INT         NOT NULL,
    to_dept_id      INT         NOT NULL,
    transferred_on  TIMESTAMP   NOT NULL DEFAULT NOW(),
    notes           TEXT
);

CREATE OR REPLACE FUNCTION fn_enroll_student(
    p_student_id    INT,
    p_course_id     INT,
    p_enrolled_on   DATE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INT;
BEGIN
    -- Check for duplicate enrollment
    SELECT COUNT(*)
    INTO   v_exists
    FROM   enrollments
    WHERE  student_id = p_student_id
      AND  course_id  = p_course_id;

    IF v_exists > 0 THEN
        RAISE EXCEPTION
            'Duplicate enrollment: student % is already enrolled in course %.',
            p_student_id, p_course_id;
    END IF;

    -- Safe to insert
    INSERT INTO enrollments (student_id, course_id, enrolled_on, grade)
    VALUES (p_student_id, p_course_id, p_enrolled_on, NULL);

    RETURN FORMAT('Success: student %s enrolled in course %s on %s.',
                  p_student_id, p_course_id, p_enrolled_on);
END;
$$;

SELECT fn_enroll_student(9, 3, CURRENT_DATE);

-- SELECT fn_enroll_student(1, 1, CURRENT_DATE);
-- ERROR: Duplicate enrollment: student 1 is already enrolled in course 1.

CREATE OR REPLACE FUNCTION fn_transfer_student(
    p_student_id    INT,
    p_to_dept_id    INT,
    p_notes         TEXT DEFAULT NULL
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_from_dept_id  INT;
BEGIN
    -- Fetch current department
    SELECT dept_id
    INTO   v_from_dept_id
    FROM   students
    WHERE  student_id = p_student_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Student % not found.', p_student_id;
    END IF;

    IF v_from_dept_id = p_to_dept_id THEN
        RAISE EXCEPTION 'Student % is already in department %.', p_student_id, p_to_dept_id;
    END IF;

    UPDATE students
    SET    dept_id = p_to_dept_id
    WHERE  student_id = p_student_id;

    INSERT INTO department_transfer_log
           (student_id, from_dept_id, to_dept_id, transferred_on, notes)
    VALUES (p_student_id, v_from_dept_id, p_to_dept_id, NOW(), p_notes);

    RETURN FORMAT('Transferred student %s from dept %s to dept %s.',
                  p_student_id, v_from_dept_id, p_to_dept_id);

    -- If either statement above raises an exception, PostgreSQL automatically
    -- rolls back the entire function's transaction block.
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Transfer failed — rolled back. Detail: %', SQLERRM;
END;
$$;

SELECT fn_transfer_student(2, 2, 'Changing major to Mathematics');

SELECT student_id, first_name, dept_id FROM students WHERE student_id = 2;
SELECT * FROM department_transfer_log ORDER BY log_id DESC LIMIT 1;

DO $$
BEGIN
    -- This block simulates a failed transfer
    UPDATE students SET dept_id = 999 WHERE student_id = 3;   -- FK violation
    INSERT INTO department_transfer_log (student_id, from_dept_id, to_dept_id)
    VALUES (3, 2, 999);
    RAISE NOTICE 'Transfer committed.';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'ROLLBACK triggered: invalid dept_id 999. No changes saved.';
END;
$$;

SELECT student_id, first_name, dept_id FROM students WHERE student_id = 3;

DO $$
BEGIN
    -- First enrollment: Divya Ramesh (student_id=10) → CS101 (course_id=1)
    INSERT INTO enrollments (student_id, course_id, enrolled_on, grade)
    VALUES (10, 1, CURRENT_DATE, NULL);

    RAISE NOTICE 'First insert done.';

    -- Second enrollment: deliberately use non-existent course_id=999 (FK violation)
    -- The nested BEGIN...EXCEPTION...END acts as an implicit savepoint boundary.
    -- When the exception is caught, only the nested block is rolled back;
    -- the first INSERT above is preserved.
    BEGIN
        INSERT INTO enrollments (student_id, course_id, enrolled_on, grade)
        VALUES (10, 999, CURRENT_DATE, NULL);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Second insert failed (FK violation). Nested block rolled back; first insert preserved.';
    END;

    RAISE NOTICE 'Transaction complete. Only first insert should be saved.';
END;
$$;

SELECT * FROM enrollments WHERE student_id = 10;
