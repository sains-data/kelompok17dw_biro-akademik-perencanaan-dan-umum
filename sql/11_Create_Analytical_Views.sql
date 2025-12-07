USE DM_BiroPerencanaan_DW;
GO

-- VIEW 1: KPI KEUANGAN 
CREATE OR ALTER VIEW dbo.vw_Dashboard_Keuangan AS
SELECT 
    w.tahun AS Tahun,
    w.bulan AS Bulan,
    w.semester AS Semester,
    u.nama_unit AS UnitKerja,
    u.fakultas AS Fakultas,
    p.nama_program AS Program,
    k.nama_kegiatan AS Kegiatan,
    sd.sumber_dana AS SumberDana,
    
    -- Metrik Utama (Duit)
    SUM(f.pagu) AS TotalPagu,
    SUM(f.realisasi) AS TotalRealisasi,
    (SUM(f.pagu) - SUM(f.realisasi)) AS SisaAnggaran,
    
    CAST(
        CASE WHEN SUM(f.pagu) = 0 THEN 0 
             ELSE (SUM(f.realisasi) / SUM(f.pagu)) * 100 
        END AS DECIMAL(5,2)
    ) AS PersenSerapan

FROM dbo.Fact_Anggaran_Partitioned f
JOIN dbo.Dim_Waktu w ON f.waktu_key = w.waktu_key
JOIN dbo.Dim_Unit u ON f.unit_id = u.unit_id
JOIN dbo.Dim_Program p ON f.program_id = p.program_id
JOIN dbo.Dim_Kegiatan k ON f.kegiatan_id = k.kegiatan_id
JOIN dbo.Dim_SumberDana sd ON f.sumber_dana_key = sd.sumber_dana_key
GROUP BY w.tahun, w.bulan, w.semester, u.nama_unit, u.fakultas, p.nama_program, k.nama_kegiatan, sd.sumber_dana;
GO

-- VIEW 2:  KPI KINERJA 
CREATE OR ALTER VIEW dbo.vw_Dashboard_Kinerja AS
SELECT 
    w.tahun AS Tahun,
    u.nama_unit AS UnitKerja,
    i.nama_indikator AS Indikator,
    i.satuan AS Satuan,
    
    SUM(f.target) AS Target,
    SUM(f.capaian_value) AS Capaian,
    
    CAST(
        CASE WHEN SUM(f.target) = 0 THEN 0 
             ELSE (SUM(f.capaian_value) / SUM(f.target)) * 100 
        END AS DECIMAL(5,2)
    ) AS PersenCapaian,
    
    CASE 
        WHEN f.capaian_value >= 100 THEN 'Tercapai'
        WHEN f.capaian_value >= 80 THEN 'Hampir Tercapai'
        ELSE 'Belum Tercapai'
    END AS Status

FROM dbo.Fact_Kinerja f
JOIN dbo.Dim_Waktu w ON f.waktu_key = w.waktu_key
JOIN dbo.Dim_Unit u ON f.unit_id = u.unit_id
JOIN dbo.Dim_Indikator i ON f.indikator_id = i.indikator_id
GROUP BY w.tahun, u.nama_unit, i.nama_indikator, i.satuan;
GO

-- VIEW 3: KPI DATA QUALITY 
CREATE OR ALTER VIEW dbo.vw_Dashboard_DataQuality AS
SELECT 'Kelengkapan' AS Kategori, 'Dim_Unit' AS Tabel, 'Nama Unit Kosong' AS Isu, COUNT(*) AS Error_Count FROM dbo.Dim_Unit WHERE nama_unit IS NULL
UNION ALL
SELECT 'Akurasi', 'Fact_Anggaran', 'Nilai Minus', COUNT(*) FROM dbo.Fact_Anggaran_Partitioned WHERE pagu < 0 OR realisasi < 0
UNION ALL
SELECT 'Konsistensi', 'Fact_Anggaran', 'Unit ID Unknown', COUNT(*) FROM dbo.Fact_Anggaran_Partitioned WHERE unit_id = -1;
GO