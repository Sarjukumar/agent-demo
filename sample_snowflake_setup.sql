-- Snowflake P&C Insurance Database Setup Script
-- This script includes DDL for table creation and DML for sample data insertion.

-- Drop tables if they exist (optional, for clean setup)
DROP TABLE IF EXISTS ClaimNotes;
DROP TABLE IF EXISTS ClaimSubrogations;
DROP TABLE IF EXISTS ClaimPayments;
DROP TABLE IF EXISTS ClaimReserves;
DROP TABLE IF EXISTS ClaimCoverages;
DROP TABLE IF EXISTS Claimants;
DROP TABLE IF EXISTS Claims;
DROP TABLE IF EXISTS BillingSchedules;
DROP TABLE IF EXISTS PolicyTransactions;
DROP TABLE IF EXISTS InsuredAssets;
DROP TABLE IF EXISTS PolicyCoverages;
DROP TABLE IF EXISTS Policies;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Users;

-- 1. Common/Lookup Tables

CREATE TABLE Users (
    UserID VARCHAR PRIMARY KEY,
    UserName VARCHAR,
    Role VARCHAR
);

-- 2. Policy Domain Tables

CREATE TABLE Customers (
    CustomerID VARCHAR PRIMARY KEY,
    CustomerType VARCHAR,
    FirstName VARCHAR,
    LastName VARCHAR,
    CompanyName VARCHAR,
    DateOfBirth DATE,
    AddressLine1 VARCHAR,
    AddressLine2 VARCHAR,
    City VARCHAR,
    State VARCHAR(2),
    ZipCode VARCHAR(10),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

CREATE TABLE Policies (
    PolicyID VARCHAR PRIMARY KEY,
    CustomerID VARCHAR, -- FK to Customers.CustomerID
    PolicyType VARCHAR,
    EffectiveDate DATE,
    ExpirationDate DATE,
    Status VARCHAR,
    TotalPremium DECIMAL(18,2),
    UnderwriterID VARCHAR, -- FK to Users.UserID
    IssueDate DATE,
    CancellationDate DATE,
    CancellationReason VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (UnderwriterID) REFERENCES Users(UserID)
);

CREATE TABLE PolicyCoverages (
    PolicyCoverageID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    CoverageType VARCHAR,
    CoverageLimit DECIMAL(18,2),
    Deductible DECIMAL(18,2),
    PremiumForCoverage DECIMAL(18,2),
    EffectiveDate DATE,
    ExpirationDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE InsuredAssets (
    InsuredAssetID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    AssetType VARCHAR,
    Description VARCHAR,
    VIN VARCHAR(17),
    Make VARCHAR,
    Model VARCHAR,
    Year INTEGER,
    PropertyAddressLine1 VARCHAR,
    PropertyCity VARCHAR,
    PropertyState VARCHAR(2),
    PropertyZipCode VARCHAR(10),
    InsuredValue DECIMAL(18,2),
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE PolicyTransactions (
    PolicyTransactionID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    TransactionType VARCHAR,
    TransactionDate DATE,
    EffectiveDate DATE,
    Description VARCHAR,
    PremiumChangeAmount DECIMAL(18,2),
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE BillingSchedules (
    BillingScheduleID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    InstallmentNumber INTEGER,
    DueDate DATE,
    AmountDue DECIMAL(18,2),
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

-- 3. Claims Domain Tables

CREATE TABLE Claims (
    ClaimID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    InsuredAssetID VARCHAR, -- FK to InsuredAssets.InsuredAssetID
    DateOfLoss TIMESTAMP_NTZ,
    DateReported TIMESTAMP_NTZ,
    CauseOfLoss VARCHAR,
    LossDescription VARCHAR,
    Status VARCHAR,
    LocationOfLoss_Address VARCHAR,
    LocationOfLoss_City VARCHAR,
    LocationOfLoss_State VARCHAR(2),
    LocationOfLoss_ZipCode VARCHAR(10),
    AssignedAdjusterID VARCHAR, -- FK to Users.UserID
    IsPotentiallyFraudulent BOOLEAN DEFAULT FALSE,
    FraudScore DECIMAL(5,2),
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID),
    FOREIGN KEY (InsuredAssetID) REFERENCES InsuredAssets(InsuredAssetID),
    FOREIGN KEY (AssignedAdjusterID) REFERENCES Users(UserID)
);

CREATE TABLE Claimants (
    ClaimantID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    CustomerID VARCHAR, -- FK to Customers.CustomerID
    ClaimantType VARCHAR,
    FirstName VARCHAR,
    LastName VARCHAR,
    CompanyName VARCHAR,
    AddressLine1 VARCHAR,
    City VARCHAR,
    State VARCHAR(2),
    ZipCode VARCHAR(10),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE ClaimCoverages (
    ClaimCoverageID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    PolicyCoverageID VARCHAR, -- FK to PolicyCoverages.PolicyCoverageID
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (PolicyCoverageID) REFERENCES PolicyCoverages(PolicyCoverageID)
);

CREATE TABLE ClaimReserves (
    ClaimReserveID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    PolicyCoverageID VARCHAR, -- FK to PolicyCoverages.PolicyCoverageID
    ReserveType VARCHAR,
    InitialReserveAmount DECIMAL(18,2),
    CurrentReserveAmount DECIMAL(18,2),
    ReserveSetDate DATE,
    LastUpdatedDate TIMESTAMP_NTZ,
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (PolicyCoverageID) REFERENCES PolicyCoverages(PolicyCoverageID)
);

CREATE TABLE ClaimPayments (
    ClaimPaymentID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    PolicyCoverageID VARCHAR, -- FK to PolicyCoverages.PolicyCoverageID
    ClaimantID VARCHAR, -- FK to Claimants.ClaimantID
    PaymentType VARCHAR,
    PaymentAmount DECIMAL(18,2),
    PaymentDate DATE,
    CheckNumber VARCHAR,
    PaymentMethod VARCHAR,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (PolicyCoverageID) REFERENCES PolicyCoverages(PolicyCoverageID),
    FOREIGN KEY (ClaimantID) REFERENCES Claimants(ClaimantID)
);

CREATE TABLE ClaimSubrogations (
    SubrogationID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    SubrogationTargetName VARCHAR,
    PotentialRecoveryAmount DECIMAL(18,2),
    AmountRecovered DECIMAL(18,2) DEFAULT 0.00,
    Status VARCHAR,
    RecoveryDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID)
);

CREATE TABLE ClaimNotes (
    ClaimNoteID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    NoteText VARCHAR,
    CreatedByUserID VARCHAR, -- FK to Users.UserID
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

-- End of DDL

-- Sample Data INSERT Statements will be appended below by the next step.


-- Snowflake P&C Insurance Database Setup Script
-- This script includes DDL for table creation and DML for sample data insertion.

-- Drop tables if they exist (optional, for clean setup)
DROP TABLE IF EXISTS ClaimNotes;
DROP TABLE IF EXISTS ClaimSubrogations;
DROP TABLE IF EXISTS ClaimPayments;
DROP TABLE IF EXISTS ClaimReserves;
DROP TABLE IF EXISTS ClaimCoverages;
DROP TABLE IF EXISTS Claimants;
DROP TABLE IF EXISTS Claims;
DROP TABLE IF EXISTS BillingSchedules;
DROP TABLE IF EXISTS PolicyTransactions;
DROP TABLE IF EXISTS InsuredAssets;
DROP TABLE IF EXISTS PolicyCoverages;
DROP TABLE IF EXISTS Policies;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Users;

-- 1. Common/Lookup Tables

CREATE TABLE Users (
    UserID VARCHAR PRIMARY KEY,
    UserName VARCHAR,
    Role VARCHAR
);

-- 2. Policy Domain Tables

CREATE TABLE Customers (
    CustomerID VARCHAR PRIMARY KEY,
    CustomerType VARCHAR,
    FirstName VARCHAR,
    LastName VARCHAR,
    CompanyName VARCHAR,
    DateOfBirth DATE,
    AddressLine1 VARCHAR,
    AddressLine2 VARCHAR,
    City VARCHAR,
    State VARCHAR(2),
    ZipCode VARCHAR(10),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

CREATE TABLE Policies (
    PolicyID VARCHAR PRIMARY KEY,
    CustomerID VARCHAR, -- FK to Customers.CustomerID
    PolicyType VARCHAR,
    EffectiveDate DATE,
    ExpirationDate DATE,
    Status VARCHAR,
    TotalPremium DECIMAL(18,2),
    UnderwriterID VARCHAR, -- FK to Users.UserID
    IssueDate DATE,
    CancellationDate DATE,
    CancellationReason VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (UnderwriterID) REFERENCES Users(UserID)
);

CREATE TABLE PolicyCoverages (
    PolicyCoverageID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    CoverageType VARCHAR,
    CoverageLimit DECIMAL(18,2),
    Deductible DECIMAL(18,2),
    PremiumForCoverage DECIMAL(18,2),
    EffectiveDate DATE,
    ExpirationDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE InsuredAssets (
    InsuredAssetID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    AssetType VARCHAR,
    Description VARCHAR,
    VIN VARCHAR(17),
    Make VARCHAR,
    Model VARCHAR,
    Year INTEGER,
    PropertyAddressLine1 VARCHAR,
    PropertyCity VARCHAR,
    PropertyState VARCHAR(2),
    PropertyZipCode VARCHAR(10),
    InsuredValue DECIMAL(18,2),
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE PolicyTransactions (
    PolicyTransactionID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    TransactionType VARCHAR,
    TransactionDate DATE,
    EffectiveDate DATE,
    Description VARCHAR,
    PremiumChangeAmount DECIMAL(18,2),
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE BillingSchedules (
    BillingScheduleID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    InstallmentNumber INTEGER,
    DueDate DATE,
    AmountDue DECIMAL(18,2),
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

-- 3. Claims Domain Tables

CREATE TABLE Claims (
    ClaimID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR, -- FK to Policies.PolicyID
    InsuredAssetID VARCHAR, -- FK to InsuredAssets.InsuredAssetID
    DateOfLoss TIMESTAMP_NTZ,
    DateReported TIMESTAMP_NTZ,
    CauseOfLoss VARCHAR,
    LossDescription VARCHAR,
    Status VARCHAR,
    LocationOfLoss_Address VARCHAR,
    LocationOfLoss_City VARCHAR,
    LocationOfLoss_State VARCHAR(2),
    LocationOfLoss_ZipCode VARCHAR(10),
    AssignedAdjusterID VARCHAR, -- FK to Users.UserID
    IsPotentiallyFraudulent BOOLEAN DEFAULT FALSE,
    FraudScore DECIMAL(5,2),
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID),
    FOREIGN KEY (InsuredAssetID) REFERENCES InsuredAssets(InsuredAssetID),
    FOREIGN KEY (AssignedAdjusterID) REFERENCES Users(UserID)
);

CREATE TABLE Claimants (
    ClaimantID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    CustomerID VARCHAR, -- FK to Customers.CustomerID
    ClaimantType VARCHAR,
    FirstName VARCHAR,
    LastName VARCHAR,
    CompanyName VARCHAR,
    AddressLine1 VARCHAR,
    City VARCHAR,
    State VARCHAR(2),
    ZipCode VARCHAR(10),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE ClaimCoverages (
    ClaimCoverageID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    PolicyCoverageID VARCHAR, -- FK to PolicyCoverages.PolicyCoverageID
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (PolicyCoverageID) REFERENCES PolicyCoverages(PolicyCoverageID)
);

CREATE TABLE ClaimReserves (
    ClaimReserveID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    PolicyCoverageID VARCHAR, -- FK to PolicyCoverages.PolicyCoverageID
    ReserveType VARCHAR,
    InitialReserveAmount DECIMAL(18,2),
    CurrentReserveAmount DECIMAL(18,2),
    ReserveSetDate DATE,
    LastUpdatedDate TIMESTAMP_NTZ,
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (PolicyCoverageID) REFERENCES PolicyCoverages(PolicyCoverageID)
);

CREATE TABLE ClaimPayments (
    ClaimPaymentID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    PolicyCoverageID VARCHAR, -- FK to PolicyCoverages.PolicyCoverageID
    ClaimantID VARCHAR, -- FK to Claimants.ClaimantID
    PaymentType VARCHAR,
    PaymentAmount DECIMAL(18,2),
    PaymentDate DATE,
    CheckNumber VARCHAR,
    PaymentMethod VARCHAR,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (PolicyCoverageID) REFERENCES PolicyCoverages(PolicyCoverageID),
    FOREIGN KEY (ClaimantID) REFERENCES Claimants(ClaimantID)
);

CREATE TABLE ClaimSubrogations (
    SubrogationID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    SubrogationTargetName VARCHAR,
    PotentialRecoveryAmount DECIMAL(18,2),
    AmountRecovered DECIMAL(18,2) DEFAULT 0.00,
    Status VARCHAR,
    RecoveryDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID)
);

CREATE TABLE ClaimNotes (
    ClaimNoteID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR, -- FK to Claims.ClaimID
    NoteText VARCHAR,
    CreatedByUserID VARCHAR, -- FK to Users.UserID
    CreatedDate TIMESTAMP_NTZ,
    FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

-- End of DDL

-- Sample Data INSERT Statements (Approx. 5 records per table focus)

-- Users
INSERT INTO Users (UserID, UserName, Role) VALUES (
    "USER0001", "BarbaraDavis0", "SIU_Investigator");
INSERT INTO Users (UserID, UserName, Role) VALUES (
    "USER0002", "ThomasHernandez1", "Underwriter");
INSERT INTO Users (UserID, UserName, Role) VALUES (
    "USER0003", "JosephJohnson2", "Manager");
INSERT INTO Users (UserID, UserName, Role) VALUES (
    "USER0004", "MichaelWilliams3", "Manager");
INSERT INTO Users (UserID, UserName, Role) VALUES (
    "USER0005", "DavidSmith4", "ClaimsAdjuster");

-- Customers
INSERT INTO Customers (CustomerID, CustomerType, FirstName, LastName, CompanyName, DateOfBirth, AddressLine1, City, State, ZipCode, PhoneNumber, EmailAddress, CreatedDate, LastUpdatedDate) VALUES (
    "CUSTBA52E529", "Corporate", NULL, NULL, "Gonzalez Corp", NULL, "8261 Lakeview Dr", "Chicago", "IL", "90235", "(466)-886-3443", "gonzalez0@example.com", "2020-03-12 02:20:25", "2024-02-18 11:15:02");
INSERT INTO Customers (CustomerID, CustomerType, FirstName, LastName, CompanyName, DateOfBirth, AddressLine1, City, State, ZipCode, PhoneNumber, EmailAddress, CreatedDate, LastUpdatedDate) VALUES (
    "CUST0A356AD0", "Individual", "David", "Miller", NULL, "2003-05-14", "3244 Maple Dr", "Chicago", "CA", "56986", "(777)-658-2809", "miller1@example.com", "2022-06-24 13:12:08", "2024-02-18 00:45:56");
INSERT INTO Customers (CustomerID, CustomerType, FirstName, LastName, CompanyName, DateOfBirth, AddressLine1, City, State, ZipCode, PhoneNumber, EmailAddress, CreatedDate, LastUpdatedDate) VALUES (
    "CUSTABE75B96", "Corporate", NULL, NULL, "Smith Corp", NULL, "1332 Maple Dr", "New York", "CA", "15890", "(762)-171-2644", "smith2@example.com", "2023-07-21 23:55:03", "2024-01-04 04:59:41");
INSERT INTO Customers (CustomerID, CustomerType, FirstName, LastName, CompanyName, DateOfBirth, AddressLine1, City, State, ZipCode, PhoneNumber, EmailAddress, CreatedDate, LastUpdatedDate) VALUES (
    "CUST3303D490", "Individual", "Jessica", "Martinez", NULL, "1993-05-16", "2474 Lakeview Dr", "Dallas", "TX", "67829", "(437)-881-1137", "martinez3@example.com", "2020-04-28 21:22:54", "2024-02-16 02:37:53");
INSERT INTO Customers (CustomerID, CustomerType, FirstName, LastName, CompanyName, DateOfBirth, AddressLine1, City, State, ZipCode, PhoneNumber, EmailAddress, CreatedDate, LastUpdatedDate) VALUES (
    "CUST4ADFFB51", "Corporate", NULL, NULL, "Smith Ltd", NULL, "4226 Main St", "Los Angeles", "NY", "75546", "(572)-963-9617", "smith4@example.com", "2022-08-03 00:28:06", "2024-01-24 14:31:40");

-- Policies
INSERT INTO Policies (PolicyID, CustomerID, PolicyType, EffectiveDate, ExpirationDate, Status, TotalPremium, UnderwriterID, IssueDate, CancellationDate, CancellationReason, CreatedDate, LastUpdatedDate) VALUES (
    "POL0000001", "CUSTBA52E529", "Commercial Property", "2021-07-05", "2022-07-05", "Expired", 2680.22, "USER0003", "2021-06-25", NULL, NULL, "2021-06-24 00:00:00", "2023-03-23 07:54:07");
INSERT INTO Policies (PolicyID, CustomerID, PolicyType, EffectiveDate, ExpirationDate, Status, TotalPremium, UnderwriterID, IssueDate, CancellationDate, CancellationReason, CreatedDate, LastUpdatedDate) VALUES (
    "POL0000002", "CUST0A356AD0", "Homeowners", "2023-11-11", "2024-05-09", "Cancelled", 3826.38, "USER0002", "2023-11-08", "2024-04-09", "Customer Request", "2023-10-27 00:00:00", "2024-02-29 21:39:50");
INSERT INTO Policies (PolicyID, CustomerID, PolicyType, EffectiveDate, ExpirationDate, Status, TotalPremium, UnderwriterID, IssueDate, CancellationDate, CancellationReason, CreatedDate, LastUpdatedDate) VALUES (
    "POL0000003", "CUST3303D490", "Homeowners", "2021-12-25", "2022-12-25", "Active", 1522.28, "USER0003", "2021-12-22", NULL, NULL, "2021-12-13 00:00:00", "2024-03-06 22:46:37");

-- PolicyCoverages
INSERT INTO PolicyCoverages (PolicyCoverageID, PolicyID, CoverageType, CoverageLimit, Deductible, PremiumForCoverage, EffectiveDate, ExpirationDate, CreatedDate, LastUpdatedDate) VALUES (
    "PCOV00000001", "POL0000001", "Business Income", 74354.0, 500, 2290.05, "2021-07-05", "2022-07-05", "2021-06-24 00:00:00", "2023-03-23 07:54:07");
INSERT INTO PolicyCoverages (PolicyCoverageID, PolicyID, CoverageType, CoverageLimit, Deductible, PremiumForCoverage, EffectiveDate, ExpirationDate, CreatedDate, LastUpdatedDate) VALUES (
    "PCOV00000002", "POL0000002", "Other Structures", 135451.0, 250, 2057.54, "2023-11-11", "2024-05-09", "2023-10-27 00:00:00", "2024-02-29 21:39:50");
INSERT INTO PolicyCoverages (PolicyCoverageID, PolicyID, CoverageType, CoverageLimit, Deductible, PremiumForCoverage, EffectiveDate, ExpirationDate, CreatedDate, LastUpdatedDate) VALUES (
    "PCOV00000003", "POL0000002", "Personal Property", 262766.0, 1000, 1850.1, "2023-11-11", "2024-05-09", "2023-10-27 00:00:00", "2024-02-29 21:39:50");
INSERT INTO PolicyCoverages (PolicyCoverageID, PolicyID, CoverageType, CoverageLimit, Deductible, PremiumForCoverage, EffectiveDate, ExpirationDate, CreatedDate, LastUpdatedDate) VALUES (
    "PCOV00000004", "POL0000003", "Personal Property", 186924.0, 2500, 1491.57, "2021-12-25", "2022-12-25", "2021-12-13 00:00:00", "2024-03-06 22:46:37");

-- InsuredAssets
INSERT INTO InsuredAssets (InsuredAssetID, PolicyID, AssetType, Description, VIN, Make, Model, Year, PropertyAddressLine1, PropertyCity, PropertyState, PropertyZipCode, InsuredValue, CreatedDate, LastUpdatedDate) VALUES (
    "ASST00000001", "POL0000001", "Property", "Single Family Home at 636 Washington Blvd", NULL, NULL, NULL, NULL, "636 Washington Blvd", "New York", "CA", "13142", 1337620.0, "2021-06-24 00:00:00", "2023-03-23 07:54:07");
INSERT INTO InsuredAssets (InsuredAssetID, PolicyID, AssetType, Description, VIN, Make, Model, Year, PropertyAddressLine1, PropertyCity, PropertyState, PropertyZipCode, InsuredValue, CreatedDate, LastUpdatedDate) VALUES (
    "ASST00000002", "POL0000002", "Property", "Townhouse at 1637 Elm St", NULL, NULL, NULL, NULL, "1637 Elm St", "New York", "TX", "77855", 835227.0, "2023-10-27 00:00:00", "2024-02-29 21:39:50");
INSERT INTO InsuredAssets (InsuredAssetID, PolicyID, AssetType, Description, VIN, Make, Model, Year, PropertyAddressLine1, PropertyCity, PropertyState, PropertyZipCode, InsuredValue, CreatedDate, LastUpdatedDate) VALUES (
    "ASST00000003", "POL0000003", "Property", "Condo at 8308 Pine Ln", NULL, NULL, NULL, NULL, "8308 Pine Ln", "Phoenix", "NY", "28710", 1622699.0, "2021-12-13 00:00:00", "2024-03-06 22:46:37");

-- PolicyTransactions
INSERT INTO PolicyTransactions (PolicyTransactionID, PolicyID, TransactionType, TransactionDate, EffectiveDate, Description, PremiumChangeAmount, CreatedDate) VALUES (
    "PTX00000001", "POL0000001", "New Business", "2021-06-25", "2021-07-05", "New Commercial Property policy issued.", 2680.22, "2021-06-24 00:00:00");
INSERT INTO PolicyTransactions (PolicyTransactionID, PolicyID, TransactionType, TransactionDate, EffectiveDate, Description, PremiumChangeAmount, CreatedDate) VALUES (
    "PTX00000002", "POL0000002", "New Business", "2023-11-08", "2023-11-11", "New Homeowners policy issued.", 3826.38, "2023-10-27 00:00:00");
INSERT INTO PolicyTransactions (PolicyTransactionID, PolicyID, TransactionType, TransactionDate, EffectiveDate, Description, PremiumChangeAmount, CreatedDate) VALUES (
    "PTX00000003", "POL0000002", "Cancellation", "2024-04-09", "2024-04-09", "Policy cancelled due to Customer Request.", -1112.57, "2024-04-09 11:51:56");
INSERT INTO PolicyTransactions (PolicyTransactionID, PolicyID, TransactionType, TransactionDate, EffectiveDate, Description, PremiumChangeAmount, CreatedDate) VALUES (
    "PTX00000004", "POL0000003", "New Business", "2021-12-22", "2021-12-25", "New Homeowners policy issued.", 1522.28, "2021-12-13 00:00:00");

-- BillingSchedules
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000001", "POL0000001", 1, "2021-07-05", 670.05, 670.05, "2021-06-28", "Paid", "2021-06-24 00:00:00", "2021-10-09 11:19:32");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000002", "POL0000001", 2, "2021-10-04", 670.05, NULL, NULL, "Overdue", "2021-06-24 00:00:00", "2022-02-19 22:39:40");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000003", "POL0000001", 3, "2022-01-03", 670.05, NULL, NULL, "Overdue", "2021-06-24 00:00:00", "2022-06-23 06:05:41");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000004", "POL0000001", 4, "2022-04-04", 670.05, NULL, NULL, "Overdue", "2021-06-24 00:00:00", "2022-09-29 03:29:36");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000005", "POL0000002", 1, "2023-11-11", 3826.38, 3826.38, "2023-11-11", "Paid", "2023-10-27 00:00:00", "2024-03-18 01:59:00");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000006", "POL0000003", 1, "2021-12-25", 380.57, NULL, NULL, "Overdue", "2021-12-13 00:00:00", "2024-02-27 23:01:41");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000007", "POL0000003", 2, "2022-03-26", 380.57, NULL, NULL, "Pending", "2021-12-13 00:00:00", "2024-03-15 17:23:39");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000008", "POL0000003", 3, "2022-06-25", 380.57, 380.57, "2022-06-17", "Paid", "2021-12-13 00:00:00", "2023-03-03 06:09:23");
INSERT INTO BillingSchedules (BillingScheduleID, PolicyID, InstallmentNumber, DueDate, AmountDue, AmountPaid, PaymentDate, Status, CreatedDate, LastUpdatedDate) VALUES (
    "BILL00000009", "POL0000003", 4, "2022-09-24", 380.57, NULL, NULL, "Overdue", "2021-12-13 00:00:00", "2023-08-16 18:34:33");

-- Claims
INSERT INTO Claims (ClaimID, PolicyID, InsuredAssetID, DateOfLoss, DateReported, CauseOfLoss, LossDescription, Status, LocationOfLoss_Address, LocationOfLoss_City, LocationOfLoss_State, LocationOfLoss_ZipCode, AssignedAdjusterID, IsPotentiallyFraudulent, FraudScore, CreatedDate, LastUpdatedDate) VALUES (
    "CLM00000001", "POL0000003", "ASST00000003", "2022-09-30 11:22:26", "2022-10-10 11:22:26", "Theft", "Theft at insured property.", "Pending Investigation", "452 Washington Blvd", "San Antonio", "TX", "83326", "USER0002", FALSE, 0.35, "2022-10-10 11:22:26", "2022-12-25 05:14:27");

-- Claimants
INSERT INTO Claimants (ClaimantID, ClaimID, CustomerID, ClaimantType, FirstName, LastName, CompanyName, AddressLine1, City, State, ZipCode, PhoneNumber, EmailAddress, CreatedDate, LastUpdatedDate) VALUES (
    "CLMT00000001", "CLM00000001", "CUST3303D490", "Insured", "Jessica", "Martinez", NULL, "7215 Main St", "San Antonio", "CA", "16729", "(643)-763-3991", "martinez2@example.com", "2022-10-10 11:22:26", "2022-12-25 05:14:27");

-- ClaimCoverages
INSERT INTO ClaimCoverages (ClaimCoverageID, ClaimID, PolicyCoverageID, Status, CreatedDate) VALUES (
    "CCOV00000001", "CLM00000001", "PCOV00000004", "Applicable", "2022-10-10 11:22:26");

-- ClaimReserves
INSERT INTO ClaimReserves (ClaimReserveID, ClaimID, PolicyCoverageID, ReserveType, InitialReserveAmount, CurrentReserveAmount, ReserveSetDate, LastUpdatedDate, CreatedDate) VALUES (
    "CRES00000001", "CLM00000001", "PCOV00000004", "Indemnity", 32485.61, 32485.61, "2022-10-15", "2022-12-25 05:14:27", "2022-10-10 11:22:26");

-- ClaimPayments

-- ClaimSubrogations

-- ClaimNotes
INSERT INTO ClaimNotes (ClaimNoteID, ClaimID, NoteText, CreatedByUserID, CreatedDate) VALUES (
    "NOTE00000001", "CLM00000001", "Claim note 81: Initial assessment complete.", "USER0003", "2022-11-25 05:26:18");
INSERT INTO ClaimNotes (ClaimNoteID, ClaimID, NoteText, CreatedByUserID, CreatedDate) VALUES (
    "NOTE00000002", "CLM00000001", "Claim note 66: Contacted claimant.", "USER0003", "2022-12-07 16:22:57");

