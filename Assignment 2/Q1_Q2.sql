/* Q1 */
SELECT * 
FROM Works_on
WHERE Pno NOT IN (SELECT Pnumber FROM Project);


/* Q2 */
/* a */
ALTER TABLE EMPLOYEE DROP constraint companyFK1 ;
ALTER TABLE EMPLOYEE  DROP constraint companyFK2 ;
ALTER TABLE WORKS_ON DROP constraint companyFK3 ;
ALTER TABLE WORKS_ON  DROP constraint companyFK4 ;
ALTER TABLE DEPT_LOCATIONS  DROP constraint companyFK5;
ALTER TABLE DEPENDENT  DROP constraint companyFK6 ;
ALTER TABLE DEPARTMENT  DROP constraint companyFK7 ;
ALTER TABLE PROJECT  DROP constraint companyFK8 ;


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


/* b */
UPDATE EMPLOYEE
SET ssn = '99996666'
WHERE Fname = 'Franklin' AND Lname = 'Wong'\
/* 
    When we change Franklin Wong’s SSN to 99996666, the Mgr_ssn field that has the ssn of Franklin Wong 
in DEPARTMENT will be changed to 99996666. Along with that, in the Essn in WORK_ON, the field that 
contains the ssn of Franklin Wong will be changed to 99996666. The Essn of all Franklin Wong’s DEPENDENT 
will also be changed to 99996666. Finally, the Super_ssn of all EMPOYEE that Franklin Wong manages will 
be changed to 99996666.
*/


/* c */
INSERT INTO EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Dai','D','Vo','999999999','2002-01-01', '2000 Spruce St., Winnipe, MB','M',25000,'123456789',5);


/* d */
DELETE FROM EMPLOYEE 
WHERE Fname = 'James' AND Lname = 'Borg';
/* 
    To delete James Borg, we need to update table DEPARTMEMT and EMPLOYEE so that Mrg_ssn and Super_ssn 
can accept null value. After deleting the record that contains James Borg, we will see that the value 
of Super_ssn of people, who has James Borg as their supervisor, be set to null. Along with that, the 
value of Mgr_ssn of Department, where has James Borg as manager, will also be set to null.
 */