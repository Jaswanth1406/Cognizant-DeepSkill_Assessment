
ALTER TABLE professors
    ADD COLUMN IF NOT EXISTS salary NUMERIC(10,2);

ALTER TABLE students
    ADD COLUMN IF NOT EXISTS enrollment_year INT;

ALTER TABLE departments
    ADD COLUMN IF NOT EXISTS budget NUMERIC(12,2);

-- ============================================================
-- TASK 1 — INSERT / UPDATE / DELETE
-- ============================================================


-- departments
INSERT INTO departments (dept_name, head_of_dept, location , budget) VALUES
    ('Computer Science',       'Dr. Alan Turing',    'Block A', 750000.00),
    ('Mathematics',            'Dr. Emmy Noether',   'Block B', 620000.00),
    ('Electronics',            'Dr. Nikola Tesla',   'Block C', 580000.00),
    ('Mechanical Engineering', 'Dr. Marie Curie',    'Block D', 490000.00);

-- students  (8 sample rows; 2 more added in Step 16)
INSERT INTO students (first_name, last_name, email, dob, dept_id, enrollment_year) VALUES
    ('Alice',   'Johnson',  'alice.johnson@college.edu',  '2001-03-15', 1, 2021),
    ('Bob',     'Smith',    'bob.smith@college.edu',      '2000-07-22', 1, 2021),
    ('Carol',   'Williams', 'carol.williams@college.edu', '2002-01-10', 2, 2022),
    ('David',   'Brown',    'david.brown@college.edu',    '2001-11-05', 2, 2022),
    ('Eva',     'Davis',    'eva.davis@college.edu',      '2002-06-30', 3, 2022),
    ('Frank',   'Miller',   'frank.miller@college.edu',   '2000-09-18', 3, 2021),
    ('Grace',   'Wilson',   'grace.wilson@college.edu',   '2003-02-28', 4, 2023),
    ('Henry',   'Moore',    'henry.moore@college.edu',    '2001-12-14', 1, 2022);

-- courses
INSERT INTO courses (course_name, credits, dept_id) VALUES
    ('CS101 - Intro to Programming',      4, 1),
    ('CS201 - Data Structures',           4, 1),
    ('MA101 - Calculus I',                3, 2),
    ('EC101 - Circuit Theory',            3, 3),
    ('ME101 - Engineering Mechanics',     3, 4);

-- professors
INSERT INTO professors (first_name, last_name, email, hire_date, dept_id, salary) VALUES
    ('Samuel',  'Clark',    'samuel.clark@college.edu',   '2015-08-01', 1,  92000.00),
    ('Linda',   'Harris',   'linda.harris@college.edu',   '2018-01-15', 1,  85000.00),
    ('Michael', 'Lee',      'michael.lee@college.edu',    '2012-06-10', 2,  78000.00),
    ('Sophia',  'Martinez', 'sophia.martinez@college.edu','2019-09-01', 3,  95000.00),
    ('James',   'Anderson', 'james.anderson@college.edu', '2016-03-20', 4,  88000.00),
    ('Priya',   'Nair',     'priya.nair@college.edu',     '2020-07-05', 2,  82000.00);

-- enrollments  (includes one NULL grade row for Step 18 DELETE preview)
INSERT INTO enrollments (student_id, course_id, enrolled_on, grade) VALUES
    (1, 1, '2021-08-01', 'A'),
    (1, 2, '2021-08-01', 'B'),
    (2, 1, '2021-08-01', 'B'),
    (2, 3, '2021-08-01', 'A'),
    (3, 3, '2022-08-01', 'C'),
    (3, 4, '2022-08-01', 'B'),
    (4, 3, '2022-08-01', 'A'),
    (5, 1, '2022-08-01', 'C'),   -- grade updated to 'B' in Step 17
    (5, 4, '2022-08-01', 'B'),
    (6, 2, '2021-08-01', 'A'),
    (7, 5, '2023-08-01',  NULL), -- grade not yet assigned → deleted in Step 18
    (8, 1, '2022-08-01', 'D'),
    (8, 2, '2022-08-01',  NULL); -- grade not yet assigned → deleted in Step 18

SELECT COUNT(*) AS enrollment_rows_after_insert FROM enrollments;
-- Expected: 13

-- ----------------------------------------------------------------
-- Step 16: Insert two additional students of our own choosing
-- ----------------------------------------------------------------
INSERT INTO students (first_name, last_name, email, dob, dept_id, enrollment_year) VALUES
    ('Ishaan',  'Kapoor',   'ishaan.kapoor@college.edu',  '2002-04-11', 1, 2023),
    ('Divya',   'Ramesh',   'divya.ramesh@college.edu',   '2003-09-25', 2, 2023);

SELECT COUNT(*) AS student_rows_after_insert FROM students;
-- Expected: 10

-- ----------------------------------------------------------------
-- Step 17: Update grade of student_id=5 for course_id=1 from 'C' to 'B'
-- ----------------------------------------------------------------
UPDATE enrollments
SET    grade = 'B'
WHERE  student_id = 5
  AND  course_id  = 1;

-- Verify:
SELECT student_id, course_id, grade
FROM   enrollments
WHERE  student_id = 5 AND course_id = 1;
-- Expected: grade = 'B'

-- Preview rows to be deleted:
SELECT *
FROM   enrollments
WHERE  grade IS NULL;

-- Delete:
DELETE FROM enrollments
WHERE  grade IS NULL;

SELECT COUNT(*) AS enrollment_rows_after_delete FROM enrollments;
-- Expected: 11 (13 inserted − 2 NULL grade rows)


-- ============================================================
-- TASK 2 — Single-Table Queries and Filtering
-- ============================================================


SELECT student_id,
       first_name,
       last_name,
       email,
       enrollment_year
FROM   students
WHERE  enrollment_year = 2022
ORDER  BY last_name ASC;


SELECT course_id,
       course_name,
       credits
FROM   courses
WHERE  credits > 3
ORDER  BY credits DESC;


SELECT professor_id,
       first_name || ' ' || last_name  AS full_name,
       salary
FROM   professors
WHERE  salary BETWEEN 80000 AND 95000
ORDER  BY salary DESC;


SELECT student_id,
       first_name,
       last_name,
       email
FROM   students
WHERE  email LIKE '%@college.edu';


SELECT enrollment_year,
       COUNT(*) AS total_students
FROM   students
GROUP  BY enrollment_year
ORDER  BY enrollment_year;


-- ============================================================
-- TASK 3 — Multi-Table JOINs
-- ============================================================


SELECT s.student_id,
       s.first_name || ' ' || s.last_name  AS full_name,   
       d.dept_name
FROM   students    s
JOIN   departments d ON s.dept_id = d.dept_id
ORDER  BY full_name;


SELECT e.enrollment_id,
       s.first_name || ' ' || s.last_name  AS student_name,
       c.course_name,
       e.enrolled_on,
       e.grade
FROM   enrollments e
JOIN   students    s ON e.student_id = s.student_id
JOIN   courses     c ON e.course_id  = c.course_id
ORDER  BY e.enrollment_id;


SELECT s.student_id,
       s.first_name || ' ' || s.last_name  AS full_name,
       s.email
FROM   students    s
LEFT   JOIN enrollments e ON s.student_id = e.student_id
WHERE  e.enrollment_id IS NULL;


SELECT c.course_id,
       c.course_name,
       COUNT(e.enrollment_id) AS enrolled_students
FROM   courses     c
LEFT   JOIN enrollments e ON c.course_id = e.course_id
GROUP  BY c.course_id, c.course_name
ORDER  BY enrolled_students DESC;

SELECT d.dept_name,
       p.first_name || ' ' || p.last_name  AS professor_name,
       p.salary
FROM   departments d
LEFT   JOIN professors p ON d.dept_id = p.dept_id
ORDER  BY d.dept_name, professor_name;


-- ============================================================
-- TASK 4 — Aggregations and GROUP BY / HAVING
-- ============================================================


SELECT c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM   courses     c
LEFT   JOIN enrollments e ON c.course_id = e.course_id
GROUP  BY c.course_name
ORDER  BY enrollment_count DESC;


SELECT d.dept_name,
       ROUND(AVG(p.salary), 2) AS avg_salary
FROM   departments d
JOIN   professors  p ON d.dept_id = p.dept_id
GROUP  BY d.dept_name
ORDER  BY avg_salary DESC;

SELECT dept_id,
       dept_name,
       budget
FROM   departments
WHERE  budget > 600000
ORDER  BY budget DESC;


SELECT e.grade,
       COUNT(*) AS grade_count
FROM   enrollments e
JOIN   courses     c ON e.course_id = c.course_id
WHERE  c.course_name LIKE 'CS101%'
GROUP  BY e.grade
ORDER  BY e.grade;


SELECT d.dept_name,
       COUNT(DISTINCT e.student_id) AS enrolled_students
FROM   departments  d
JOIN   courses      c  ON d.dept_id    = c.dept_id
JOIN   enrollments  e  ON c.course_id  = e.course_id
GROUP  BY d.dept_name
HAVING COUNT(DISTINCT e.student_id) > 2
ORDER  BY enrolled_students DESC;