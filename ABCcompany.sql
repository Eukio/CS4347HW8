
-- Drop database if exists and create fresh
DROP DATABASE IF EXISTS ABCcompany;
CREATE DATABASE ABCcompany;
USE ABCcompany;


CREATE TABLE PERSON (
    Personal_ID INT AUTO_INCREMENT PRIMARY KEY,
    Fname      VARCHAR(40) NOT NULL,
    Mname      VARCHAR(40),
    Lname      VARCHAR(40) NOT NULL,
    Age        INT CHECK (Age >= 0),
    Gender     VARCHAR(10),
    
    AddLine1   VARCHAR(100),
    AddLine2   VARCHAR(100),
    City       VARCHAR(50),
    State      VARCHAR(50),
    Zipcode    VARCHAR(10),
    PhoneNum   VARCHAR(20),
    EmailAdd   VARCHAR(80)
);


-- EMPLOYEE 
CREATE TABLE EMPLOYEE (
    Personal_ID INT PRIMARY KEY,
    Ranked        VARCHAR(40),
    Title       VARCHAR(60),
    SalaryAmount        DECIMAL(10,2),
    SalaryTransactionNo VARCHAR(30),
    SalaryPayDate       DATE,
    DeptID      INT,
    Supervisor_ID INT,
    CONSTRAINT fk_employee_person
        FOREIGN KEY (Personal_ID)
        REFERENCES PERSON(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE SALARY (
    Personal_ID   INT NOT NULL,
    TransactionNo VARCHAR(30) NOT NULL,
    PayDate       DATE NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Personal_ID, TransactionNo),
    CONSTRAINT fk_salary_employee
        FOREIGN KEY (Personal_ID)
        REFERENCES EMPLOYEE(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- POTENTIAL_EMPLOYEE 
CREATE TABLE POTENTIAL_EMPLOYEE (
    Personal_ID INT PRIMARY KEY,
    CONSTRAINT fk_potential_employee_person
        FOREIGN KEY (Personal_ID)
        REFERENCES PERSON(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- CUSTOMER 
CREATE TABLE CUSTOMER (
    Personal_ID INT PRIMARY KEY,
    PrefSalesmen VARCHAR(80),
    CONSTRAINT fk_customer_person
        FOREIGN KEY (Personal_ID)
        REFERENCES PERSON(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- CANDIDATE 
CREATE TABLE CANDIDATE (
    Personal_ID INT PRIMARY KEY,
    CONSTRAINT fk_candidate_potential
        FOREIGN KEY (Personal_ID)
        REFERENCES POTENTIAL_EMPLOYEE(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE EMPLOYEE
    ADD CONSTRAINT fk_employee_supervisor
        FOREIGN KEY (Supervisor_ID)
        REFERENCES EMPLOYEE(Personal_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE;


CREATE TABLE DEPARTMENT (
    DeptID     INT PRIMARY KEY,
    StartTime  TIME,
    EndTime    TIME,
    DeptName   VARCHAR(80) NOT NULL
);


ALTER TABLE EMPLOYEE
    ADD CONSTRAINT fk_employee_department
        FOREIGN KEY (DeptID)
        REFERENCES DEPARTMENT(DeptID)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

CREATE TABLE SITE (
    SiteID       INT PRIMARY KEY,
    SiteName     VARCHAR(80) NOT NULL,
    SiteLocation VARCHAR(120)
);

CREATE TABLE VENDOR (
    VendorID     INT PRIMARY KEY,
    Name         VARCHAR(80) NOT NULL,
    Address      VARCHAR(150),
    AccNo        VARCHAR(30),
    CreditRating VARCHAR(20),
    PurchasingWSURL VARCHAR(200)
);

CREATE TABLE PART (
    PartID  INT PRIMARY KEY
);

CREATE TABLE PRODUCT (
    ProductID   INT PRIMARY KEY,
    ProductType VARCHAR(40),
    Size        VARCHAR(40),
    ListPrice   DECIMAL(10,2) CHECK (ListPrice >= 0),
    Weight      DECIMAL(10,2),
    Style       VARCHAR(40)
);


-- Assumption: Each ORDER_INFO row refers to exactly one Product.
CREATE TABLE ORDER_INFO (
    OrderID     INT AUTO_INCREMENT PRIMARY KEY,
    ProductID   INT NOT NULL,
    NumOfParts  INT,         
    PartTypes   VARCHAR(80),
    CONSTRAINT fk_orderinfo_product
        FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE JOB_POSITION (
    JobID       INT PRIMARY KEY,
    Description VARCHAR(200),
    DeptID      INT,
    PostedDate  DATE,
    CONSTRAINT fk_jobposition_department
        FOREIGN KEY (DeptID)
        REFERENCES DEPARTMENT(DeptID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE JOB_APPLICATION (
    Personal_ID INT NOT NULL,
    JobID       INT NOT NULL,
    ApplyDate   DATE,
    PRIMARY KEY (Personal_ID, JobID),
    CONSTRAINT fk_jobapp_person
        FOREIGN KEY (Personal_ID)
        REFERENCES PERSON(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_jobapp_job
        FOREIGN KEY (JobID)
        REFERENCES JOB_POSITION(JobID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE INTERVIEW (
    InterviewID   INT AUTO_INCREMENT PRIMARY KEY,
    Candidate_ID  INT NOT NULL,
    JobID         INT NOT NULL,
    InterviewTime DATETIME,
    Grade         VARCHAR(10),
    CONSTRAINT fk_interview_candidate
        FOREIGN KEY (Candidate_ID)
        REFERENCES CANDIDATE(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_interview_job
        FOREIGN KEY (JobID)
        REFERENCES JOB_POSITION(JobID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE PURCHASE_FROM (
    JobID      INT NOT NULL,
    VendorID   INT NOT NULL,
    PostedDate DATE,
    PRIMARY KEY (JobID, VendorID),
    CONSTRAINT fk_purchase_job
        FOREIGN KEY (JobID)
        REFERENCES JOB_POSITION(JobID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_purchase_vendor
        FOREIGN KEY (VendorID)
        REFERENCES VENDOR(VendorID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE SUPPLIES (
    VendorID         INT NOT NULL,
    PartID           INT NOT NULL,
    LastPurchaseDate DATE,
    UnitPrice        DECIMAL(10,2) CHECK (UnitPrice >= 0),
    PRIMARY KEY (VendorID, PartID),
    CONSTRAINT fk_supplies_vendor
        FOREIGN KEY (VendorID)
        REFERENCES VENDOR(VendorID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_supplies_part
        FOREIGN KEY (PartID)
        REFERENCES PART(PartID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE WORKS_ON (
    Personal_ID INT NOT NULL,
    SiteID      INT NOT NULL,
    PRIMARY KEY (Personal_ID, SiteID),
    CONSTRAINT fk_workson_employee
        FOREIGN KEY (Personal_ID)
        REFERENCES EMPLOYEE(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_workson_site
        FOREIGN KEY (SiteID)
        REFERENCES SITE(SiteID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE CREATES (
    Personal_ID INT NOT NULL,   -- Candidate
    ProductID   INT NOT NULL,
    PRIMARY KEY (Personal_ID, ProductID),
    CONSTRAINT fk_creates_candidate
        FOREIGN KEY (Personal_ID)
        REFERENCES CANDIDATE(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_creates_product
        FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE TRACKS (
    Employee_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    ProductID   INT NOT NULL,
    PRIMARY KEY (Employee_ID, Customer_ID, ProductID),
    CONSTRAINT fk_tracks_employee
        FOREIGN KEY (Employee_ID)
        REFERENCES EMPLOYEE(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_tracks_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES CUSTOMER(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_tracks_product
        FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE SALE_HISTORY (
    SaleID      INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    ProductID   INT NOT NULL,
    SalesTime   DATETIME NOT NULL,
    CONSTRAINT fk_salehistory_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES CUSTOMER(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_salehistory_product
        FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE BUYS (
    Customer_ID INT NOT NULL,
    ProductID   INT NOT NULL,
    SalesTime   DATETIME NOT NULL,
    PRIMARY KEY (Customer_ID, ProductID, SalesTime),
    CONSTRAINT fk_buys_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES CUSTOMER(Personal_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_buys_product
        FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
