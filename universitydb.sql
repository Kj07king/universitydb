Drop DATABASE IF EXISTS universitydb;
CREATE DATABASE universityDB;
USE universityDB;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    building VARCHAR(50)
);

INSERT INTO Departments (dept_name, building) VALUES 
('Economics', 'Maths Hall'),
('Business Administration', 'Business Center'),
('Software Engineering', 'IT Department'),
('Computer Science', 'Computer Lab'),
('Psychology', 'Social Sciences Building');

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Instructors (first_name, last_name, email, dept_id) VALUES
('Lisa', 'Cuddy', 'lisa.cuddy@university.edu', 1),
('Vito', 'Corleone', 'vito.corleone@university.edu', 2),
('Linus', 'Torvalds', 'linus.torvalds@university.edu', 3),
('Tyler', 'Durden', 'tyler.durden@university.edu', 4),
('Antonio', 'Montana', 'antonio.montana@university.edu', 4),
('Dr. Gregory', 'House', 'gregory.house@university.edu', 5);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_title VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    dept_id INT,
    instructor_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);

INSERT INTO Courses (course_title, credits, dept_id, instructor_id) VALUES
('Introduction to Programming', 3, 4, 4),
('Data Structures', 4, 3, 3),
('Database Systems', 3, 3, 3),
('Statistics', 4, 4, 5),
('Maths Fundation', 3, 4, 5),
('Marketing Fundamentals', 3, 1, 1),
('Forensic Psychology', 3, 5, 6),
('Consumer behavior in the digital age', 4, 1, 1),
('Cognitive Psychology', 3, 5, 6);

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20) CHECK (phone_number REGEXP '^\\+49 [0-9]{2,5} [0-9]{6,8}$'),
    enrollment_date DATE DEFAULT (CURRENT_DATE)
);

INSERT INTO Students (first_name, last_name, email, phone_number, enrollment_date) VALUES
('Kabir', 'Kimtani', 'kabir.k@university.edu', '+49 30 1234567', '2024-09-01'),
('Kay', 'Adams', 'kay.a@university.edu', '+49 89 2345678', '2024-09-01'),
('Sunny', 'Corleone', 'sunny.c@university.edu', '+49 40 3456789', '2024-01-15'),
('Jack', 'Durden', 'jack.d@university.edu', '+49 69 4567890', '2024-09-01'),
('Tom', 'Hagen', 'tom.h@university.edu', '+49 221 5678901', '2023-09-01'),
('Apollonia', 'Vitelli', 'apollonia.v@university.edu', '+49 711 6789012', '2024-01-15'),
('Michael', 'Corleone', 'michael.c@university.edu', '+49 911 7890123', '2024-09-01'),
('Robert', 'Chase', 'robert.c@university.edu', '+49 201 8901234', '2023-09-01');

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade ENUM('1','2','3','4','5','6') DEFAULT NULL,
	semester VARCHAR(10) CHECK (semester REGEXP '^(Fall|Spring|Summer)[0-9]{4}$'),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_id, semester)
);
INSERT INTO Enrollments (student_id, course_id, grade, semester) VALUES

(1, 1, '1', 'Fall2024'),
(1, 2, '2', 'Fall2024'),
(1, 3, '1', 'Fall2024'),

(2, 1, '3', 'Fall2024'),
(2, 4, '2', 'Fall2024'),
(2, 6, '4', 'Fall2024'),

(3, 3, '1', 'Spring2024'),
(3, 5, '2', 'Spring2024'),
(3, 7, '3', 'Spring2024'),

(4, 2, '1', 'Fall2024'),
(4, 3, '2', 'Fall2024'),
(4, 8, '1', 'Fall2024'),

(5, 4, '2', 'Fall2023'),
(5, 5, '1', 'Spring2024'),
(5, 9, '3', 'Fall2024'),

(6, 1, '5', 'Fall2024'),
(6, 6, '4', 'Fall2024'),
(6, 7, '3', 'Fall2024'),

(7, 2, '4', 'Fall2024'),
(7, 8, '2', 'Fall2024'),

(8, 4, '2', 'Spring2024'),
(8, 5, '1', 'Fall2024'),
(8, 9, '2', 'Fall2024');

CREATE TABLE Exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    exam_type VARCHAR(50), 
    exam_date DATE NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

INSERT INTO Exams (course_id, exam_type, exam_date) VALUES
(1, 'Project', '2024-10-15'),
(1, 'Final', '2024-12-10'),
(2, 'Project', '2024-10-18'),
(2, 'Final', '2024-12-12'),
(3, 'Group Presentation', '2024-09-25'),
(3, 'Project', '2024-10-20'),
(3, 'Final', '2024-12-15'),
(4, 'Project', '2024-10-12'),
(4, 'Final', '2024-12-08'),
(5, 'Group Presentation', '2024-12-14');

CREATE TABLE Timetable (
    timetable_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(50), 
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);
INSERT INTO Timetable (course_id, day_of_week, start_time, end_time, room_number) VALUES
(1, 'Monday', '09:00:00', '10:30:00', 'Room 101'),
(1, 'Wednesday', '09:00:00', '10:30:00', 'Room 101'),
(2, 'Tuesday', '11:00:00', '12:30:00', 'Room 206'),
(2, 'Thursday', '11:00:00', '12:30:00', 'Room 205'),
(3, 'Monday', '14:00:00', '15:30:00', 'Lab 301'),
(3, 'Friday', '14:00:00', '15:30:00', 'Lab 301'),
(4, 'Tuesday', '09:00:00', '10:30:00', 'Auditorium A'),
(4, 'Thursday', '09:00:00', '10:30:00', 'Auditorium A'),
(5, 'Wednesday', '13:00:00', '14:30:00', 'Room 108'),
(6, 'Monday', '15:00:00', '16:30:00', 'Business Hall 202'),
(7, 'Wednesday', '10:00:00', '11:30:00', 'Business Hall 202'),
(8, 'Friday', '11:00:00', '12:30:00', 'Science Lab 5'),
(9, 'Tuesday', '14:00:00', '15:30:00', 'Social Sciences Building 45'),
(9, 'Thursday', '14:00:00', '15:30:00', 'Social Sciences Building 45');

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') DEFAULT 'Present',
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE,
    CONSTRAINT unique_daily_attendance UNIQUE (enrollment_id, attendance_date)
);

INSERT INTO Attendance (enrollment_id, attendance_date, status) VALUES
-- Get enrollment_id from Enrollments table (assuming IDs 1-23 based on above order)
-- For Alice (enrollment_id = 1,2,3)
(1, '2024-10-07', 'Present'),
(1, '2024-10-14', 'Present'),
(2, '2024-10-15', 'Late'),
(2, '2024-10-22', 'Present'),
(3, '2024-09-30', 'Present'),
(3, '2024-10-07', 'Excused'),
-- For Bob (enrollment_id = 4,5,6)
(4, '2024-10-07', 'Present'),
(4, '2024-10-14', 'Absent'),
(5, '2024-10-08', 'Present'),
(6, '2024-10-07', 'Present'),
-- For Charlie (enrollment_id = 7,8,9)
(7, '2024-09-25', 'Present'),
(8, '2024-09-26', 'Present'),
(9, '2024-10-01', 'Late'),
-- For Diana (enrollment_id = 10,11,12)
(10, '2024-10-15', 'Present'),
(11, '2024-10-20', 'Present'),
(12, '2024-10-18', 'Present'),
-- For Ethan (enrollment_id = 13,14,15)
(13, '2023-11-01', 'Present'),
(14, '2024-03-10', 'Present'),
(15, '2024-10-08', 'Absent');

CREATE INDEX idx_student_name ON Students(last_name);
CREATE INDEX idx_course_dept ON Courses(dept_id);
