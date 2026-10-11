-- Student Name: Giang Anh Tú
-- Student ID: 24070407

USE university_db;

-- Query 1: Basic SELECT
SELECT * 
FROM students;

-- Query 2: WHERE with comparison
SELECT 
    id, 
    student_id, 
    course_id, 
    semester_id, 
    grade_point, 
    grade_letter, 
    status
FROM enrollments
WHERE grade_point >= 3.50;

-- Query 3: WHERE with AND/OR
SELECT 
    id, 
    student_id, 
    course_id, 
    semester_id, 
    grade_point, 
    grade_letter, 
    status
FROM enrollments
WHERE grade_point >= 3.50 AND grade_letter = 'A';

-- Query 4: ORDER BY
SELECT 
    id, 
    student_code, 
    full_name, 
    email, 
    department_id, 
    enrollment_date
FROM students
ORDER BY full_name ASC;


-- Query 5: LIMIT
SELECT 
    id, 
    student_id, 
    course_id, 
    semester_id, 
    grade_point, 
    grade_letter
FROM enrollments
WHERE grade_point IS NOT NULL
ORDER BY grade_point DESC
LIMIT 3;

-- Query 6: LIKE
SELECT 
    id, 
    course_code, 
    course_name, 
    credits, 
    department_id
FROM courses
WHERE course_name LIKE '%Introduction%';

-- Query 7: Aggregate — COUNT / SUM
SELECT 
    COUNT(*) AS total_courses,
    SUM(credits) AS total_credits,
    ROUND(AVG(credits), 2) AS average_credits
FROM courses;

-- Query 8: Aggregate with GROUP BY + HAVING
SELECT 
    department_id,
    COUNT(*) AS course_count
FROM courses
GROUP BY department_id
HAVING COUNT(*) >= 2
ORDER BY department_id ASC;


-- Query 9: JOIN — two tables
SELECT 
    c.course_code, 
    c.course_name, 
    i.full_name AS instructor_name, 
    i.academic_title
FROM courses c
JOIN instructors i ON c.instructor_id = i.id
ORDER BY c.course_code ASC;


-- Query 10: JOIN — three or more tables
SELECT 
    e.id AS enrollment_id,
    s.full_name AS student_name,
    c.course_name,
    sem.name AS semester_name,
    e.grade_point,
    e.grade_letter,
    e.status
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
JOIN semesters sem ON e.semester_id = sem.id
ORDER BY e.id ASC;