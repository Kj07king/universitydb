USE universitydb;

-- Queries for universitydb 

-- 1.Search for a Student 
 SELECT * FROM Students
 WHERE last_name ='Kimtani';
 
 -- 2.Update a Grade
UPDATE Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
SET e.grade = '1'
WHERE s.last_name = 'Kimtani' 
  AND c.course_title = 'Introduction to Programming'
  AND e.semester = 'Fall2024';
  
  -- 3.Delete Old Attendence Records( remove the comments if you want it to work)
  /*
DELETE FROM Attendance 
WHERE attendance_date < '2024-01-01';
  */
  -- 4.Instructor course Load Report
  SELECT 
    i.first_name, 
    i.last_name, 
    c.course_title, 
    c.credits
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id
ORDER BY i.last_name ASC;

-- 5.Class Roster
SELECT s.first_name, s.last_name, s.email, e.grade, e.semester
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_title = 'Introduction to Programming'
ORDER BY s.last_name;

-- 6.Course Catalog by Credits
SELECT course_title, credits 
FROM Courses 
WHERE credits >= 3 
ORDER BY credits DESC;

-- 7.Department Directory
SELECT 
    c.course_title,
    c.credits,
    d.dept_name AS department,
    d.building,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor
FROM Courses c
INNER JOIN Departments d ON c.dept_id = d.dept_id
INNER JOIN Instructors i ON c.instructor_id = i.instructor_id
WHERE d.dept_name = 'Software Engineering'
ORDER BY c.course_title;

-- 8.Exam Reminder
SELECT DISTINCT
    s.first_name,
    s.last_name,
    s.email,
    c.course5_title,
    e.exam_type,
    e.exam_date
FROM Students s
INNER JOIN Enrollments en ON s.student_id = en.student_id
INNER JOIN Courses c ON en.course_id = c.course_id
INNER JOIN Exams e ON c.course_id = e.course_id
WHERE e.exam_type = 'Final' 
  AND MONTH(e.exam_date) = 12
ORDER BY e.exam_date;
  
  -- 9.Absentee List
SELECT 
    s.first_name,
    s.last_name,
    c.course_title,
    COUNT(a.attendance_id) AS absent_count
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
INNER JOIN Attendance a ON e.enrollment_id = a.enrollment_id
WHERE a.status = 'Absent'
GROUP BY s.student_id, s.first_name, s.last_name, c.course_id, c.course_title
HAVING COUNT(a.attendance_id) > 2;

-- 10.Instructor Schedule
SELECT DISTINCT
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    c.course_title,
    t.day_of_week,
    t.start_time,
    t.end_time,
    t.room_number
FROM Instructors i
INNER JOIN Courses c ON i.instructor_id = c.instructor_id
INNER JOIN Timetable t ON c.course_id = t.course_id
WHERE t.day_of_week = 'Monday'
ORDER BY t.start_time;

-- Room Utilization Report (Find which rooms are occupied during 09:00-11:00 time slot)
SELECT 
    t.room_number,
    t.day_of_week,
    t.start_time,
    t.end_time,
    c.course_title,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    d.dept_name
FROM Timetable t
INNER JOIN Courses c ON t.course_id = c.course_id
INNER JOIN Instructors i ON c.instructor_id = i.instructor_id
INNER JOIN Departments d ON c.dept_id = d.dept_id
WHERE t.start_time >= '09:00:00' 
  AND t.start_time <= '11:00:00'
ORDER BY t.day_of_week, t.start_time;

-- Student Performance Summary( For Kabir Kimtani)
SELECT 
    s.first_name,
    s.last_name,
    s.student_id,
    c.course_title,
    c.credits,
    e.semester,
    e.grade,
    -- Grade description
    CASE 
        WHEN e.grade = '1' THEN 'Excellent (90-100%)'
        WHEN e.grade = '2' THEN 'Good (75-89%)'
        WHEN e.grade = '3' THEN 'Satisfactory (60-74%)'
        WHEN e.grade = '4' THEN 'Sufficient (50-59%)'
        WHEN e.grade = '5' THEN 'Insufficient (25-49%)'
        WHEN e.grade = '6' THEN 'Fail (0-24%)'
        ELSE 'Not graded yet'
    END AS grade_description,
    -- Attendance calculation
    COUNT(DISTINCT a.attendance_id) AS total_attendance_records,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN a.status = 'Late' THEN 1 ELSE 0 END) AS late_days,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN a.status = 'Excused' THEN 1 ELSE 0 END) AS excused_days,
    -- Attendance percentage
    ROUND(100.0 * SUM(CASE WHEN a.status IN ('Present', 'Late') THEN 1 ELSE 0 END) / 
          NULLIF(COUNT(a.attendance_id), 0), 1) AS attendance_percentage
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
LEFT JOIN Attendance a ON e.enrollment_id = a.enrollment_id
WHERE s.last_name = 'Kimtani'  -- Change this for other students
GROUP BY s.student_id, s.first_name, s.last_name, 
         c.course_id, c.course_title, c.credits, e.semester, e.grade
ORDER BY e.semester DESC, c.course_title;