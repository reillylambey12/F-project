CREATE TABLE Feeder (
  feeder_id INT PRIMARY KEY,
  feeder TEXT 
);  

CREATE TABLE Programs(
  program_id  INT PRIMARY KEY,
  program_code VARCHAR(50) NOT NULL,
  program_name TEXT NOT NULL,
  program_degree TEXT NOT NULL
);

CREATE TABLE Student_information(
  student_id INT  PRIMARY KEY,
  DOB DATE,
  gender CHAR(1) NOT NULL,
  district TEXT ,
  city TEXT ,
  ethnicity TEXT NOT NULL,
  program_start VARCHAR(100) NOT NULL,
  programEnd DATE ,
  program_status VARCHAR(100) NOT NULL,
  grade_date DATE ,
  feeder_id INT,
  FOREIGN KEY(feeder_id)
  REFERENCES Feeder(feeder_id)
); 

CREATE TABLE Courses (
  course_id INT PRIMARY KEY,
  course_code CHAR(50) NOT NULL,
  course_title TEXT NOT NULL,
  course_credits DECIMAL, 
  course_grade CHAR(2),
  course_gpa DECIMAL,
  course_points DECIMAL,
    CGPA DECIMAL,
  comments VARCHAR(50)
);

CREATE TABLE Semester (
  semester_id INT PRIMARY KEY,
  student_id INT,
  semester VARCHAR(50),
  credits_earned DECIMAL ,
  credits_attempted DECIMAL,
  semester_points  DECIMAL,
  semester_gpa DECIMAL,
  FOREIGN KEY(student_id)
  REFERENCES Student_information(student_id)
);

CREATE TABLE Semester_Courses(
  Crs_id INT PRIMARY KEY,
  semester_id INT NOT NULL,
  course_id INT NOT NULL,
  program_id INT,
  FOREIGN KEY(program_id)
  REFERENCES Programs(program_id),
  FOREIGN KEY(course_id)
  REFERENCES Courses(course_id),
  FOREIGN KEY(semester_id)
  REFERENCES Semester(semester_id)
); 


COPY Feeder
FROM '/home/reilly117/Final-Project/Feeder.csv'
DELIMITER ','
CSV HEADER;

COPY Programs
FROM '/home/reilly117/Final-Project/Programs.csv'
DELIMITER ','
CSV HEADER;

COPY Student_information
FROM '/home/reilly117/Final-Project/Student_information.csv'
DELIMITER ','
CSV HEADER; 


COPY Courses
FROM '/home/reilly117/Final-Project/Courses.csv'
DELIMITER ','
CSV HEADER;

COPY Semester
FROM '/home/reilly117/Final-Project/Semester.csv'
DELIMITER ','
CSV HEADER;

COPY Semester_Courses
FROM '/home/reilly117/Final-Project/Semester_Courses.csv'
DELIMITER ','
CSV HEADER;


--Overall acceptance for the BINT an Aint program
SELECT COUNT(*) as admission_rate FROM student_information;

----rank feeder institutions by admission rates and grades BINT
SELECT Feeder.feeder, 
       COUNT(Student_information.student_id) AS num_admitted, 
       AVG(Courses.course_points) AS avg_course_points
FROM Feeder
INNER JOIN Student_information ON Feeder.feeder_id = Student_information.feeder_id
INNER JOIN Semester ON Student_information.student_id = Semester.student_id
INNER JOIN Semester_Courses ON Semester.semester_id = Semester_Courses.semester_id
INNER JOIN Courses ON Semester_Courses.course_id = Courses.course_id
GROUP BY Feeder.feeder_id
ORDER BY  avg_course_points DESC;
----rank feeder institutions by admission rates and grades. AINT
SELECT Feeder.school_name, 
       COUNT(Student_information.student_id) AS num_admitted, 
       AVG(Grades.course_points) AS avg_course_points
FROM Feeder
INNER JOIN Student_information ON Feeder.feeder_id = Student_information.feeder_id
INNER JOIN Grades ON Student_information.student_id = Grades.student_id
INNER JOIN Courses ON Grades.course_id = Courses.course_id
GROUP BY Feeder.feeder_id
ORDER BY avg_course_points DESC;

---cauculate gradation rate for BINT programs based on total student and program status
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Student_information) AS graduation_rate
FROM Student_information
WHERE program_status = 'Graduated';





