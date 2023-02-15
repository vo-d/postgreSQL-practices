ALTER TABLE EMPLOYEE DROP constraint companyFK1 ;
ALTER TABLE EMPLOYEE  DROP constraint companyFK2 ;
ALTER TABLE WORKS_ON DROP constraint companyFK3 ;
ALTER TABLE WORKS_ON  DROP constraint companyFK4 ;
ALTER TABLE DEPT_LOCATIONS  DROP constraint companyFK5;
ALTER TABLE DEPENDENT  DROP constraint companyFK6 ;
ALTER TABLE DEPARTMENT  DROP constraint companyFK7 ;
ALTER TABLE PROJECT  ADD constraint companyFK8 ;


ALTER TABLE DEPARTMENT
ALTER COLUMN Mgr_ssn DROP NOT NULL;

ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk1 FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT fk2 FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber)
ON DELETE RESTRICT;

ALTER TABLE Project 
ADD CONSTRAINT fk3 FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
ON DELETE RESTRICT;

ALTER TABLE WORKS_ON 
ADD CONSTRAINT fk4 FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE WORKS_ON
ADD CONSTRAINT fk5 FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
ON DELETE RESTRICT;

ALTER TABLE DEPENDENT 
ADD CONSTRAINT fk6 FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk7 FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber)
ON DELETE RESTRICT;

ALTER TABLE EMPLOYEE
ALTER COLUMN Super_ssn DROP NOT NULL;

ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk8 FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn)
ON DELETE SET NULL
ON UPDATE CASCADE;



INSERT INTO EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Dai','D','Vo','999999999','2002-01-01', '2000 Spruce St., Winnipe, MB','M',25000,'123456789',5);


DELETE FROM EMPLOYEE 
WHERE Fname = 'James' AND Lname = 'Borg';



WITH project_count_per_employee AS(
	SELECT Essn, COUNT(Essn) as project_count
	FROM WORKS_ON
	GROUP BY Essn
),
most_project_employee AS (
	SELECT Essn, project_count
	FROM project_count_per_employee
	WHERE project_count = (SELECT MAX(project_count) FROM project_count_per_employee)
),
dependent_amount AS (
	SELECT m.Essn, COUNT(d.Essn) as dependent_count
	FROM DEPENDENT d INNER JOIN most_project_employee m
	ON d.Essn = m.Essn
	GROUP BY m.Essn
)
SELECT Fname, Lname, dependent_count
FROM EMPLOYEE e INNER JOIN dependent_amount d
ON e.ssn = d.Essn;



WITH RECURSIVE supervisor_hierarchy AS (
    SELECT ssn, Lname, Super_ssn, 1 as hierarchy
    FROM EMPLOYEE 
    WHERE Lname = 'Narayan' AND Fname = 'Ramesh'
    UNION
    SELECT e.ssn, e.Lname, e.Super_ssn, sh.hierarchy + 1
    FROM EMPLOYEE e INNER JOIN supervisor_hierarchy sh 
    ON e.ssn = sh.Super_ssn 
)
SELECT ssn, Lname, Super_ssn, hierarchy
FROM supervisor_hierarchy
ORDER BY hierarchy


WITH RECURSIVE supervisor_hierarchy AS(
    SELECT ssn, Lname, Super_ssn, 1 as hierarchy
    FROM EMPLOYEE
    WHERE Lname = 'Borg' AND Fname = 'James'
    UNION 
    SELECT e.ssn, e.Lname, e.Super_ssn, sh.hierarchy + 1
    FROM EMPLOYEE e INNER JOIN supervisor_hierarchy sh 
    ON e.Super_ssn = sh.ssn 
)
SELECT Lname 
FROM supervisor_hierarchy
WHERE hierarchy = (SELECT MAX(hierarchy) FROM supervisor_hierarchy)



WITH RECURSIVE supervisor_hierarchy AS(
    SELECT ssn, Lname, Super_ssn, salary, 1 as hierarchy
    FROM EMPLOYEE
    WHERE Fname = 'James' AND Lname = 'Borg'
    UNION 
    SELECT e.ssn, e.Lname, e.Super_ssn, e.salary, sh.hierarchy + 1
    FROM EMPLOYEE e INNER JOIN supervisor_hierarchy sh 
    ON e.Super_ssn = sh.ssn 
)
SELECT SUM(salary) 
FROM supervisor_hierarchy
WHERE hierarchy != 1


WITH RECURSIVE supervisor_hierarchy AS(
    SELECT ssn, Lname, Bdate, Super_ssn, 1 as hierarchy
    FROM EMPLOYEE
    WHERE Fname = 'Jennifer' AND Lname = 'Wallace'
    UNION
    SELECT e.ssn, e.Lname, e.Bdate, e.Super_ssn, sh.hierarchy + 1
    FROM EMPLOYEE e INNER JOIN supervisor_hierarchy sh 
    ON e.Super_ssn = sh.ssn 
), 
underling AS (
    SELECT Lname, Bdate 
    FROM supervisor_hierarchy 
    WHERE hierarchy != 1
)
SELECT Lname, Bdate
FROM underling
WHERE Bdate = (SELECT MAX(Bdate) FROM underling)
