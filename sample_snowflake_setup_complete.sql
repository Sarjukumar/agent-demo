-- Snowflake P&C Insurance Database Setup Script
-- This script includes DDL for table creation and DML for sample data insertion.

-- -----------------------------------------------------
-- Data Definition Language (DDL)
-- -----------------------------------------------------

-- Users Table
CREATE TABLE IF NOT EXISTS Users (
    UserID VARCHAR PRIMARY KEY,
    UserName VARCHAR,
    Role VARCHAR
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
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

-- Policies Table
CREATE TABLE IF NOT EXISTS Policies (
    PolicyID VARCHAR PRIMARY KEY,
    CustomerID VARCHAR REFERENCES Customers(CustomerID),
    PolicyType VARCHAR,
    EffectiveDate DATE,
    ExpirationDate DATE,
    Status VARCHAR,
    TotalPremium DECIMAL(18,2),
    UnderwriterID VARCHAR REFERENCES Users(UserID),
    IssueDate DATE,
    CancellationDate DATE,
    CancellationReason VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- PolicyCoverages Table
CREATE TABLE IF NOT EXISTS PolicyCoverages (
    PolicyCoverageID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    CoverageType VARCHAR,
    CoverageLimit DECIMAL(18,2),
    Deductible DECIMAL(18,2),
    PremiumForCoverage DECIMAL(18,2),
    EffectiveDate DATE,
    ExpirationDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- InsuredAssets Table
CREATE TABLE IF NOT EXISTS InsuredAssets (
    InsuredAssetID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
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
    LastUpdatedDate TIMESTAMP_NTZ
);

-- PolicyTransactions Table
CREATE TABLE IF NOT EXISTS PolicyTransactions (
    PolicyTransactionID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    TransactionType VARCHAR,
    TransactionDate DATE,
    EffectiveDate DATE,
    Description VARCHAR,
    PremiumChangeAmount DECIMAL(18,2),
    CreatedDate TIMESTAMP_NTZ
);

-- BillingSchedules Table
CREATE TABLE IF NOT EXISTS BillingSchedules (
    BillingScheduleID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    InstallmentNumber INTEGER,
    DueDate DATE,
    AmountDue DECIMAL(18,2),
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- Claims Table
CREATE TABLE IF NOT EXISTS Claims (
    ClaimID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    InsuredAssetID VARCHAR REFERENCES InsuredAssets(InsuredAssetID),
    DateOfLoss TIMESTAMP_NTZ,
    DateReported TIMESTAMP_NTZ,
    CauseOfLoss VARCHAR,
    LossDescription VARCHAR,
    Status VARCHAR,
    LocationOfLoss_Address VARCHAR,
    LocationOfLoss_City VARCHAR,
    LocationOfLoss_State VARCHAR(2),
    LocationOfLoss_ZipCode VARCHAR(10),
    AssignedAdjusterID VARCHAR REFERENCES Users(UserID),
    IsPotentiallyFraudulent BOOLEAN DEFAULT FALSE,
    FraudScore DECIMAL(5,2),
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- Claimants Table
CREATE TABLE IF NOT EXISTS Claimants (
    ClaimantID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    CustomerID VARCHAR REFERENCES Customers(CustomerID),
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
    LastUpdatedDate TIMESTAMP_NTZ
);

-- ClaimCoverages Table
CREATE TABLE IF NOT EXISTS ClaimCoverages (
    ClaimCoverageID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    PolicyCoverageID VARCHAR REFERENCES PolicyCoverages(PolicyCoverageID),
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ
);

-- ClaimReserves Table
CREATE TABLE IF NOT EXISTS ClaimReserves (
    ClaimReserveID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    PolicyCoverageID VARCHAR REFERENCES PolicyCoverages(PolicyCoverageID),
    ReserveType VARCHAR,
    InitialReserveAmount DECIMAL(18,2),
    CurrentReserveAmount DECIMAL(18,2),
    ReserveSetDate DATE,
    LastUpdatedDate TIMESTAMP_NTZ,
    CreatedDate TIMESTAMP_NTZ
);

-- ClaimPayments Table
CREATE TABLE IF NOT EXISTS ClaimPayments (
    ClaimPaymentID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    PolicyCoverageID VARCHAR REFERENCES PolicyCoverages(PolicyCoverageID),
    ClaimantID VARCHAR REFERENCES Claimants(ClaimantID),
    PaymentType VARCHAR,
    PaymentAmount DECIMAL(18,2),
    PaymentDate DATE,
    CheckNumber VARCHAR,
    PaymentMethod VARCHAR,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ
);

-- ClaimSubrogations Table
CREATE TABLE IF NOT EXISTS ClaimSubrogations (
    SubrogationID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    SubrogationTargetName VARCHAR,
    PotentialRecoveryAmount DECIMAL(18,2),
    AmountRecovered DECIMAL(18,2) DEFAULT 0.00,
    Status VARCHAR,
    RecoveryDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- ClaimNotes Table
CREATE TABLE IF NOT EXISTS ClaimNotes (
    ClaimNoteID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    NoteText VARCHAR,
    CreatedByUserID VARCHAR REFERENCES Users(UserID),
    CreatedDate TIMESTAMP_NTZ
);

-- -----------------------------------------------------
-- Data Manipulation Language (DML) - Sample Data
-- -----------------------------------------------------



-- Snowflake P&C Insurance Database Setup Script
-- This script includes DDL for table creation and DML for sample data insertion.

-- -----------------------------------------------------
-- Data Definition Language (DDL)
-- -----------------------------------------------------

-- Users Table
CREATE TABLE IF NOT EXISTS Users (
    UserID VARCHAR PRIMARY KEY,
    UserName VARCHAR,
    Role VARCHAR
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
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

-- Policies Table
CREATE TABLE IF NOT EXISTS Policies (
    PolicyID VARCHAR PRIMARY KEY,
    CustomerID VARCHAR REFERENCES Customers(CustomerID),
    PolicyType VARCHAR,
    EffectiveDate DATE,
    ExpirationDate DATE,
    Status VARCHAR,
    TotalPremium DECIMAL(18,2),
    UnderwriterID VARCHAR REFERENCES Users(UserID),
    IssueDate DATE,
    CancellationDate DATE,
    CancellationReason VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- PolicyCoverages Table
CREATE TABLE IF NOT EXISTS PolicyCoverages (
    PolicyCoverageID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    CoverageType VARCHAR,
    CoverageLimit DECIMAL(18,2),
    Deductible DECIMAL(18,2),
    PremiumForCoverage DECIMAL(18,2),
    EffectiveDate DATE,
    ExpirationDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- InsuredAssets Table
CREATE TABLE IF NOT EXISTS InsuredAssets (
    InsuredAssetID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
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
    LastUpdatedDate TIMESTAMP_NTZ
);

-- PolicyTransactions Table
CREATE TABLE IF NOT EXISTS PolicyTransactions (
    PolicyTransactionID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    TransactionType VARCHAR,
    TransactionDate DATE,
    EffectiveDate DATE,
    Description VARCHAR,
    PremiumChangeAmount DECIMAL(18,2),
    CreatedDate TIMESTAMP_NTZ
);

-- BillingSchedules Table
CREATE TABLE IF NOT EXISTS BillingSchedules (
    BillingScheduleID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    InstallmentNumber INTEGER,
    DueDate DATE,
    AmountDue DECIMAL(18,2),
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- Claims Table
CREATE TABLE IF NOT EXISTS Claims (
    ClaimID VARCHAR PRIMARY KEY,
    PolicyID VARCHAR REFERENCES Policies(PolicyID),
    InsuredAssetID VARCHAR REFERENCES InsuredAssets(InsuredAssetID),
    DateOfLoss TIMESTAMP_NTZ,
    DateReported TIMESTAMP_NTZ,
    CauseOfLoss VARCHAR,
    LossDescription VARCHAR,
    Status VARCHAR,
    LocationOfLoss_Address VARCHAR,
    LocationOfLoss_City VARCHAR,
    LocationOfLoss_State VARCHAR(2),
    LocationOfLoss_ZipCode VARCHAR(10),
    AssignedAdjusterID VARCHAR REFERENCES Users(UserID),
    IsPotentiallyFraudulent BOOLEAN DEFAULT FALSE,
    FraudScore DECIMAL(5,2),
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- Claimants Table
CREATE TABLE IF NOT EXISTS Claimants (
    ClaimantID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    CustomerID VARCHAR REFERENCES Customers(CustomerID),
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
    LastUpdatedDate TIMESTAMP_NTZ
);

-- ClaimCoverages Table
CREATE TABLE IF NOT EXISTS ClaimCoverages (
    ClaimCoverageID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    PolicyCoverageID VARCHAR REFERENCES PolicyCoverages(PolicyCoverageID),
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ
);

-- ClaimReserves Table
CREATE TABLE IF NOT EXISTS ClaimReserves (
    ClaimReserveID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    PolicyCoverageID VARCHAR REFERENCES PolicyCoverages(PolicyCoverageID),
    ReserveType VARCHAR,
    InitialReserveAmount DECIMAL(18,2),
    CurrentReserveAmount DECIMAL(18,2),
    ReserveSetDate DATE,
    LastUpdatedDate TIMESTAMP_NTZ,
    CreatedDate TIMESTAMP_NTZ
);

-- ClaimPayments Table
CREATE TABLE IF NOT EXISTS ClaimPayments (
    ClaimPaymentID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    PolicyCoverageID VARCHAR REFERENCES PolicyCoverages(PolicyCoverageID),
    ClaimantID VARCHAR REFERENCES Claimants(ClaimantID),
    PaymentType VARCHAR,
    PaymentAmount DECIMAL(18,2),
    PaymentDate DATE,
    CheckNumber VARCHAR,
    PaymentMethod VARCHAR,
    Status VARCHAR,
    CreatedDate TIMESTAMP_NTZ
);

-- ClaimSubrogations Table
CREATE TABLE IF NOT EXISTS ClaimSubrogations (
    SubrogationID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    SubrogationTargetName VARCHAR,
    PotentialRecoveryAmount DECIMAL(18,2),
    AmountRecovered DECIMAL(18,2) DEFAULT 0.00,
    Status VARCHAR,
    RecoveryDate DATE,
    CreatedDate TIMESTAMP_NTZ,
    LastUpdatedDate TIMESTAMP_NTZ
);

-- ClaimNotes Table
CREATE TABLE IF NOT EXISTS ClaimNotes (
    ClaimNoteID VARCHAR PRIMARY KEY,
    ClaimID VARCHAR REFERENCES Claims(ClaimID),
    NoteText VARCHAR,
    CreatedByUserID VARCHAR REFERENCES Users(UserID),
    CreatedDate TIMESTAMP_NTZ
);

-- -----------------------------------------------------
-- Data Manipulation Language (DML) - Sample Data
-- -----------------------------------------------------

-- Sample Data for P&C Insurance Project (Targeting ~5 records for Claims related tables)

-- Data for Users
INSERT INTO "Users" ("UserID", "UserName", "Role") VALUES (
    'USER0001', 'MichaelSmith0', 'ClaimsAdjuster'
);
INSERT INTO "Users" ("UserID", "UserName", "Role") VALUES (
    'USER0002', 'JohnSmith1', 'Manager'
);
INSERT INTO "Users" ("UserID", "UserName", "Role") VALUES (
    'USER0003', 'JohnMiller2', 'Underwriter'
);
INSERT INTO "Users" ("UserID", "UserName", "Role") VALUES (
    'USER0004', 'LindaWilliams3', 'Manager'
);
INSERT INTO "Users" ("UserID", "UserName", "Role") VALUES (
    'USER0005', 'RobertJones4', 'Underwriter'
);

-- Data for Customers
INSERT INTO "Customers" ("CustomerID", "CustomerType", "FirstName", "LastName", "CompanyName", "DateOfBirth", "AddressLine1", "City", "State", "ZipCode", "PhoneNumber", "EmailAddress", "CreatedDate", "LastUpdatedDate") VALUES (
    'CUSTCDE9413C', 'Corporate', NULL, NULL, 'Smith Group', NULL, '2807 Pine Ln', 'New York', 'IL', '90017', '(447)-195-3406', 'smith0@example.com', '2021-03-22 20:14:45', '2024-01-08 03:04:10'
);
INSERT INTO "Customers" ("CustomerID", "CustomerType", "FirstName", "LastName", "CompanyName", "DateOfBirth", "AddressLine1", "City", "State", "ZipCode", "PhoneNumber", "EmailAddress", "CreatedDate", "LastUpdatedDate") VALUES (
    'CUST0019DF3D', 'Individual', 'Robert', 'Jones', NULL, '1953-07-30', '347 Maple Dr', 'Houston', 'CA', '70958', '(339)-348-1617', 'jones1@example.com', '2023-07-16 01:11:03', '2024-03-25 08:26:15'
);
INSERT INTO "Customers" ("CustomerID", "CustomerType", "FirstName", "LastName", "CompanyName", "DateOfBirth", "AddressLine1", "City", "State", "ZipCode", "PhoneNumber", "EmailAddress", "CreatedDate", "LastUpdatedDate") VALUES (
    'CUST203A203B', 'Individual', 'Michael', 'Rodriguez', NULL, '1989-11-16', '761 Cedar Rd', 'New York', 'TX', '93698', '(248)-184-4749', 'rodriguez2@example.com', '2020-03-03 11:11:07', '2024-03-21 01:58:44'
);
INSERT INTO "Customers" ("CustomerID", "CustomerType", "FirstName", "LastName", "CompanyName", "DateOfBirth", "AddressLine1", "City", "State", "ZipCode", "PhoneNumber", "EmailAddress", "CreatedDate", "LastUpdatedDate") VALUES (
    'CUST7FE909BA', 'Corporate', NULL, NULL, 'Davis Corp', NULL, '9700 Maple Dr', 'Houston', 'NY', '18213', '(188)-683-7295', 'davis3@example.com', '2021-05-20 00:59:15', '2024-02-02 12:16:42'
);
INSERT INTO "Customers" ("CustomerID", "CustomerType", "FirstName", "LastName", "CompanyName", "DateOfBirth", "AddressLine1", "City", "State", "ZipCode", "PhoneNumber", "EmailAddress", "CreatedDate", "LastUpdatedDate") VALUES (
    'CUSTD67B310F', 'Individual', 'Linda', 'Garcia', NULL, '1956-12-11', '1878 Pine Ln', 'Los Angeles', 'IL', '23373', '(360)-302-9619', 'garcia4@example.com', '2020-03-29 06:51:53', '2024-03-12 01:46:41'
);

-- Data for Policies
INSERT INTO "Policies" ("PolicyID", "CustomerID", "PolicyType", "EffectiveDate", "ExpirationDate", "Status", "TotalPremium", "UnderwriterID", "IssueDate", "CancellationDate", "CancellationReason", "CreatedDate", "LastUpdatedDate") VALUES (
    'POL0000001', 'CUSTCDE9413C', 'Commercial Property', '2022-09-28', '2023-09-28', 'Active', 645.88, 'USER0005', '2022-09-26', NULL, NULL, '2022-09-20 00:00:00', '2022-11-27 04:52:17'
);
INSERT INTO "Policies" ("PolicyID", "CustomerID", "PolicyType", "EffectiveDate", "ExpirationDate", "Status", "TotalPremium", "UnderwriterID", "IssueDate", "CancellationDate", "CancellationReason", "CreatedDate", "LastUpdatedDate") VALUES (
    'POL0000002', 'CUST0019DF3D', 'Auto', '2022-04-09', '2023-04-09', 'Active', 1776.69, 'USER0003', '2022-04-06', NULL, NULL, '2022-04-01 00:00:00', '2023-03-12 02:34:45'
);
INSERT INTO "Policies" ("PolicyID", "CustomerID", "PolicyType", "EffectiveDate", "ExpirationDate", "Status", "TotalPremium", "UnderwriterID", "IssueDate", "CancellationDate", "CancellationReason", "CreatedDate", "LastUpdatedDate") VALUES (
    'POL0000003', 'CUST203A203B', 'Auto', '2022-05-05', '2023-05-05', 'Active', 2161.21, 'USER0004', '2022-05-04', NULL, NULL, '2022-04-25 00:00:00', '2022-08-04 05:57:13'
);
INSERT INTO "Policies" ("PolicyID", "CustomerID", "PolicyType", "EffectiveDate", "ExpirationDate", "Status", "TotalPremium", "UnderwriterID", "IssueDate", "CancellationDate", "CancellationReason", "CreatedDate", "LastUpdatedDate") VALUES (
    'POL0000004', 'CUST7FE909BA', 'Workers Compensation', '2021-05-29', '2022-05-29', 'Active', 656.53, 'USER0002', '2021-05-24', NULL, NULL, '2021-05-23 00:00:00', '2024-02-08 06:17:50'
);
INSERT INTO "Policies" ("PolicyID", "CustomerID", "PolicyType", "EffectiveDate", "ExpirationDate", "Status", "TotalPremium", "UnderwriterID", "IssueDate", "CancellationDate", "CancellationReason", "CreatedDate", "LastUpdatedDate") VALUES (
    'POL0000005', 'CUSTD67B310F', 'Commercial Property', '2022-09-09', '2023-09-09', 'Active', 1032.74, 'USER0002', '2022-09-07', NULL, NULL, '2022-09-03 00:00:00', '2023-03-05 01:18:58'
);

-- Data for PolicyCoverages
INSERT INTO "PolicyCoverages" ("PolicyCoverageID", "PolicyID", "CoverageType", "CoverageLimit", "Deductible", "PremiumForCoverage", "EffectiveDate", "ExpirationDate", "CreatedDate", "LastUpdatedDate") VALUES (
    'PCOV00000001', 'POL0000001', 'Building', 289215.0, 1000, 654.42, '2022-09-28', '2023-09-28', '2022-09-20 00:00:00', '2022-11-27 04:52:17'
);
INSERT INTO "PolicyCoverages" ("PolicyCoverageID", "PolicyID", "CoverageType", "CoverageLimit", "Deductible", "PremiumForCoverage", "EffectiveDate", "ExpirationDate", "CreatedDate", "LastUpdatedDate") VALUES (
    'PCOV00000002', 'POL0000002', 'Liability', 108551.0, 500, 1533.04, '2022-04-09', '2023-04-09', '2022-04-01 00:00:00', '2023-03-12 02:34:45'
);
INSERT INTO "PolicyCoverages" ("PolicyCoverageID", "PolicyID", "CoverageType", "CoverageLimit", "Deductible", "PremiumForCoverage", "EffectiveDate", "ExpirationDate", "CreatedDate", "LastUpdatedDate") VALUES (
    'PCOV00000003', 'POL0000003', 'Collision', 153662.0, 1000, 1242.83, '2022-05-05', '2023-05-05', '2022-04-25 00:00:00', '2022-08-04 05:57:13'
);
INSERT INTO "PolicyCoverages" ("PolicyCoverageID", "PolicyID", "CoverageType", "CoverageLimit", "Deductible", "PremiumForCoverage", "EffectiveDate", "ExpirationDate", "CreatedDate", "LastUpdatedDate") VALUES (
    'PCOV00000004', 'POL0000003', 'Comprehensive', 71439.0, 1000, 885.02, '2022-05-05', '2023-05-05', '2022-04-25 00:00:00', '2022-08-04 05:57:13'
);
INSERT INTO "PolicyCoverages" ("PolicyCoverageID", "PolicyID", "CoverageType", "CoverageLimit", "Deductible", "PremiumForCoverage", "EffectiveDate", "ExpirationDate", "CreatedDate", "LastUpdatedDate") VALUES (
    'PCOV00000005', 'POL0000004', 'Lost Wages', 163269.0, 2500, 785.22, '2021-05-29', '2022-05-29', '2021-05-23 00:00:00', '2024-02-08 06:17:50'
);
INSERT INTO "PolicyCoverages" ("PolicyCoverageID", "PolicyID", "CoverageType", "CoverageLimit", "Deductible", "PremiumForCoverage", "EffectiveDate", "ExpirationDate", "CreatedDate", "LastUpdatedDate") VALUES (
    'PCOV00000006', 'POL0000005', 'Business Income', 107136.0, 1000, 1138.11, '2022-09-09', '2023-09-09', '2022-09-03 00:00:00', '2023-03-05 01:18:58'
);

-- Data for InsuredAssets
INSERT INTO "InsuredAssets" ("InsuredAssetID", "PolicyID", "AssetType", "Description", "VIN", "Make", "Model", "Year", "PropertyAddressLine1", "PropertyCity", "PropertyState", "PropertyZipCode", "InsuredValue", "CreatedDate", "LastUpdatedDate") VALUES (
    'ASST00000001', 'POL0000001', 'Property', 'Single Family Home at 7310 Oak Ave', NULL, NULL, NULL, NULL, '7310 Oak Ave', 'Phoenix', 'IL', '13715', 721766.0, '2022-09-20 00:00:00', '2022-11-27 04:52:17'
);
INSERT INTO "InsuredAssets" ("InsuredAssetID", "PolicyID", "AssetType", "Description", "VIN", "Make", "Model", "Year", "PropertyAddressLine1", "PropertyCity", "PropertyState", "PropertyZipCode", "InsuredValue", "CreatedDate", "LastUpdatedDate") VALUES (
    'ASST00000002', 'POL0000002', 'Vehicle', '2019 Toyota Camry', '9618DB2A5BFC48459', 'Toyota', 'Camry', 2019, NULL, NULL, NULL, NULL, 18412.0, '2022-04-01 00:00:00', '2023-03-12 02:34:45'
);
INSERT INTO "InsuredAssets" ("InsuredAssetID", "PolicyID", "AssetType", "Description", "VIN", "Make", "Model", "Year", "PropertyAddressLine1", "PropertyCity", "PropertyState", "PropertyZipCode", "InsuredValue", "CreatedDate", "LastUpdatedDate") VALUES (
    'ASST00000003', 'POL0000003', 'Vehicle', '2017 Ford F-150', '5E29EF8622A645829', 'Ford', 'F-150', 2017, NULL, NULL, NULL, NULL, 40161.0, '2022-04-25 00:00:00', '2022-08-04 05:57:13'
);
INSERT INTO "InsuredAssets" ("InsuredAssetID", "PolicyID", "AssetType", "Description", "VIN", "Make", "Model", "Year", "PropertyAddressLine1", "PropertyCity", "PropertyState", "PropertyZipCode", "InsuredValue", "CreatedDate", "LastUpdatedDate") VALUES (
    'ASST00000004', 'POL0000005', 'Property', 'Single Family Home at 6569 Maple Dr', NULL, NULL, NULL, NULL, '6569 Maple Dr', 'Los Angeles', 'TX', '46885', 316353.0, '2022-09-03 00:00:00', '2023-03-05 01:18:58'
);

-- Data for PolicyTransactions
INSERT INTO "PolicyTransactions" ("PolicyTransactionID", "PolicyID", "TransactionType", "TransactionDate", "EffectiveDate", "Description", "PremiumChangeAmount", "CreatedDate") VALUES (
    'PTX00000001', 'POL0000001', 'New Business', '2022-09-26', '2022-09-28', 'New Commercial Property policy issued.', 645.88, '2022-09-20 00:00:00'
);
INSERT INTO "PolicyTransactions" ("PolicyTransactionID", "PolicyID", "TransactionType", "TransactionDate", "EffectiveDate", "Description", "PremiumChangeAmount", "CreatedDate") VALUES (
    'PTX00000002', 'POL0000002', 'New Business', '2022-04-06', '2022-04-09', 'New Auto policy issued.', 1776.69, '2022-04-01 00:00:00'
);
INSERT INTO "PolicyTransactions" ("PolicyTransactionID", "PolicyID", "TransactionType", "TransactionDate", "EffectiveDate", "Description", "PremiumChangeAmount", "CreatedDate") VALUES (
    'PTX00000003', 'POL0000003', 'New Business', '2022-05-04', '2022-05-05', 'New Auto policy issued.', 2161.21, '2022-04-25 00:00:00'
);
INSERT INTO "PolicyTransactions" ("PolicyTransactionID", "PolicyID", "TransactionType", "TransactionDate", "EffectiveDate", "Description", "PremiumChangeAmount", "CreatedDate") VALUES (
    'PTX00000004', 'POL0000004', 'New Business', '2021-05-24', '2021-05-29', 'New Workers Compensation policy issued.', 656.53, '2021-05-23 00:00:00'
);
INSERT INTO "PolicyTransactions" ("PolicyTransactionID", "PolicyID", "TransactionType", "TransactionDate", "EffectiveDate", "Description", "PremiumChangeAmount", "CreatedDate") VALUES (
    'PTX00000005', 'POL0000005', 'New Business', '2022-09-07', '2022-09-09', 'New Commercial Property policy issued.', 1032.74, '2022-09-03 00:00:00'
);

-- Data for BillingSchedules
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000001', 'POL0000001', 1, '2022-09-28', 645.88, 645.88, '2022-09-27', 'Paid', '2022-09-20 00:00:00', '2023-09-03 03:27:57'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000002', 'POL0000002', 1, '2022-04-09', 888.35, 888.35, '2022-04-09', 'Paid', '2022-04-01 00:00:00', '2023-03-19 17:14:45'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000003', 'POL0000002', 2, '2022-10-08', 888.35, 888.35, '2022-10-08', 'Paid', '2022-04-01 00:00:00', '2024-01-06 18:38:11'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000004', 'POL0000003', 1, '2022-05-05', 1080.61, 1080.61, '2022-05-02', 'Paid', '2022-04-25 00:00:00', '2023-06-30 12:45:50'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000005', 'POL0000003', 2, '2022-11-03', 1080.61, NULL, NULL, 'Pending', '2022-04-25 00:00:00', '2023-04-26 11:56:41'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000006', 'POL0000004', 1, '2021-05-29', 328.26, NULL, NULL, 'Pending', '2021-05-23 00:00:00', '2023-05-01 02:04:41'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000007', 'POL0000004', 2, '2021-11-27', 328.26, NULL, NULL, 'Pending', '2021-05-23 00:00:00', '2022-08-31 04:25:11'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000008', 'POL0000005', 1, '2022-09-09', 516.37, NULL, NULL, 'Pending', '2022-09-03 00:00:00', '2022-10-13 09:53:32'
);
INSERT INTO "BillingSchedules" ("BillingScheduleID", "PolicyID", "InstallmentNumber", "DueDate", "AmountDue", "AmountPaid", "PaymentDate", "Status", "CreatedDate", "LastUpdatedDate") VALUES (
    'BILL00000009', 'POL0000005', 2, '2023-03-10', 516.37, NULL, NULL, 'Pending', '2022-09-03 00:00:00', '2023-08-02 00:56:51'
);

-- Data for Claims
INSERT INTO "Claims" ("ClaimID", "PolicyID", "InsuredAssetID", "DateOfLoss", "DateReported", "CauseOfLoss", "LossDescription", "Status", "AssignedAdjusterID", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLM00000001', 'POL0000004', NULL, '2021-06-26 15:36:54', '2021-06-29 15:36:54', 'Slip and Fall', 'Loss due to Slip and Fall. Further details pending.', 'Approved', 'USER0003', '2021-06-29 16:10:54', '2024-04-18 00:33:10'
);
INSERT INTO "Claims" ("ClaimID", "PolicyID", "InsuredAssetID", "DateOfLoss", "DateReported", "CauseOfLoss", "LossDescription", "Status", "AssignedAdjusterID", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLM00000002', 'POL0000005', 'ASST00000004', '2023-03-21 18:21:39', '2023-03-22 18:21:39', 'Water Damage', 'Loss due to Water Damage. Further details pending.', 'Open', 'USER0002', '2023-03-22 19:01:39', '2023-07-17 21:33:51'
);
INSERT INTO "Claims" ("ClaimID", "PolicyID", "InsuredAssetID", "DateOfLoss", "DateReported", "CauseOfLoss", "LossDescription", "Status", "AssignedAdjusterID", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLM00000003', 'POL0000003', 'ASST00000003', '2022-05-19 23:30:47', '2022-05-22 23:30:47', 'Theft', 'Loss due to Theft. Further details pending.', 'Pending Investigation', 'USER0005', '2022-05-22 23:52:47', '2022-09-08 05:33:53'
);
INSERT INTO "Claims" ("ClaimID", "PolicyID", "InsuredAssetID", "DateOfLoss", "DateReported", "CauseOfLoss", "LossDescription", "Status", "AssignedAdjusterID", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLM00000004', 'POL0000002', 'ASST00000002', '2022-07-15 09:33:25', '2022-07-16 09:33:25', 'Collision with another vehicle', 'Loss due to Collision with another vehicle. Further details pending.', 'Pending Investigation', 'USER0002', '2022-07-16 10:31:25', '2023-11-04 10:45:00'
);
INSERT INTO "Claims" ("ClaimID", "PolicyID", "InsuredAssetID", "DateOfLoss", "DateReported", "CauseOfLoss", "LossDescription", "Status", "AssignedAdjusterID", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLM00000005', 'POL0000001', 'ASST00000001', '2023-04-05 21:49:44', '2023-04-07 21:49:44', 'Fire', 'Loss due to Fire. Further details pending.', 'Denied', 'USER0003', '2023-04-07 22:35:44', '2023-07-05 18:15:26'
);

-- Data for Claimants
INSERT INTO "Claimants" ("ClaimantID", "ClaimID", "CustomerID", "ClaimantType", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLMT00000001', 'CLM00000001', 'CUST7FE909BA', 'Insured', '2021-06-29 16:10:54', '2021-06-29 16:10:54'
);
INSERT INTO "Claimants" ("ClaimantID", "ClaimID", "CustomerID", "ClaimantType", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLMT00000002', 'CLM00000002', 'CUSTD67B310F', 'Insured', '2023-03-22 19:01:39', '2023-03-22 19:01:39'
);
INSERT INTO "Claimants" ("ClaimantID", "ClaimID", "CustomerID", "ClaimantType", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLMT00000003', 'CLM00000003', 'CUST203A203B', 'Insured', '2022-05-22 23:52:47', '2022-05-22 23:52:47'
);
INSERT INTO "Claimants" ("ClaimantID", "ClaimID", "CustomerID", "ClaimantType", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLMT00000004', 'CLM00000004', 'CUST0019DF3D', 'Insured', '2022-07-16 10:31:25', '2022-07-16 10:31:25'
);
INSERT INTO "Claimants" ("ClaimantID", "ClaimID", "CustomerID", "ClaimantType", "CreatedDate", "LastUpdatedDate") VALUES (
    'CLMT00000005', 'CLM00000005', 'CUSTCDE9413C', 'Insured', '2023-04-07 22:35:44', '2023-04-07 22:35:44'
);

-- Data for ClaimCoverages
INSERT INTO "ClaimCoverages" ("ClaimCoverageID", "ClaimID", "PolicyCoverageID", "Status", "CreatedDate") VALUES (
    'CCOV00000001', 'CLM00000001', 'PCOV00000005', 'Active', '2021-06-29 16:10:54'
);
INSERT INTO "ClaimCoverages" ("ClaimCoverageID", "ClaimID", "PolicyCoverageID", "Status", "CreatedDate") VALUES (
    'CCOV00000002', 'CLM00000002', 'PCOV00000006', 'Active', '2023-03-22 19:01:39'
);
INSERT INTO "ClaimCoverages" ("ClaimCoverageID", "ClaimID", "PolicyCoverageID", "Status", "CreatedDate") VALUES (
    'CCOV00000003', 'CLM00000003', 'PCOV00000003', 'Active', '2022-05-22 23:52:47'
);
INSERT INTO "ClaimCoverages" ("ClaimCoverageID", "ClaimID", "PolicyCoverageID", "Status", "CreatedDate") VALUES (
    'CCOV00000004', 'CLM00000004', 'PCOV00000002', 'Active', '2022-07-16 10:31:25'
);
INSERT INTO "ClaimCoverages" ("ClaimCoverageID", "ClaimID", "PolicyCoverageID", "Status", "CreatedDate") VALUES (
    'CCOV00000005', 'CLM00000005', 'PCOV00000001', 'Active', '2023-04-07 22:35:44'
);

-- Data for ClaimReserves
INSERT INTO "ClaimReserves" ("ClaimReserveID", "ClaimID", "PolicyCoverageID", "ReserveType", "CurrentReserveAmount", "CreatedDate", "LastUpdatedDate") VALUES (
    'CRES00000001', 'CLM00000001', 'PCOV00000005', 'Initial', 1000.0, '2021-06-29 16:10:54', '2021-06-29 16:10:54'
);
INSERT INTO "ClaimReserves" ("ClaimReserveID", "ClaimID", "PolicyCoverageID", "ReserveType", "CurrentReserveAmount", "CreatedDate", "LastUpdatedDate") VALUES (
    'CRES00000002', 'CLM00000002', 'PCOV00000006', 'Initial', 5000.0, '2023-03-22 19:01:39', '2023-03-22 19:01:39'
);
INSERT INTO "ClaimReserves" ("ClaimReserveID", "ClaimID", "PolicyCoverageID", "ReserveType", "CurrentReserveAmount", "CreatedDate", "LastUpdatedDate") VALUES (
    'CRES00000003', 'CLM00000003', 'PCOV00000003', 'Initial', 2500.0, '2022-05-22 23:52:47', '2022-05-22 23:52:47'
);
INSERT INTO "ClaimReserves" ("ClaimReserveID", "ClaimID", "PolicyCoverageID", "ReserveType", "CurrentReserveAmount", "CreatedDate", "LastUpdatedDate") VALUES (
    'CRES00000004', 'CLM00000004', 'PCOV00000002', 'Initial', 7500.0, '2022-07-16 10:31:25', '2022-07-16 10:31:25'
);
INSERT INTO "ClaimReserves" ("ClaimReserveID", "ClaimID", "PolicyCoverageID", "ReserveType", "CurrentReserveAmount", "CreatedDate", "LastUpdatedDate") VALUES (
    'CRES00000005', 'CLM00000005', 'PCOV00000001', 'Initial', 0.0, '2023-04-07 22:35:44', '2023-04-07 22:35:44'
);

-- Data for ClaimPayments
INSERT INTO "ClaimPayments" ("ClaimPaymentID", "ClaimID", "PolicyCoverageID", "ClaimantID", "PaymentAmount", "PaymentDate", "CreatedDate") VALUES (
    'CPAY00000001', 'CLM00000001', 'PCOV00000005', 'CLMT00000001', 850.0, '2021-07-15', '2021-07-15'
);

-- Data for ClaimSubrogations

-- Data for ClaimNotes
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000001', 'CLM00000001', 'Initial assessment complete. Regarding claim CLM00000001.', 'USER0003', '2021-07-01 16:10:54'
);
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000002', 'CLM00000001', 'Payment processed. Regarding claim CLM00000001.', 'USER0003', '2021-07-04 16:10:54'
);
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000003', 'CLM00000002', 'Contacted claimant. Regarding claim CLM00000002.', 'USER0002', '2023-03-23 19:01:39'
);
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000004', 'CLM00000003', 'Photos received. Regarding claim CLM00000003.', 'USER0005', '2022-05-24 23:52:47'
);
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000005', 'CLM00000004', 'Estimate obtained. Regarding claim CLM00000004.', 'USER0002', '2022-07-17 10:31:25'
);
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000006', 'CLM00000004', 'Initial assessment complete. Regarding claim CLM00000004.', 'USER0002', '2022-07-19 10:31:25'
);
INSERT INTO "ClaimNotes" ("ClaimNoteID", "ClaimID", "NoteText", "CreatedByUserID", "CreatedDate") VALUES (
    'CNTE00000007', 'CLM00000005', 'Initial assessment complete. Regarding claim CLM00000005.', 'USER0003', '2023-04-08 22:35:44'
);


