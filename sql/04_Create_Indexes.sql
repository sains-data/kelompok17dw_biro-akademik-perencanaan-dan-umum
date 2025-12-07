USE DM_BiroPerencanaan_DW;
GO

-- FACT_ANGGARAN
-- Non-Clustered Indexes

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

CREATE NONCLUSTERED INDEX IX_Fact_Anggaran_Covering
ON dbo.Fact_Anggaran(waktu_key, unit_id)
INCLUDE (program_id, pagu, realisasi, selisih_pagu_realisasi);
GO

-- Columnstore Index (for large fact tables)
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

-- FACT_KINERJA 
-- Non-Clustered Indexes
CREATE NONCLUSTERED INDEX IX_Fact_Kinerja_Unit
ON dbo.Fact_Kinerja(unit_id)
INCLUDE (target, capaian_value, persentase_capaian);
GO

CREATE NONCLUSTERED INDEX IX_Fact_Kinerja_Indikator
ON dbo.Fact_Kinerja(indikator_id)
INCLUDE (target, capaian_value);
GO

CREATE NONCLUSTERED INDEX IX_Fact_Kinerja_Covering
ON dbo.Fact_Kinerja(waktu_key, unit_id)
INCLUDE (indikator_id, target, capaian_value);
GO

-- Columnstore Index
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
