-- Create Country Table
CREATE TABLE country (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL
);

-- Create City Table
CREATE TABLE city (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(id) ON DELETE CASCADE
);

-- Create District Table
CREATE TABLE district (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city(id) ON DELETE CASCADE
);

CREATE TABLE department (
    id INT PRIMARY KEY ,
    Departmentname VARCHAR(255) NOT NULL
);




EXEC sp_rename 'city.name', 'cityname', 'COLUMN';
EXEC sp_rename 'country.name', 'countryname', 'COLUMN';
EXEC sp_rename 'project.name', 'projectname', 'COLUMN';


CREATE TABLE employee (
    id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    department_id INT,
    district_id INT,
    FOREIGN KEY (department_id) REFERENCES department(id) ON DELETE SET NULL,
    FOREIGN KEY (district_id) REFERENCES district(id) ON DELETE SET NULL
);


CREATE TABLE project (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL
);



CREATE TABLE project_employee (
    id INT PRIMARY KEY ,
    project_id INT,
    employee_id INT,
    FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE
);


INSERT INTO country (countryname) VALUES 
('USA'), 
('Canada'), 
('Germany');


INSERT INTO city (cityname, country_id) VALUES 
('New York', 1), 
('Los Angeles', 1), 
('Toronto', 2), 
('Berlin', 3);


INSERT INTO district (districtname, city_id) VALUES 
('Brooklyn', 1), 
('Manhattan', 1), 
('Hollywood', 2), 
('Downtown Toronto', 3), 
('Mitte', 4);

alter table department 
add Deplocation nvarchar(50) 

INSERT INTO department (departmentname, Deplocation) VALUES 
('IT', 'New York'), 
('HR', 'Los Angeles'), 
('Finance', 'Toronto'), 
('Marketing', 'Berlin');


INSERT INTO employee (first_name, last_name, salary, department_id, district_id) VALUES 
('John', 'Doe', 5000.00, 1, 1), 
('Jane', 'Smith', 5500.00, 2, 2), 
('Michael', 'Johnson', 6000.00, 3, 3), 
('Emily', 'Davis', 6200.00, 4, 4);


INSERT INTO project (projectname) VALUES 
('AI Development'), 
('Website Redesign'), 
('Mobile App Launch'), 
('Marketing Campaign');


INSERT INTO project_employee (project_id, employee_id) VALUES 
(1, 1), 
(1, 2), 
(2, 3), 
(3, 4), 
(4, 2);




SELECT * FROM country;
SELECT * FROM city;
SELECT * FROM district;
SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM project;
SELECT * FROM project_employee;




create view displayAllData AS
SELECT country.id , [countryname],[cityname],[country_id] from  [dbo].[country] join [dbo].[city]
on country.id = city.country_id

select * from
display_all_data



CREATE VIEW display_all_data AS
SELECT 
    e.id AS employee_id,
    c.countryname,
    ci.cityname,
    d.districtname,
    dep.departmentname, dep.[Deplocation],
    e.first_name, e.last_name, e.salary,
    p.[projectname] AS project_name
FROM country c
LEFT JOIN city ci ON c.id = ci.country_id
LEFT JOIN district d ON ci.id = d.city_id
LEFT JOIN employee e ON d.id = e.district_id
LEFT JOIN department dep ON e.department_id = dep.id
LEFT JOIN project_employee pe ON e.id = pe.employee_id
LEFT JOIN project p ON pe.project_id = p.id



select * from display_all_data
where cityname = 'New York'


SELECT salary, COUNT(*) AS count
FROM display_all_data
GROUP BY salary


CREATE VIEW department_empcount_projectcount AS
SELECT 
    d.departmentname,
    COUNT(e.id) AS employee_count,      
    SUM(e.salary)AS total_salary, 
    COUNT(pe.project_id) AS project_count 
FROM department d
LEFT JOIN employee e ON d.id = e.department_id
LEFT JOIN project_employee pe ON e.id = pe.employee_id
GROUP BY d.departmentname

select * from department_empcount_projectcount



CREATE TABLE LogData (
    id int PRIMARY KEY,
    log_id INT ,  
    table_name NVARCHAR(100) NOT NULL,     
    action_type NVARCHAR(50) NOT NULL,     
    action_date DATETIME DEFAULT GETDATE()      
	)  


	create trigger T_Department on [dbo].[department]
	after update 
	as 
	insert into LogData ([log_id],[LOGname],[action_type])
	select[id], [Departmentname],'UPDATE' FROM inserted




alter proc Country_proc
@actiontype tinyint,
@id tinyint ,
@countryname nvarchar(50)
AS
if @actiontype = 1
begin 
select * from [dbo].[country]
end
if @actiontype = 2
begin 
select * from [dbo].[country]
where id = @id
end
if @actiontype = 3
begin 
insert into [dbo].[country] ([id],[countryname]) values (@id ,@countryname )
end
if @actiontype = 4
begin 
update [dbo].[country] set [countryname] = @countryname where id = @id
end
if @actiontype = 5
begin 
delete from [dbo].[country] where id = @id
end


