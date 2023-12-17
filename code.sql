-- Create tables for Employees, Positions, and Departments
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    PositionID INT,
    DepartmentID INT,
    ExperienceYears INT,
    Salary DECIMAL(10, 2)
);

CREATE TABLE Positions (
    PositionID INT PRIMARY KEY,
    PositionName VARCHAR(50),
    BaseSalary DECIMAL(10, 2)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    BaseSalaryIncrement DECIMAL(10, 2)
);

-- Sample data insertion for Positions and Departments
INSERT INTO Positions (PositionID, PositionName, BaseSalary)
VALUES
    (1, 'Manager', 60000.00),
    (2, 'Engineer', 50000.00),
    (3, 'Analyst', 40000.00),
    (4, 'Sales Associate', 38000.00),
    (5, 'Marketing Manager', 65000.00),
    (6, 'Data Analyst', 42000.00);

INSERT INTO Departments (DepartmentID, DepartmentName, BaseSalaryIncrement)
VALUES
    (1, 'HR', 3000.00),
    (2, 'IT', 2000.00),
    (3, 'Finance', 2500.00),
    (4, 'Sales', 2800.00),
    (5, 'Marketing', 3500.00),
    (6, 'Operations', 3200.00);

-- Insert employee data
INSERT INTO Employees (EmployeeID, Name, PositionID, DepartmentID, ExperienceYears)
VALUES
    (1, 'John Doe', 1, 1, 5),
    (2, 'Jane Smith', 2, 2, 3),
    (3, 'Mike Johnson', 3, 3, 2),
    (4, 'Emily Brown', 2, 2, 4),
    (5, 'David Miller', 3, 3, 6),
    (6, 'Sophia Wilson', 4, 4, 2),
    (7, 'James Anderson', 5, 5, 7),
    (8, 'Olivia Clark', 6, 6, 3);

-- Update: Calculate salary based on base salary, experience, and increments
UPDATE Employees
SET Salary = 
    CASE
        WHEN ExperienceYears >= 5 THEN (
            SELECT BaseSalary + BaseSalaryIncrement + (ExperienceYears - 5) * 3000
            FROM Positions p
            JOIN Departments d ON Employees.DepartmentID = d.DepartmentID
            WHERE Employees.PositionID = p.PositionID
        )
        WHEN ExperienceYears >= 3 THEN (
            SELECT BaseSalary + BaseSalaryIncrement + (ExperienceYears - 3) * 2000
            FROM Positions p
            JOIN Departments d ON Employees.DepartmentID = d.DepartmentID
            WHERE Employees.PositionID = p.PositionID
        )
        ELSE (
            SELECT BaseSalary + BaseSalaryIncrement
            FROM Positions p
            JOIN Departments d ON Employees.DepartmentID = d.DepartmentID
            WHERE Employees.PositionID = p.PositionID
        )
    END;

-- Analyze salary distribution by department
SELECT d.DepartmentName, AVG(e.Salary) AS AvgSalary, COUNT(*) AS EmployeeCount
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- Find the top-paid position
SELECT p.PositionName, AVG(e.Salary) AS AvgSalary
FROM Employees e
INNER JOIN Positions p ON e.PositionID = p.PositionID
GROUP BY p.PositionName
ORDER BY AvgSalary DESC
LIMIT 1;
