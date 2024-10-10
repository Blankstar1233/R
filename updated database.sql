--Usert table--
CREATE TABLE userr (
    email_id VARCHAR(100) PRIMARY KEY,
    contact INT,
    gender VARCHAR(1),
    username VARCHAR(50) UNIQUE,
    dob INT,
    fname VARCHAR(50),
    mname VARCHAR(50),
    lname VARCHAR(50),
    t_id varchar(15),
    CONSTRAINT fk_t_id FOREIGN KEY (t_id) REFERENCES Transaction_t(trans_id)
);
select * from userr;


--Trqansaction table--
CREATE TABLE Transaction_t (
    trans_id VARCHAR(15) PRIMARY KEY,
    amount INT,
    time_of_transaction INT,
    user_id VARCHAR(50) );
	
ALTER TABLE Transaction_t ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES userr(username);

select * from transaction_t;

--ticket-- 
CREATE TABLE ticket (
    Ticket_no INT PRIMARY KEY,
    date INT,
    time INT,
    airport VARCHAR(50),
    seat_no VARCHAR(5),
    trans_id VARCHAR(15),
    Flight_id VARCHAR(10),
    user_id VARCHAR(50),
    FOREIGN KEY (trans_id) REFERENCES Transaction_t(trans_id),
    FOREIGN KEY (user_id) REFERENCES userr(username)
);
ALTER TABLE Ticket ADD CONSTRAINT fk_flight_id FOREIGN KEY (flight_id) REFERENCES flight(flight_id);
select * from ticket;

--Flight--
CREATE TABLE flight (
    Flight_id VARCHAR(10) PRIMARY KEY,
    sourcee CHAR(40),
    destination CHAR(40)
);

select * from flight;

--Department--
CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dname VARCHAR(50),
    ssn CHAR(9),
    loc_id INT,
    d_typ VARCHAR(10)
);
ALTER TABLE Department ADD CONSTRAINT fk_loc_id FOREIGN KEY (loc_id) REFERENCES office(loc_id);
ALTER TABLE department ADD CONSTRAINT fk_d_typ FOREIGN KEY (d_typ) REFERENCES depttype(d_type);

select * from department;

--office--
CREATE TABLE office (
    loc_id INT PRIMARY KEY, 
    dept_id INT,
    ssn INT, 
    superlocation INT,
    name CHAR(50),
    trans_id VARCHAR(15), 
    user_id VARCHAR(50),
    FOREIGN KEY (trans_id) REFERENCES Transaction_t(trans_id),
    FOREIGN KEY (user_id) REFERENCES userr(username),
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
 
    FOREIGN KEY (superlocation) REFERENCES office(loc_id)
);

ALTER TABLE office ADD CONSTRAINT fk_ssn FOREIGN KEY (ssn) REFERENCES employee(ssn);

select * from office;

--employee--
CREATE TABLE employee (
    Ssn INT PRIMARY KEY,
    fname VARCHAR(20),
    lname VARCHAR(20),
    d_type VARCHAR(10),
    loc_id INT,
    dept_id INT,
    salary INT,
    duration_of_work INT,
    manager_ssn INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
   
    FOREIGN KEY (loc_id) REFERENCES office(loc_id),
    FOREIGN KEY (manager_ssn) REFERENCES employee(Ssn)
);
ALTER TABLE employee ADD CONSTRAINT fk_d_type FOREIGN KEY (d_type) REFERENCES depttype(d_type));

select * from employee;

--depttype--
CREATE TABLE depttype (
    d_type VARCHAR(10) PRIMARY KEY
);


--flight crew--
CREATE TABLE flight_crew (
    FC_id INT PRIMARY KEY,
    dept_id INT,
    d_type VARCHAR(20),
    ssn INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    FOREIGN KEY (d_type) REFERENCES depttype(d_type),
    FOREIGN KEY (ssn) REFERENCES employee(Ssn)
);

--security--
CREATE TABLE security (
    S_id INT PRIMARY KEY,
    dept_id INT,
    d_type VARCHAR(20),
    ssn INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    FOREIGN KEY (d_type) REFERENCES depttype(d_type),
    FOREIGN KEY (ssn) REFERENCES employee(Ssn)
);

--weather--
CREATE TABLE weather (
    weather_id INT PRIMARY KEY,
    dept_id INT,
    d_type VARCHAR(20),
    ssn INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    FOREIGN KEY (d_type) REFERENCES depttype(d_type),
    FOREIGN KEY (ssn) REFERENCES employee(Ssn)
);

--maintainence--
CREATE TABLE maintenance (
    m_id INT PRIMARY KEY,
    dept_id INT,
    d_type VARCHAR(20),
    ssn INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    FOREIGN KEY (d_type) REFERENCES depttype(d_type),
    FOREIGN KEY (ssn) REFERENCES employee(Ssn)
);

CREATE VIEW OfficeDepartmentInfo AS
SELECT o.name AS office_name, d.dname AS department_name
FROM office o
JOIN department d ON o.dept_id = d.dept_id;

CREATE VIEW DepartmentInfo AS
SELECT d.dname, dt.d_type
FROM department d
JOIN depttype dt ON d.d_typ = dt.d_type;

CREATE VIEW EmployeeDetails AS
SELECT e.Ssn, e.fname, e.lname, d.dname AS department_name, o.name AS office_name
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN office o ON d.loc_id = o.loc_id;

--nested query--
SELECT o.name AS office_name
FROM office o
WHERE EXISTS (
    SELECT 1
    FROM employee e
    WHERE e.loc_id = o.loc_id
);
--correlated query--
SELECT e.fname, e.lname
FROM employee e
WHERE e.dept_id IN (
    SELECT d.dept_id
    FROM department d
    WHERE d.dname = 'Airport Security'
);
--joins--
SELECT o.name AS office_name, d.dname AS department_name, dt.d_type AS department_type
FROM office o
JOIN department d ON o.dept_id = d.dept_id
JOIN depttype dt ON d.d_typ = dt.d_type;

SELECT d.dname, e.fname, e.lname
FROM department d
LEFT JOIN employee e ON d.dept_id = e.dept_id;

SELECT e.Ssn, e.fname, e.lname, d.dname, o.name AS office_name
FROM employee e
JOIN department d ON e.dept_id = d.dept_id
JOIN office o ON d.loc_id = o.loc_id;