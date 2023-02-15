/* Dai Dai Vo - 3129620 */

/* Q2 */

/* a */
SELECT Fname, Lname, Ssn 
FROM EMPLOYEE
ORDER BY Lname DESC, Fname DESC;

/* b */
SELECT Pname, Pnumber, Plocation 
FROM PROJECT 
WHERE Pname LIKE '%tion%';

/* c */
SELECT e.Ssn, e.Fname, e.Lname
FROM EMPLOYEE as e, PROJECT as p, WORKS_ON as w
WHERE w.Essn = e.Ssn AND w.Pno = p.Pnumber AND p.Pname LIKE 'ProductX'
ORDER BY e.Lname, e.Fname;

/* d */
SELECT DISTINCT e.Ssn, e.Fname, e.Lname, e.Sex
FROM EMPLOYEE as e INNER JOIN DEPENDENT as d
ON e.Ssn = d.Essn
Where e.Fname = d.Dependent_name AND e.Sex = d.Sex;

/* e */
SELECT e.Ssn, e.Lname, e.Bdate, e.Salary
FROM EMPLOYEE as e LEFT OUTER JOIN EMPLOYEE as e2
ON e.Salary > e2.Salary
WHERE e2.Salary is NULL
ORDER BY e.Bdate ASC LIMIT 1;

/* f */
SELECT DISTINCT e.Fname, e.Lname
FROM EMPLOYEE e INNER JOIN DEPENDENT d 
ON e.Ssn = d.Essn
WHERE d.Relationship = 'Daughter' AND d.Bdate BETWEEN '1980-01-01' AND '1990-01-01' ;

/* g */
SELECT e.Fname, e.Lname, m.Fname as ManFname, m.Lname as ManLname
FROM EMPLOYEE e INNER JOIN EMPLOYEE m 
ON e.Super_ssn = m.ssn;

/* h */
SELECT m.Ssn, m.Fname, m.Lname, m.Bdate
FROM EMPLOYEE e RIGHT OUTER JOIN EMPLOYEE m 
ON e.Super_ssn = m.Ssn 
WHERE e.Ssn IS NULL
ORDER BY m.Bdate
LIMIT 1;

/* i */
SELECT AVG(m.Salary)
FROM EMPLOYEE e RIGHT OUTER JOIN EMPLOYEE m 
ON e.Super_ssn = m.Ssn 
WHERE e.Ssn IS NULL;

/* j */
SELECT e.Ssn, e.Fname, w.Hours
FROM EMPLOYEE e INNER JOIN WORKS_ON w
ON w.Essn = e.Ssn 
WHERE w.Hours > 20 AND w.Hours <= 40;



/* Q3 */

/* a */
SELECT p.Pname
FROM PROJECT p RIGHT OUTER JOIN (SELECT w.Pno, count(w.Pno)
                                FROM WORKS_ON w
                                group by w.Pno) as t
ON p.Pnumber = t.Pno
WHERE t.count > 2
ORDER BY t.count ASC, p.Pname;

/* b */
SELECT t1.Ssn, t1.Lname
FROM 
	(SELECT *
	FROM EMPLOYEE e1 INNER JOIN DEPENDENT d 
    ON d.Essn = e1.Ssn 
    WHERE d.Relationship = 'Daughter' ) t1
INNER JOIN 
	(SELECT *
	FROM EMPLOYEE e1 INNER JOIN DEPENDENT d 
	ON d.Essn = e1.Ssn 
	WHERE d.Relationship = 'Son') t2
ON t1.Ssn = t2.Ssn
WHERE t1.Salary > 10000;

/* c */
SELECT e.Lname, d.Dependent_name
FROM EMPLOYEE e , DEPENDENT d ,(SELECT d1.Essn, MAX(d1.Bdate) as Bdate
                                FROM DEPENDENT d1
                                GROUP BY d1.Essn) as t
WHERE d.Bdate = t.Bdate AND e.Ssn = d.Essn
ORDER BY d.Dependent_name ASC;


/* d */
/* i */
SELECT e.Fname 
FROM EMPLOYEE e 
WHERE e.Ssn IN (SELECT d.Essn 
                FROM DEPENDENT d 
                WHERE d.Relationship = 'Son')
ORDER BY e.Lname;

/* ii */
SELECT e.Fname 
FROM EMPLOYEE e 
WHERE EXISTS (SELECT *
            FROM DEPENDENT d 
            WHERE d.Relationship = 'Son' AND e.Ssn = d.Essn)
ORDER BY e.Lname;

/* iii */
SELECT E.Fname
FROM DEPENDENT d , EMPLOYEE e
WHERE d.Relationship = 'Son' AND e.Ssn = d.Essn
ORDER BY e.Lname;

/* e */
CREATE VIEW Project_hours
AS
SELECT p.Pname, SUM(w.Hours) as Total_hours
FROM PROJECT p INNER JOIN WORKS_ON w 
ON p.Pnumber = w.Pno 
GROUP BY p.Pname;


SELECT e.Lname, e.Fname, e.Ssn
FROM EMPLOYEE e, WORKS_ON w, Project p, Project_hours ph, (SELECT MIN(Total_hours) as Total_hours
                                                            FROM Project_hours) ph2
WHERE ph.Total_hours = ph2.Total_hours AND p.Pname = ph.Pname AND w.Pno = p.Pnumber AND e.Ssn = w.Essn
