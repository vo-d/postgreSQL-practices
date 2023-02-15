SELECT * 
FROM Works_on
WHERE Pno NOT IN (SELECT Pnumber FROM Project);