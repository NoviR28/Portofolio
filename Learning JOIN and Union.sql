-- CREATE TABLE TO PRACTICE JOIN 
-- Membuat tabel Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Major VARCHAR(50),
    Year INT
);

-- Memasukkan data ke tabel Students
INSERT INTO Students (StudentID, Name, Major, Year)
VALUES 
(101, 'Alice', 'Computer Sci', 3),
(102, 'Bob', 'Math', 2),
(103, 'Charlie', 'Physics', 1),
(104, 'David', 'Computer Sci', 4),
(105, 'Eve', 'Biology', 2); -- Mahasiswa baru yang tidak terdaftar di tabel Enrollments

-- Membuat tabel Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- Memasukkan data ke tabel Courses
INSERT INTO Courses (CourseID, CourseName, Credits)
VALUES 
(201, 'Database Systems', 3),
(202, 'Algorithms', 4),
(203, 'Linear Algebra', 3),
(204, 'Quantum Mechanics', 4),
(205, 'Genetics', 3); -- Kursus baru yang tidak terdaftar di tabel Professors

-- Membuat tabel Enrollments
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade CHAR(1),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Memasukkan data ke tabel Enrollments
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade)
VALUES 
(301, 101, 201, 'A'),
(302, 102, 203, 'B'),
(303, 103, 204, 'C'),
(304, 104, 202, 'A'),
(305, 104, 201, 'B'); -- StudentID 105 tidak ada di tabel Students

-- Membuat tabel Professors
CREATE TABLE Professors (
    ProfessorID INT PRIMARY KEY,
    ProfessorName VARCHAR(50),
    CourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Memasukkan data ke tabel Professors
INSERT INTO Professors (ProfessorID, ProfessorName, CourseID)
VALUES 
(401, 'Dr. Smith', 201),
(402, 'Dr. Johnson', 202),
(403, 'Dr. Lee', 203),
(404, 'Dr. Patel', 204),
(405, 'Dr. Taylor', 205); -- CourseID 205 tidak ada di tabel Courses


# Table students, Courses, Enrollments, Professors

SELECT * FROM students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;
SELECT * FROM Professors;

-----------------------------------------------------------------------------------------------
# INNER JOIN
--- Who takes in the courses?

-- Use INNER JOIN
SELECT 
	s.`StudentID`,
    e.`CourseID`,
    s.`Name`,
    c.`CourseName`,
    c.`Credits`,
    p.`ProfessorName`
		FROM Enrollments AS e
			JOIN Students AS s ON s.`StudentID`= e.`StudentID`
			JOIN Courses AS c ON c.`CourseID`= e.`CourseID`
			JOIN professors AS p ON p.`CourseID`= e.`CourseID`;
-- USE LEFT JOIN
SELECT 
	s.`StudentID`,
    e.`CourseID`,
    s.`Name`,
    c.`CourseName`,
    c.`Credits`,
    p.`ProfessorName`
		FROM Enrollments AS e
			LEFT JOIN Students AS s ON s.`StudentID`= e.`StudentID`
			LEFT JOIN Courses AS c ON c.`CourseID`= e.`CourseID`
			LEFT JOIN professors AS p ON p.`CourseID`= e.`CourseID`;

# LEFT JOIN
-- Show the student data including courses, enrollments, and profesors.
-- Use Right Join
SELECT 
	s.`StudentID`,
    e.`CourseID`,
    s.`Name`,
    c.`CourseName`,
    c.`Credits`,
    p.`ProfessorName`
		FROM Enrollments AS e
			RIGHT JOIN Students AS s ON s.`StudentID`= e.`StudentID`
			RIGHT JOIN Courses AS c ON c.`CourseID`= e.`CourseID`
			RIGHT JOIN professors AS p ON p.`CourseID`= e.`CourseID`;

-------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE TO PRACTICE UNION 

-- Membuat tabel courses1
CREATE TABLE courses1 (
    id INT,
    nama VARCHAR(100),
    jenis_kursus VARCHAR(50),
    status_pembayaran VARCHAR(20)
);

-- Menyisipkan 5 baris data ke dalam courses1
INSERT INTO courses1 (id, nama, jenis_kursus, status_pembayaran) VALUES
(1, 'Ali', 'Online', 'Lunas'),
(2, 'Budi', 'Offline', 'Belum Lunas'),
(3, 'Citra', 'Online', 'Lunas'),
(4, 'Dani', 'Offline', 'Lunas'),
(5, 'Eka', 'Online', 'Belum Lunas');

-- Membuat tabel courses2
CREATE TABLE courses2 (
    id INT,
    nama VARCHAR(100),
    jenis_kursus VARCHAR(50),
    status_pembayaran VARCHAR(20)
);

-- Menyisipkan 5 baris data ke dalam courses2
INSERT INTO courses2 (id, nama, jenis_kursus, status_pembayaran) VALUES
(1, 'Ali', 'Online', 'Lunas'),
(2, 'Budi', 'Offline', 'Belum Lunas'),
(3, 'Citra', 'Online', 'Lunas'),
(4, 'Dani', 'Offline', 'Lunas'),
(4, 'Dani', 'Online', 'Lunas'),
(6, 'Amel', 'Online', 'Lunas');  -- Baris ini berbeda dengan courses1 (status_pembayaran 'Lunas' dibandingkan 'Belum Lunas')


SELECT * FROM Courses1;
SELECT * FROM Courses2;

# UNION

SELECT ID,
	NAMA,
	Jenis_Kursus,
    Status_pembayaran
FROM Courses1 
	UNION 
    SELECT
		ID,
		NAMA,
		Jenis_Kursus,
		Status_pembayaran
			FROM Courses2;
SELECT ID,
	NAMA,
	Jenis_Kursus,
    Status_pembayaran
FROM Courses1 
	UNION ALL
    SELECT
		ID,
		NAMA,
		Jenis_Kursus,
		Status_pembayaran
			FROM Courses2;




















            