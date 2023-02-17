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
