USE DM_BiroPerencanaan_DW;
GO

-- 4.5.2 Step 2: Indexing Strategy

-- =========================================================
-- A. TABEL: FACT_ANGGARAN
-- =========================================================

-- 1. Clustered Index on Fact Table
-- Karena tabel sudah punya Primary Key (PK), PK tersebut sudah menjadi Clustered Index. 

-- 2. Non-Clustered Indexes
-- Index untuk foreign keys (join optimization)

CREATE NONCLUSTERED INDEX IX_Fact_Anggaran_Unit
ON dbo.Fact_Anggaran(unit_id)
INCLUDE (pagu, realisasi, persentase_serapan);
GO

CREATE NONCLUSTERED INDEX IX_Fact_Anggaran_Program
ON dbo.Fact_Anggaran(program_id)
INCLUDE (pagu, realisasi);
GO

CREATE NONCLUSTERED INDEX IX_Fact_Anggaran_Kegiatan
ON dbo.Fact_Anggaran(kegiatan_id, waktu_key)
INCLUDE (unit_id, pagu);
GO

-- Covering index untuk common queries
CREATE NONCLUSTERED INDEX IX_Fact_Anggaran_Covering
ON dbo.Fact_Anggaran(waktu_key, unit_id)
INCLUDE (program_id, pagu, realisasi, selisih_pagu_realisasi);
GO

-- 3. Columnstore Index (for large fact tables)
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCIX_Fact_Anggaran
ON dbo.Fact_Anggaran
(
    waktu_key, 
    unit_id, 
    program_id, 
    kegiatan_id, 
    sumber_dana_key,
    pagu, 
    realisasi, 
    persentase_serapan, 
    selisih_pagu_realisasi
);
GO


-- =========================================================
-- B. TABEL: FACT_KINERJA 
-- =========================================================

-- 1. Clustered Index on Fact Table
-- Karena tabel sudah punya Primary Key (PK), PK tersebut sudah menjadi Clustered Index. 

-- 2. Non-Clustered Indexes
CREATE NONCLUSTERED INDEX IX_Fact_Kinerja_Unit
ON dbo.Fact_Kinerja(unit_id)
INCLUDE (target, capaian_value, persentase_capaian);
GO

CREATE NONCLUSTERED INDEX IX_Fact_Kinerja_Indikator
ON dbo.Fact_Kinerja(indikator_id)
INCLUDE (target, capaian_value);
GO

-- Covering index
CREATE NONCLUSTERED INDEX IX_Fact_Kinerja_Covering
ON dbo.Fact_Kinerja(waktu_key, unit_id)
INCLUDE (indikator_id, target, capaian_value);
GO

-- 3. Columnstore Index
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCIX_Fact_Kinerja
ON dbo.Fact_Kinerja
(
    waktu_key, 
    unit_id, 
    indikator_id,
    target, 
    capaian_value, 
    persentase_capaian
);
GO