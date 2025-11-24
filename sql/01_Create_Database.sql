CREATE DATABASE DM_BiroPerencanaan_DW
ON PRIMARY
(
    NAME = N'DM_BiroPerencanaan_DW_Data',
    FILENAME = N'C:\datadw\datadw.mdf',
    SIZE = 1GB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 256MB
)
LOG ON
(
    NAME = N'DM_BiroPerencanaan_DW_Log',
    FILENAME = N'C:\datadw\datadw.ldf',
    SIZE = 256MB,
    MAXSIZE = 2GB,
    FILEGROWTH = 64MB
);
GO

USE DM_BiroPerencanaan_DW;
GO
