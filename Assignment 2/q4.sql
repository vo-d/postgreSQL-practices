ALTER TABLE EMPLOYEE 
ADD COLUMN OfficeNo VARCHAR(5) DEFAULT 'A-0' NULL,
ADD CONSTRAINT OfficeNo_check CHECK (OfficeNo ~ '^[A-Z]-\d{1,3}$');


UPDATE EMPLOYEE
SET OfficeNo CASE
WHEN Dno = 1 THEN 'A-113'
WHEN Dno = 4 THEN 'B-0'
WHEN Dno = 5 THEN 'W-0'
ELSE 'W-0'
END;



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