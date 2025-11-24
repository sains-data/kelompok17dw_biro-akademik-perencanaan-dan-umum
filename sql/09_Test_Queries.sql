USE DM_BiroPerencanaan_DW;
GO

-------------------------------------------------------
-- 1. CEK JUMLAH RECORD DI FACT
-------------------------------------------------------
PRINT '--- FACT CHECK ---';
SELECT COUNT(*) AS TotalFactRows 
FROM dbo.Fact_Anggaran_Partitioned;

SELECT TOP 10 * 
FROM dbo.Fact_Anggaran_Partitioned;

-------------------------------------------------------
-- 2. CEK DIMENSI, TERUTAMA DIM_WAKTU
-------------------------------------------------------
PRINT '--- DIMENSI CHECK ---';
SELECT 'Dim_Unit' AS Dimensi, COUNT(*) AS RowsCount FROM dbo.Dim_Unit
UNION ALL
SELECT 'Dim_Program', COUNT(*) FROM dbo.Dim_Program
UNION ALL
SELECT 'Dim_Kegiatan', COUNT(*) FROM dbo.Dim_Kegiatan
UNION ALL
SELECT 'Dim_SumberDana', COUNT(*) FROM dbo.Dim_SumberDana
UNION ALL
SELECT 'Dim_Indikator', COUNT(*) FROM dbo.Dim_Indikator
UNION ALL
SELECT 'Dim_Waktu', COUNT(*) FROM dbo.Dim_Waktu;

-------------------------------------------------------
-- 3. LIHAT TAHUN APA SAJA DI DIM_WAKTU
-------------------------------------------------------
PRINT '--- TAHUN DI DIM_WAKTU ---';
SELECT DISTINCT tahun 
FROM dbo.Dim_Waktu
ORDER BY tahun;

-------------------------------------------------------
-- 4. CEK STAGING TABLES (HARUS ADA ISINYA)
-------------------------------------------------------
PRINT '--- CEK STAGING TABLES ---';
SELECT 'stg.Unit', COUNT(*) FROM stg.Unit
UNION ALL
SELECT 'stg.Program', COUNT(*) FROM stg.Program
UNION ALL
SELECT 'stg.Kegiatan', COUNT(*) FROM stg.Kegiatan
UNION ALL
SELECT 'stg.Anggaran_RKAT', COUNT(*) FROM stg.Anggaran_RKAT
UNION ALL
SELECT 'stg.Realisasi', COUNT(*) FROM stg.Realisasi
UNION ALL
SELECT 'stg.Capaian', COUNT(*) FROM stg.Capaian;

-------------------------------------------------------
-- 5. CEK SAMPEL DATA KALAU DIPERLUKAN
-------------------------------------------------------
PRINT '--- TOP ROWS STAGING ---';
SELECT TOP 5 * FROM stg.Anggaran_RKAT;
SELECT TOP 5 * FROM stg.Realisasi;
SELECT TOP 5 * FROM stg.Unit;
SELECT TOP 5 * FROM stg.Kegiatan;
SELECT TOP 5 * FROM stg.Program;
