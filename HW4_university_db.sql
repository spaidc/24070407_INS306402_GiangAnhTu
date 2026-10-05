CREATE DATABASE university_db
USE university_db;

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,                        
    name VARCHAR(100) NOT NULL UNIQUE,                         
    description TEXT NULL,                                   
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP     
) ENGINE=InnoDB;

CREATE TABLE semesters (
    id INT AUTO_INCREMENT PRIMARY KEY,                       
    name VARCHAR(50) NOT NULL UNIQUE,                          
    start_date DATE NOT NULL,                                  
    end_date DATE NOT NULL,                                   
    status ENUM('planned', 'ongoing', 'completed')             
        NOT NULL DEFAULT 'planned',
    CHECK (end_date > start_date)                              
) ENGINE=InnoDB;

CREATE TABLE instructors (
    id INT AUTO_INCREMENT PRIMARY KEY,                       
    instructor_code VARCHAR(20) NOT NULL UNIQUE,             
    full_name VARCHAR(100) NOT NULL,                         
    email VARCHAR(150) NOT NULL UNIQUE,                        
    phone VARCHAR(20) NULL UNIQUE,                           
    gender ENUM('male', 'female', 'other') NOT NULL,           
    academic_title VARCHAR(50) NULL,                           
    department_id INT NOT NULL,                                
    hire_date DATE NOT NULL,                                   

    CONSTRAINT fk_instructors_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT                                      
        ON UPDATE CASCADE                                      
) ENGINE=InnoDB;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,                   
    student_code VARCHAR(20) NOT NULL UNIQUE,                 
    full_name VARCHAR(100) NOT NULL,                           
    email VARCHAR(150) NOT NULL UNIQUE,                         
    phone VARCHAR(20) NULL UNIQUE,                             
    gender ENUM('male', 'female', 'other') NOT NULL,          
    date_of_birth DATE NOT NULL,                               
    department_id INT NOT NULL,                                
    enrollment_date DATE NOT NULL,                             
    status ENUM('active', 'graduated', 'suspended', 'withdrawn')
        NOT NULL DEFAULT 'active',                             

    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT                                      
        ON UPDATE CASCADE                                       
) ENGINE=InnoDB;

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,                   
    course_code VARCHAR(20) NOT NULL UNIQUE,                   
    course_name VARCHAR(150) NOT NULL,                         
    description TEXT NULL,                                     
    credits INT NOT NULL DEFAULT 3,                            
    department_id INT NOT NULL,                                
    instructor_id INT NOT NULL,                                
    max_students INT NOT NULL DEFAULT 50,                      
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,    

    CONSTRAINT chk_courses_credits
        CHECK (credits BETWEEN 1 AND 6),                       

    CONSTRAINT chk_courses_max_students
        CHECK (max_students > 0),                              

    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT                                      
        ON UPDATE CASCADE,                                      

    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id)
        REFERENCES instructors(id)
        ON DELETE RESTRICT                                      
        ON UPDATE CASCADE                                       
) ENGINE=InnoDB;

CREATE TABLE enrollments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,                      
    student_id INT NOT NULL,                                   
    course_id INT NOT NULL,                                    
    semester_id INT NOT NULL,                                  
    enrolled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,   
    grade_point DECIMAL(4,2) NULL,                             
    grade_letter ENUM('A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F')
        NULL,                                                  
    status ENUM('enrolled', 'completed', 'dropped')
        NOT NULL DEFAULT 'enrolled',                           

    CONSTRAINT chk_enrollments_grade_point
        CHECK (grade_point IS NULL OR grade_point BETWEEN 0.00 AND 4.00),
                                                                    

    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE CASCADE                                      
        ON UPDATE CASCADE,                                    

    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE                                      
        ON UPDATE CASCADE,                                     

    CONSTRAINT fk_enrollments_semester
        FOREIGN KEY (semester_id)
        REFERENCES semesters(id)
        ON DELETE RESTRICT                                      
        ON UPDATE CASCADE,                                      

    CONSTRAINT unique_enrollment
        UNIQUE (student_id, course_id, semester_id)             
) ENGINE=InnoDB;

INSERT INTO departments (code, name, description) VALUES
('MIS', 'Management Information Systems',
 'Study of information systems, business processes, databases, and digital transformation.'),
('CS', 'Computer Science',
 'Study of algorithms, software engineering, artificial intelligence, and computing systems.'),
('DS', 'Data Science',
 'Study of statistics, machine learning, data analysis, and data-driven decision making.'),
('BA', 'Business Administration',
 'Study of management, marketing, finance, operations, and business strategy.'),
('FIN', 'Finance and Banking',
 'Study of finance, banking operations, investment, and financial management.'),
('SE', 'Software Engineering',
 'Study of software development processes, architecture, testing, and project management.');

INSERT INTO semesters (name, start_date, end_date, status) VALUES
('Fall 2024',   '2024-09-03', '2025-01-10', 'completed'),
('Spring 2025', '2025-02-10', '2025-06-20', 'completed'),
('Fall 2025',   '2025-09-02', '2026-01-10', 'completed'),
('Spring 2026', '2026-02-09', '2026-06-20', 'completed'),
('Fall 2026',   '2026-09-07', '2027-01-15', 'ongoing');

INSERT INTO instructors
    (instructor_code, full_name, email, phone, gender, academic_title, department_id, hire_date)
VALUES
('GV001', 'Nguyễn Minh Quân', 'quan.nguyen@vnu.edu.vn', '0903123456',
 'male', 'PhD', 1, '2018-08-15'),

('GV002', 'Trần Thị Lan Anh', 'lananh.tran@vnu.edu.vn', '0912345678',
 'female', 'Assoc. Prof.', 2, '2016-09-01'),

('GV003', 'Lê Hoàng Nam', 'nam.le@vnu.edu.vn', '0987654321',
 'male', 'PhD', 3, '2020-01-10'),

('GV004', 'Phạm Thu Hà', 'ha.pham@vnu.edu.vn', '0934567890',
 'female', 'PhD', 4, '2019-03-05'),

('GV005', 'Vũ Đức Thành', 'thanh.vu@vnu.edu.vn', '0978123456',
 'male', 'Dr.', 5, '2021-08-20'),

('GV006', 'Đỗ Ngọc Mai', 'mai.do@vnu.edu.vn', '0966789123',
 'female', 'PhD', 6, '2022-02-15');


INSERT INTO students
    (student_code, full_name, email, phone, gender, date_of_birth, department_id, enrollment_date, status)
VALUES
('24070001', 'Nguyễn Hoàng Anh', '24070001@vnu.edu.vn', '0901000001',
 'male', '2006-04-12', 1, '2024-09-03', 'active'),

('24070002', 'Trần Minh Đức', '24070002@vnu.edu.vn', '0901000002',
 'male', '2006-08-21', 2, '2024-09-03', 'active'),

('24070003', 'Lê Thu Trang', '24070003@vnu.edu.vn', '0901000003',
 'female', '2006-02-17', 3, '2024-09-03', 'active'),

('24070004', 'Phạm Quỳnh Mai', '24070004@vnu.edu.vn', '0901000004',
 'female', '2006-11-05', 4, '2024-09-03', 'active'),

('24070005', 'Vũ Anh Tuấn', '24070005@vnu.edu.vn', '0901000005',
 'male', '2006-06-30', 5, '2024-09-03', 'active'),

('24070006', 'Đỗ Khánh Linh', '24070006@vnu.edu.vn', '0901000006',
 'female', '2006-09-14', 1, '2024-09-03', 'active'),

('25070007', 'Nguyễn Gia Huy', '25070007@vnu.edu.vn', '0901000007',
 'male', '2007-01-23', 6, '2025-09-02', 'active'),

('25070008', 'Hoàng Ngọc Anh', '25070008@vnu.edu.vn', '0901000008',
 'female', '2007-05-19', 3, '2025-09-02', 'active');


INSERT INTO courses
    (course_code, course_name, description, credits, department_id, instructor_id, max_students)
VALUES
('INS3064', 'Database Systems',
 'Relational database design, SQL, normalization, constraints, and database applications.',
 3, 1, 1, 50),

('INS3012', 'Web Application Development',
 'Development of modern web applications using frontend, backend, and database technologies.',
 3, 1, 1, 50),

('CSC1001', 'Introduction to Computer Science',
 'Fundamental concepts of computing, algorithms, programming, and computational thinking.',
 3, 2, 2, 60),

('CSC3005', 'Artificial Intelligence',
 'Introduction to search, reasoning, machine learning, and intelligent systems.',
 3, 2, 2, 45),

('DS2001', 'Statistics for Data Science',
 'Probability, descriptive statistics, statistical inference, and data analysis.',
 3, 3, 3, 50),

('DS3002', 'Machine Learning',
 'Supervised and unsupervised learning methods and their practical applications.',
 3, 3, 3, 45),

('BUS1001', 'Principles of Management',
 'Fundamental concepts of management, organizations, leadership, and decision making.',
 3, 4, 4, 60),

('FIN2003', 'Corporate Finance',
 'Financial planning, investment decisions, capital structure, and corporate valuation.',
 3, 5, 5, 50),

('SE2002', 'Software Engineering',
 'Software development lifecycle, requirements, architecture, testing, and maintenance.',
 3, 6, 6, 50);

INSERT INTO enrollments
    (student_id, course_id, semester_id, enrolled_at, grade_point, grade_letter, status)
VALUES
(1, 1, 3, '2025-09-05 08:30:00', 3.70, 'A',  'completed'),
(1, 2, 4, '2026-02-12 09:10:00', 3.50, 'B+', 'completed'),
(1, 7, 5, '2026-09-10 08:45:00', NULL, NULL, 'enrolled'),

(2, 3, 3, '2025-09-04 10:15:00', 3.20, 'B+', 'completed'),
(2, 4, 4, '2026-02-11 13:20:00', 3.80, 'A',  'completed'),
(2, 9, 5, '2026-09-09 14:05:00', NULL, NULL, 'enrolled'),

(3, 5, 3, '2025-09-06 08:20:00', 3.90, 'A',  'completed'),
(3, 6, 4, '2026-02-10 08:40:00', 3.60, 'A',  'completed'),
(3, 1, 5, '2026-09-11 09:30:00', NULL, NULL, 'enrolled'),

(4, 7, 3, '2025-09-05 09:45:00', 3.40, 'B+', 'completed'),
(4, 8, 4, '2026-02-13 10:30:00', 3.10, 'B',  'completed'),

(5, 8, 3, '2025-09-07 14:00:00', 3.30, 'B+', 'completed'),
(5, 3, 4, '2026-02-14 15:20:00', 2.90, 'B',  'completed'),

(6, 1, 4, '2026-02-12 08:00:00', 3.85, 'A',  'completed'),
(6, 2, 5, '2026-09-10 10:00:00', NULL, NULL, 'enrolled'),

(7, 6, 5, '2026-09-08 08:15:00', NULL, NULL, 'enrolled'),
(8, 5, 5, '2026-09-08 09:00:00', NULL, NULL, 'enrolled');