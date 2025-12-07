USE DM_BiroPerencanaan_DW;
GO

-- Completeness 
SELECT 
    'Dim_Unit' AS TableName,
    SUM(CASE WHEN nama_unit IS NULL THEN 1 ELSE 0 END) AS NullNamaUnit,
    SUM(CASE WHEN fakultas IS NULL THEN 1 ELSE 0 END) AS NullFakultas
FROM dbo.Dim_Unit;
GO

-- Consistency 
SELECT 
    COUNT(*) AS JumlahDataUnknown,
    'Unit ID = -1 (Unknown)' AS Keterangan
FROM dbo.Fact_Anggaran_Partitioned
WHERE unit_id = -1;
GO

-- Accuracy 
SELECT 
    COUNT(*) AS AnggaranMinus,
    'Pagu atau Realisasi < 0' AS Keterangan
FROM dbo.Fact_Anggaran_Partitioned
WHERE pagu < 0 OR realisasi < 0;
GO

-- Duplicates
SELECT 
    'Dim_Unit' AS TableName,
    COUNT(*) AS JumlahUnitGanda,
    CASE 
        WHEN COUNT(*) = 0 THEN 'AMAN (Tidak ada duplikat)' 
        ELSE 'WARNING (Ada data ganda)' 
    END AS Status
FROM (
    SELECT nama_unit
    FROM dbo.Dim_Unit
    GROUP BY nama_unit
    HAVING COUNT(*) > 1
) AS CekDuplikat;
GO

-- Record Counts Reconciliation
-- Rekonsiliasi Anggaran RKAT
SELECT 
    'Source: Stg_Anggaran_RKAT' AS DataSource, 
    COUNT(*) AS RecordCount 
FROM stg.Anggaran_RKAT
UNION ALL
SELECT 
    'Target: Fact (Sistem RKAT)', 
    COUNT(*) 
FROM dbo.Fact_Anggaran_Partitioned 
WHERE SourceSystem = 'Sistem RKAT';

-- Rekonsiliasi Realisasi Belanja
SELECT 
    'Source: Stg_Realisasi' AS DataSource, 
    COUNT(*) AS RecordCount 
FROM stg.Realisasi
UNION ALL
SELECT 
    'Target: Fact (Sistem Realisasi)', 
    COUNT(*) 
FROM dbo.Fact_Anggaran_Partitioned 
WHERE SourceSystem = 'Sistem Realisasi';
GO

USE DM_BiroPerencanaan_DW;
GO

-- Tabel Audit 
IF OBJECT_ID('dbo.DQ_Audit_Log', 'U') IS NOT NULL DROP TABLE dbo.DQ_Audit_Log;

CREATE TABLE dbo.DQ_Audit_Log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CheckName VARCHAR(100),
    TableName VARCHAR(100),
    Status VARCHAR(20), -- 'PASS' atau 'FAIL'
    MetricValue INT,    -- Jumlah error yang ditemukan
    CheckDate DATETIME DEFAULT GETDATE()
);
GO

-- Stored Procedure
CREATE OR ALTER PROCEDURE dbo.usp_Generate_DQ_Report
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ErrorCount INT;

    -- Cek Completeness 
    SELECT @ErrorCount = COUNT(*) FROM dbo.Dim_Unit WHERE nama_unit IS NULL;
    INSERT INTO dbo.DQ_Audit_Log (CheckName, TableName, Status, MetricValue)
    VALUES ('Completeness - Null Name', 'Dim_Unit', 
            CASE WHEN @ErrorCount = 0 THEN 'PASS' ELSE 'FAIL' END, @ErrorCount);

    -- Cek Accuracy 
    SELECT @ErrorCount = COUNT(*) FROM dbo.Fact_Anggaran_Partitioned WHERE pagu < 0 OR realisasi < 0;
    INSERT INTO dbo.DQ_Audit_Log (CheckName, TableName, Status, MetricValue)
    VALUES ('Accuracy - Negative Value', 'Fact_Anggaran', 
            CASE WHEN @ErrorCount = 0 THEN 'PASS' ELSE 'FAIL' END, @ErrorCount);

    -- Cek Consistency 
    SELECT @ErrorCount = COUNT(*) FROM dbo.Fact_Anggaran_Partitioned WHERE unit_id = -1;
    INSERT INTO dbo.DQ_Audit_Log (CheckName, TableName, Status, MetricValue)
    VALUES ('Consistency - Unknown Unit', 'Fact_Anggaran', 
            CASE WHEN @ErrorCount = 0 THEN 'PASS' ELSE 'WARNING' END, @ErrorCount);

    -- Cek Uniqueness 
    SELECT @ErrorCount = COUNT(*) FROM (SELECT nama_unit FROM dbo.Dim_Unit GROUP BY nama_unit HAVING COUNT(*) > 1) as sub;
    INSERT INTO dbo.DQ_Audit_Log (CheckName, TableName, Status, MetricValue)
    VALUES ('Uniqueness - Duplicate Unit', 'Dim_Unit', 
            CASE WHEN @ErrorCount = 0 THEN 'PASS' ELSE 'FAIL' END, @ErrorCount);

END;
GO


EXEC dbo.usp_Generate_DQ_Report;
SELECT * FROM dbo.DQ_Audit_Log;
GO
