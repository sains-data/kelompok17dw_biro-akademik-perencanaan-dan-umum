USE DM_BiroPerencanaan_DW;
GO

-- ROLES
IF DATABASE_PRINCIPAL_ID('db_executive') IS NULL CREATE ROLE db_executive;
IF DATABASE_PRINCIPAL_ID('db_analyst') IS NULL CREATE ROLE db_analyst;
IF DATABASE_PRINCIPAL_ID('db_viewer') IS NULL CREATE ROLE db_viewer;
IF DATABASE_PRINCIPAL_ID('db_etl_operator') IS NULL CREATE ROLE db_etl_operator;
GO

-- GRANT PERMISSIONS 
GRANT SELECT ON SCHEMA::dbo TO db_executive;
GRANT EXECUTE ON dbo.usp_Master_ETL TO db_executive;

GRANT SELECT ON SCHEMA::dbo TO db_analyst;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::stg TO db_analyst;

-- Izin Akses Dashboard
GRANT SELECT ON dbo.vw_Dashboard_Keuangan TO db_viewer;
GRANT SELECT ON dbo.vw_Dashboard_Kinerja TO db_viewer;
GRANT SELECT ON dbo.vw_Dashboard_DataQuality TO db_viewer;
GRANT SELECT ON dbo.Dim_Waktu TO db_viewer;

GRANT EXECUTE ON SCHEMA::dbo TO db_etl_operator;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::stg TO db_etl_operator;
GRANT INSERT, UPDATE, DELETE ON SCHEMA::dbo TO db_etl_operator;
GO

-- USERS & LOGINS
USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'user_bos') CREATE LOGIN user_bos WITH PASSWORD = 'BiroAdmin@123';
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'user_analis') CREATE LOGIN user_analis WITH PASSWORD = 'BiroAdmin@123';
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'user_viewer') CREATE LOGIN user_viewer WITH PASSWORD = 'BiroAdmin@123';
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'user_etl') CREATE LOGIN user_etl WITH PASSWORD = 'BiroAdmin@123';
GO

USE DM_BiroPerencanaan_DW;
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'user_bos') CREATE USER user_bos FOR LOGIN user_bos;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'user_analis') CREATE USER user_analis FOR LOGIN user_analis;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'user_viewer') CREATE USER user_viewer FOR LOGIN user_viewer;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'user_etl') CREATE USER user_etl FOR LOGIN user_etl;

ALTER ROLE db_executive ADD MEMBER user_bos;
ALTER ROLE db_analyst ADD MEMBER user_analis;
ALTER ROLE db_viewer ADD MEMBER user_viewer;
ALTER ROLE db_etl_operator ADD MEMBER user_etl;
GO

-- AUDIT TRAIL
IF OBJECT_ID('dbo.Security_Audit_Log', 'U') IS NULL 
CREATE TABLE dbo.Security_Audit_Log (
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY, WaktuKejadian DATETIME DEFAULT GETDATE(),
    UserPelaku NVARCHAR(100) DEFAULT SUSER_NAME(), Aksi NVARCHAR(50), NamaTabel NVARCHAR(100), JumlahBaris INT
);
GO

CREATE OR ALTER TRIGGER trg_Audit_Fact_Anggaran
ON dbo.Fact_Anggaran_Partitioned
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Aksi NVARCHAR(50);
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) SET @Aksi = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted) SET @Aksi = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted) SET @Aksi = 'DELETE';
    ELSE RETURN;
    INSERT INTO dbo.Security_Audit_Log (Aksi, NamaTabel, JumlahBaris) VALUES (@Aksi, 'Fact_Anggaran_Partitioned', @@ROWCOUNT);
END;
GO