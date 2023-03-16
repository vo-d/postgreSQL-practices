/* Q3 */
/* a */
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


/* b */
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


/* c */
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


/* d */
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


/* e */
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


/* Q4 */
/* a */
ALTER TABLE EMPLOYEE 
ADD COLUMN OfficeNo VARCHAR(5) DEFAULT 'A-0' NULL,
ADD CONSTRAINT OfficeNo_check CHECK (OfficeNo ~ '^[A-Z]-\d{1,3}$');


/* b */
UPDATE EMPLOYEE
SET OfficeNo CASE
WHEN Dno = 1 THEN 'A-113'
WHEN Dno = 4 THEN 'B-0'
WHEN Dno = 5 THEN 'C-99'
ELSE 'W-0'
END;


/* c */
UPDATE EMPLOYEE
SET Salary = CASE 
WHEN underling_count.count > 3 THEN Salary * 1.3
WHEN underling_count.count IN (1,2) THEN Salary * 1.2
ELSE Salary * 1.1
END 
FROM (
    SELECT ssn, count 
    FROM EMPLOYEE e LEFT OUTER JOIN (
        SELECT Super_ssn, COUNT(Super_ssn)
        FROM EMPLOYEE
        GROUP BY Super_ssn
    ) ec
    ON e.ssn = ec.Super_ssn 
) underling_count
WHERE EMPLOYEE.ssn = underling_count.ssn