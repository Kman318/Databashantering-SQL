CREATE DATABASE FailSafeIT;
GO

USE FailSafeIT;
GO

CREATE TABLE Customers (
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    OrganizationNo VARCHAR(20) NOT NULL UNIQUE,
    CompanyName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL
);

CREATE TABLE Consultants (
    ConsultantId INT IDENTITY(1,1) PRIMARY KEY,
    PersonalNo VARCHAR(20) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    HourlyRate DECIMAL(10,2) NOT NULL CHECK (HourlyRate > 0),
    Specialty NVARCHAR(100) NOT NULL
);

CREATE TABLE Assignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    ConsultantId INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    RoleDescription NVARCHAR(200) NOT NULL,

    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (ConsultantId) REFERENCES Consultants(ConsultantId),

    CHECK (EndDate >= StartDate)
);


INSERT INTO Customers
    (OrganizationNo, CompanyName, Email, Phone)
VALUES
    ('111111-1111', 'SEB', 'info@SEB.se', '060-111111'),
    ('222222-2222', 'Lansfast', 'info@LFY.se', '060-222222'),
    ('333333-3333', 'Swedbank', 'info@swedbank.se', '0611-33333');

INSERT INTO Consultants
    (PersonalNo, FullName, HourlyRate, Specialty)
VALUES
    ('19900101-1111', 'Lille Båtsman', 1400, 'Cybersecurity'),
    ('19910202-2222', 'Gösta Ekman', 1300, 'DevOps'),
    ('19920303-3333', 'Dynamit Harry', 1100, 'C# Developer');


INSERT INTO Assignments
    (CustomerId, ConsultantId, StartDate, EndDate, RoleDescription)
VALUES
    (1, 1, '20260101', '20260630', 'Security review of APIs'),
    (1, 2, '20260201', '20260730', 'Build a CI/CD pipeline'),
    (2, 3, '20260301', '20260830', 'Develop an order management system'),
    (2, 1, '20260401', '20260930', 'Review user permissions'),
    (2, 2, '20260501', '20261030', 'Automate application deployment');

SELECT FullName, HourlyRate
FROM Consultants
WHERE HourlyRate > 1200
ORDER BY HourlyRate DESC;


SELECT
    Customers.CompanyName,
    Consultants.FullName,
    Assignments.StartDate,
    Assignments.EndDate
FROM Assignments
INNER JOIN Customers
    ON Assignments.CustomerId = Customers.CustomerId
INNER JOIN Consultants
    ON Assignments.ConsultantId = Consultants.ConsultantId
ORDER BY Customers.CompanyName, Assignments.StartDate;


SELECT
    Customers.CompanyName,
    COUNT(Assignments.AssignmentId) AS ActiveAssignments
FROM Customers
LEFT JOIN Assignments
    ON Customers.CustomerId = Assignments.CustomerId
    AND CAST(GETDATE() AS DATE)
        BETWEEN Assignments.StartDate AND Assignments.EndDate
GROUP BY Customers.CustomerId, Customers.CompanyName
ORDER BY Customers.CompanyName;



UPDATE Consultants
SET HourlyRate = 1350
WHERE ConsultantId = 2;


SELECT ConsultantId, FullName, HourlyRate
FROM Consultants
WHERE ConsultantId = 2;



DELETE FROM Customers
WHERE CustomerId = 3
AND NOT EXISTS (
    SELECT 1
    FROM Assignments
    WHERE Assignments.CustomerId = Customers.CustomerId
);

SELECT * FROM Customers;