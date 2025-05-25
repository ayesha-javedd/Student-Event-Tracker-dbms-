CREATE DATABASE dbms_assignment;
USE dbms_assignment

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Major VARCHAR(50),
    Year INT CHECK (Year BETWEEN 1 AND 5)
);

CREATE TABLE Organizers (
    OrganizerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE EventCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(150) NOT NULL,
    Description TEXT,
    CategoryID INT NOT NULL,
    OrganizerID INT NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(100),
    Capacity INT CHECK (Capacity >= 0),
    FOREIGN KEY (CategoryID) REFERENCES EventCategories(CategoryID),
    FOREIGN KEY (OrganizerID) REFERENCES Organizers(OrganizerID)
);

CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    EventID INT NOT NULL,
    RegistrationDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    UNIQUE (StudentID, EventID)
);


INSERT INTO Students (Name, Email, Major, Year) VALUES
('Ahmed Ali', 'ahmed.ali@example.edu.pk', 'Computer Science', 2),
('Fatima Khan', 'fatima.khan@example.edu.pk', 'Electrical Engineering', 3),
('Bilal Sheikh', 'bilal.sheikh@example.edu.pk', 'Business Administration', 1),
('Ayesha Siddiqui', 'ayesha.siddiqui@example.edu.pk', 'Physics', 4),
('Zain Malik', 'zain.malik@example.edu.pk', 'Psychology', 2);

INSERT INTO Organizers (Name, ContactEmail) VALUES
('AI Club', 'aiclub@university.edu.pk'),
('Classical Music Society', 'music@university.edu.pk'),
('Cricket Association', 'cricket@university.edu.pk'),
('Theater Arts Group', 'theater@university.edu.pk'),
('Cultural Festival Committee', 'culture@university.edu.pk');

INSERT INTO EventCategories (CategoryName) VALUES
('AI Technology'),
('Classical Music'),
('Cricket'),
('Theater Arts'),
('Cultural Festivals');

INSERT INTO Events (Title, Description, CategoryID, OrganizerID, EventDate, Location, Capacity) VALUES
('Deep Learning Workshop', 'Explore neural networks and AI applications', 1, 1, '2025-06-10', 'Lab A', 40),
('Sitar Evening', 'A night of traditional Sitar performances', 2, 2, '2025-06-15', 'Auditorium', 120),
('Inter-University Cricket Final', 'Annual cricket championship match', 3, 3, '2025-07-01', 'Cricket Ground', 700),
('Shakespeare in Urdu', 'Adapted Hamlet play in Urdu language', 4, 4, '2025-06-25', 'Drama Hall', 250),
('Spring Mehfil', 'Cultural festival featuring music, dance & food', 5, 5, '2025-06-05', 'Main Lawn', 400);

INSERT INTO Events (Title, Description, CategoryID, OrganizerID, EventDate, Location, Capacity)
VALUES ('AI Innofest', 'Competition of AI Related Projects', 1, 1, '2025-05-23', 'Lab NC', 50);



INSERT INTO Registrations (StudentID, EventID, RegistrationDate) VALUES
(1, 1, '2025-05-01'),
(2, 1, '2025-05-02'),
(3, 2, '2025-05-03'),
(4, 3, '2025-05-04'),
(5, 5, '2025-05-05');

SELECT e.Title, e.EventDate
FROM Events e
JOIN EventCategories c ON e.CategoryID = c.CategoryID
WHERE c.CategoryName = 'AI Technology' AND e.EventDate >= GETDATE();

SELECT e.Title, COUNT(r.StudentID) AS TotalRegistrations
FROM Events e
LEFT JOIN Registrations r ON e.EventID = r.EventID
GROUP BY e.Title;

SELECT S.Name AS StudentName, E.Title, E.EventDate
FROM Registrations R
JOIN Students S ON R.StudentID = S.StudentID
JOIN Events E ON R.EventID = E.EventID
WHERE E.Title = 'Inter-University Cricket Final';

SELECT c.CategoryName, COUNT(e.EventID) AS EventCount
FROM EventCategories c
JOIN Events e ON c.CategoryID = e.CategoryID
GROUP BY c.CategoryName
HAVING COUNT(e.EventID) > 1;

SELECT s.Name AS StudentName, e.Title AS EventTitle, o.Name AS OrganizerName
FROM Students s
JOIN Registrations r ON s.StudentID = r.StudentID
JOIN Events e ON r.EventID = e.EventID
JOIN Organizers o ON e.OrganizerID = o.OrganizerID;

SELECT s.Name
FROM Students s
JOIN Registrations r ON s.StudentID = r.StudentID
JOIN Events e ON r.EventID = e.EventID
WHERE e.Title = 'Deep Learning Workshop'

UNION

SELECT s.Name
FROM Students s
JOIN Registrations r ON s.StudentID = r.StudentID
JOIN Events e ON r.EventID = e.EventID
WHERE e.Title = 'Inter-University Cricket Final';


SELECT TOP 3 e.Title, COUNT(r.RegistrationID) AS TotalRegistrations
FROM Events e
LEFT JOIN Registrations r ON e.EventID = r.EventID
GROUP BY e.Title
ORDER BY TotalRegistrations DESC;

SELECT s.Name
FROM Students s
WHERE NOT EXISTS (
    SELECT e.EventID
    FROM Events e
    JOIN Organizers o ON e.OrganizerID = o.OrganizerID
    WHERE o.Name = 'Classical Music Society'

    EXCEPT

    SELECT r.EventID
    FROM Registrations r
    WHERE r.StudentID = s.StudentID
);

SELECT TOP 1 s.Name, COUNT(r.RegistrationID) AS TotalEventsAttended
FROM Students s
JOIN Registrations r ON s.StudentID = r.StudentID
GROUP BY s.Name
ORDER BY TotalEventsAttended DESC;

SELECT o.Name AS OrganizerName, AVG(e.Capacity) AS AverageCapacity
FROM Organizers o
JOIN Events e ON o.OrganizerID = e.OrganizerID
GROUP BY o.Name;

SELECT E.Title, O.Name AS OrganizerName, EC.CategoryName, E.EventDate, E.Location
FROM Events E
JOIN Organizers O ON E.OrganizerID = O.OrganizerID
JOIN EventCategories EC ON E.CategoryID = EC.CategoryID;



