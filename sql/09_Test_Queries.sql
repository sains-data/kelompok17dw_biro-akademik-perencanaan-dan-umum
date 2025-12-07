USE DM_BiroPerencanaan_DW;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- Simple Aggregation (Total Anggaran per Program)
SELECT 
    p.nama_program,
    COUNT(DISTINCT f.unit_id) AS JumlahUnit,
    SUM(f.pagu) AS TotalPagu,
    SUM(f.realisasi) AS TotalRealisasi,
    AVG(f.persentase_serapan) AS RataRataSerapan
FROM dbo.Fact_Anggaran_Partitioned f
INNER JOIN dbo.Dim_Program p ON f.program_id = p.program_id
INNER JOIN dbo.Dim_Waktu w ON f.waktu_key = w.waktu_key
WHERE w.tahun = 2024 -- Filter Tahun Tertentu
GROUP BY p.nama_program
ORDER BY TotalPagu DESC;
GO

-- Trend Analysis (Tren Realisasi Bulanan)
SELECT 
    w.tahun,
    w.bulan,
    COUNT(f.fact_anggaran_id) AS JumlahTransaksi,
    SUM(f.realisasi) AS TotalRealisasi
FROM dbo.Fact_Anggaran_Partitioned f
INNER JOIN dbo.Dim_Waktu w ON f.waktu_key = w.waktu_key
GROUP BY w.tahun, w.bulan
ORDER BY w.tahun, w.bulan;
GO

-- Drill-down Analysis
DECLARE @SampleUnitID INT = (SELECT TOP 1 unit_id FROM dbo.Dim_Unit);

SELECT 
    u.nama_unit,
    k.nama_kegiatan,
    s.sumber_dana,
    SUM(f.pagu) AS Pagu,
    SUM(f.realisasi) AS Realisasi
FROM dbo.Fact_Anggaran_Partitioned f
INNER JOIN dbo.Dim_Unit u ON f.unit_id = u.unit_id
INNER JOIN dbo.Dim_Kegiatan k ON f.kegiatan_id = k.kegiatan_id
INNER JOIN dbo.Dim_SumberDana s ON f.sumber_dana_key = s.sumber_dana_key
WHERE f.unit_id = @SampleUnitID
GROUP BY u.nama_unit, k.nama_kegiatan, s.sumber_dana;
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
