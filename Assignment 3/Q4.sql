CREATE TABLE BANK(
    name CHAR(50),
    number CHAR(15),
    CONSTRAINT pk1 PRIMARY KEY (number),
    CONSTRAINT un1 UNIQUE (name)
);

CREATE TABLE BRANCH (
    number CHAR(50),
    bank_number CHAR(15),
    address CHAR(50),
    phone CHAR(15),
    CONSTRAINT fk1 FOREIGN KEY (bank_number) REFERENCES BANK(number),
	CONSTRAINT pk_branch PRIMARY KEY (number, bank_number)
);

CREATE TABLE ACCOUNT(
    accNum CHAR(15),
    balance FLOAT,
    branch_number CHAR(15),
    bank_number CHAR(15),
    overdraft FLOAT,
    interestRate FLOAT,
    CONSTRAINT fk2 FOREIGN KEY (branch_number, bank_number) REFERENCES BRANCH(number, bank_number),
    CONSTRAINT pk3 PRIMARY KEY (accNum, branch_number, bank_number)
);

CREATE TABLE CUSTOMER(
    custNum CHAR(15),
    first CHAR(50),
    last CHAR(50),
    CONSTRAINT pk6 PRIMARY KEY (custNum)
);

CREATE TABLE CUSTOMER_HAS_ACCOUNT(
    custNum CHAR(15),
    accNum CHAR(15),
	branch_number CHAR(15),
    bank_number CHAR(15),
    CONSTRAINT fk5 FOREIGN KEY (custNum) REFERENCES CUSTOMER(custNum),
    CONSTRAINT fk6 FOREIGN KEY (accNum, branch_number, bank_number) REFERENCES ACCOUNT(accNum, branch_number, bank_number),
    CONSTRAINT pk7 PRIMARY KEY (custNum, accNum, branch_number, bank_number)
);

CREATE TABLE LOAN(
    loanNum CHAR(15),
    interestRate float,
    balance float,
    branch_number CHAR(15),
    bank_number CHAR(15),
    CONSTRAINT fk7 FOREIGN KEY (branch_number, bank_number) REFERENCES BRANCH(number, bank_number),
    CONSTRAINT pk8 PRIMARY KEY (loanNum, branch_number, bank_number)
);

CREATE TABLE REVOLVING_LOAN(
    loanNum CHAR(15),
    branch_number CHAR(15),
    bank_number CHAR(15),
    lim FLOAT,
    expiry DATE,
    CONSTRAINT fk8 FOREIGN KEY (loanNum, branch_number, bank_number) REFERENCES LOAN(loanNum, branch_number, bank_number),
    CONSTRAINT pk9 PRIMARY KEY (loanNum, branch_number, bank_number)
);


CREATE TABLE REGULAR_LOAN(
    loanNum CHAR(15),
    branch_number CHAR(15),
    bank_number CHAR(15),
    amount FLOAT,
    date DATE,
    address CHAR(50),
    amortization FLOAT,
    model CHAR(50),
    gradYear CHAR(4) CHECK (gradYear ~ '^\d{4}$'),
    CONSTRAINT fk10 FOREIGN KEY (loanNum, branch_number, bank_number) REFERENCES LOAN(loanNum, branch_number, bank_number),
    CONSTRAINT pk11 PRIMARY KEY (loanNum, branch_number, bank_number)
);



CREATE TABLE CUSTOMER_BORROW_LOAN(
    custNum CHAR(15),
    loanNum CHAR(15),
    branch_number CHAR(15),
    bank_number CHAR(15),
    CONSTRAINT fk13 FOREIGN KEY (custNum) REFERENCES CUSTOMER(custNum),
    CONSTRAINT fk14 FOREIGN KEY (loanNum, branch_number, bank_number) REFERENCES LOAN(loanNum, branch_number, bank_number),
    CONSTRAINT pk14 PRIMARY KEY (custNum, loanNum, branch_number, bank_number)
);


/* 4a */
INSERT INTO BANK(name, number) VALUES ('Royal bank', '001');
INSERT INTO BRANCH (number, bank_number, address, phone) VALUES ('1', '001', '567 Ellice Ave', '1233454567');
INSERT INTO CUSTOMER(custNum, first, last) VALUES ('221', 'James', 'Bond');

INSERT INTO LOAN(loanNum, interestRate, balance, branch_number, bank_number) VALUES ('001', '0.1', 20000, '1','001');
INSERT INTO REGULAR_LOAN(loanNum, branch_number, bank_number, amount, date, address, amortization, model, gradYear) VALUES ('001', '1', '001', 20000, '2020-01-01', null, null, null, '2024');
INSERT INTO CUSTOMER_BORROW_LOAN(custNum, loanNum, branch_number, bank_number) VALUES ('221', '001', '1', '001');

INSERT INTO LOAN(loanNum, interestRate, balance, branch_number, bank_number) VALUES ('002', '0.3', 5000, '1','001');
INSERT INTO REVOLVING_LOAN(loanNum, branch_number, bank_number, lim, expiry) VALUES ('002', '1', '001', 10000, null);
INSERT INTO CUSTOMER_BORROW_LOAN(custNum, loanNum, branch_number, bank_number) VALUES ('221', '002', '1', '001');


/* 4b */
INSERT INTO BANK(name, number) VALUES ('TD Bank', '002');
INSERT INTO BRANCH (number, bank_number, address, phone) VALUES ('1', '002', '1234 Portage Ave', '9876543210');

INSERT INTO ACCOUNT(accNum, balance, branch_number, bank_number, overdraft, interestRate) VALUES('111111', 10000, '1', '002', null, null);
INSERT INTO CUSTOMER_HAS_ACCOUNT(custNum, accNum, branch_number, bank_number) VALUES ('221', '111111', '1', '002');


/* 4c */
INSERT INTO CUSTOMER(custNum, first, last) VALUES ('222', 'Annie', 'Kingston');

INSERT INTO BRANCH (number, bank_number, address, phone) VALUES ('2', '001', '123 King Ave', '1112223334');

INSERT INTO ACCOUNT(accNum, balance, branch_number, bank_number, overdraft, interestRate) VALUES('111111', 10000, '2', '001', null, 0.02);
INSERT INTO CUSTOMER_HAS_ACCOUNT(custNum, accNum, branch_number, bank_number) VALUES ('222', '111111', '2', '001');

INSERT INTO LOAN(loanNum, interestRate, balance, branch_number, bank_number) VALUES ('001', '0.05', 400000, '2','001');
INSERT INTO REGULAR_LOAN(loanNum, branch_number, bank_number, amount, date, address, amortization, model, gradYear) VALUES ('001', '2', '001', 400000, '2020-01-01','1111 Spruce St', 120, null, null);
INSERT INTO CUSTOMER_BORROW_LOAN(custNum, loanNum, branch_number, bank_number) VALUES ('222', '001', '2', '001');

/* 4d */
INSERT INTO CUSTOMER(custNum, first, last) VALUES ('223', 'Roger', 'Rudiger');

INSERT INTO BRANCH (number, bank_number, address, phone) VALUES ('3', '001', '321 Notre Dame Ave', '9998887776');

INSERT INTO ACCOUNT(accNum, balance, branch_number, bank_number, overdraft, interestRate) VALUES('111111', 10000, '3', '001', null, 0.02);
INSERT INTO CUSTOMER_HAS_ACCOUNT(custNum, accNum, branch_number, bank_number) VALUES ('223', '111111', '3', '001');

INSERT INTO LOAN(loanNum, interestRate, balance, branch_number, bank_number) VALUES ('001', '0.3', 5000, '3','001');
INSERT INTO REVOLVING_LOAN(loanNum, branch_number, bank_number, lim, expiry) VALUES ('001', '3', '001', 10000, '2025-01-01');
INSERT INTO CUSTOMER_BORROW_LOAN(custNum, loanNum, branch_number, bank_number) VALUES ('223', '001', '3', '001');

INSERT INTO BANK(name, number) VALUES ('Scotia Bank', '003');
INSERT INTO BRANCH (number, bank_number, address, phone) VALUES ('1', '003', '1111 Selkirk Ave', '1234567890');

INSERT INTO LOAN(loanNum, interestRate, balance, branch_number, bank_number) VALUES ('001', '0.3', 5000, '1','003');
INSERT INTO REVOLVING_LOAN(loanNum, branch_number, bank_number, lim, expiry) VALUES ('001', '1', '003', 10000, '2025-01-01');
INSERT INTO CUSTOMER_BORROW_LOAN(custNum, loanNum, branch_number, bank_number) VALUES ('223', '001', '1', '003');

/* 4e */
INSERT INTO CUSTOMER(custNum, first, last) VALUES ('224', 'John', 'Wick');

INSERT INTO BRANCH (number, bank_number, address, phone) VALUES ('2', '003', '150 Ellice', '3123121232');

INSERT INTO ACCOUNT(accNum, balance, branch_number, bank_number, overdraft, interestRate) VALUES('111111', 10000, '2', '003', 100, null);
INSERT INTO CUSTOMER_HAS_ACCOUNT(custNum, accNum, branch_number, bank_number) VALUES ('224', '111111', '2', '003');

/* 4f */

SELECT * FROM (BANK b 
INNER JOIN BRANCH br ON b.number = br.bank_number
INNER JOIN ACCOUNT a ON b.number = a.bank_number AND br.number = a.branch_number
INNER JOIN CUSTOMER_HAS_ACCOUNT cha ON a.accNum = cha.accNum AND  b.number = cha.bank_number AND br.number = cha.branch_number
INNER JOIN CUSTOMER c ON c.custNum = cha.custNum) t1
FULL OUTER JOIN
(BANK b2
INNER JOIN BRANCH br2 ON b2.number = br2.bank_number
INNER JOIN LOAN l ON b2.number = l.bank_number AND br2.number = l.branch_number
INNER JOIN CUSTOMER_BORROW_LOAN cbl ON l.loanNum = cbl.loanNum AND  b2.number = cbl.bank_number AND br2.number = cbl.branch_number
INNER JOIN CUSTOMER c2 ON c2.custNum = cbl.custNum) t2
ON t1.name = t2.name