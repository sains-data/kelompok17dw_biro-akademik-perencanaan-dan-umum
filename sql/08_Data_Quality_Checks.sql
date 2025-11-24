USE DM_BiroPerencanaan_DW;
GO

-- =============================================
-- Check 1: Completeness - NULL values
-- =============================================
SELECT 
    'Dim_Unit' AS TableName,
    SUM(CASE WHEN nama_unit IS NULL THEN 1 ELSE 0 END) AS NullNamaUnit,
    SUM(CASE WHEN fakultas IS NULL THEN 1 ELSE 0 END) AS NullFakultas
FROM dbo.Dim_Unit;
GO

-- =============================================
-- Check 2: Consistency - Referential Integrity
-- =============================================
SELECT 
    COUNT(*) AS JumlahDataUnknown,
    'Unit ID = -1 (Unknown)' AS Keterangan
FROM dbo.Fact_Anggaran_Partitioned
WHERE unit_id = -1;
GO

-- =============================================
-- Check 3: Accuracy - Valid ranges
-- =============================================
SELECT 
    COUNT(*) AS AnggaranMinus,
    'Pagu atau Realisasi < 0' AS Keterangan
FROM dbo.Fact_Anggaran_Partitioned
WHERE pagu < 0 OR realisasi < 0;
GO

-- =============================================
-- Check 4: Duplicates
-- =============================================
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

-- =============================================
-- Check 5: Record Counts Reconciliation
-- =============================================
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
