USE DM_BiroPerencanaan_DW;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'stg')
BEGIN
    EXEC('CREATE SCHEMA stg')
END
GO

-- ====================================================
-- CREATE STAGING TABLES 
-- ====================================================

-- 2.1 Staging Unit (Source: units.csv)
CREATE TABLE stg.Unit (
    unit_pk VARCHAR(50),
    unit_id VARCHAR(50),
    unit_name VARCHAR(255),
    fakultas VARCHAR(255),
    tipe_unit VARCHAR(100),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

-- 2.2 Staging Program (Source: programs.csv)
CREATE TABLE stg.Program (
    program_pk VARCHAR(50),
    program_id VARCHAR(50),
    unit_pk VARCHAR(50),
    program_name VARCHAR(255),
    tahun VARCHAR(10),
    target_program VARCHAR(MAX),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

-- 2.3 Staging Kegiatan (Source: kegiatan.csv)
CREATE TABLE stg.Kegiatan (
    kegiatan_pk VARCHAR(50),
    program_pk VARCHAR(50),
    kegiatan_name VARCHAR(255),
    indikator_kinerja VARCHAR(MAX),
    target_kegiatan VARCHAR(255),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

-- 2.4 Staging Anggaran RKAT (Source: anggaran_rkat.csv)
CREATE TABLE stg.Anggaran_RKAT (
    anggaran_id VARCHAR(50),
    unit_pk VARCHAR(50),
    kegiatan_pk VARCHAR(50),
    tahun VARCHAR(10),
    pagu VARCHAR(50),
    revisi_ke VARCHAR(10),
    tanggal_revisi VARCHAR(20),
    akun VARCHAR(50),
    periode VARCHAR(50),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

-- 2.5 Staging Realisasi (Source: realisasi.csv)
CREATE TABLE stg.Realisasi (
    realisasi_id VARCHAR(50),
    anggaran_id VARCHAR(50),
    tanggal VARCHAR(20),
    jumlah_realisasi VARCHAR(50),
    sumber_dana VARCHAR(100),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

-- 2.6 Staging Capaian (Source: capaian.csv)
CREATE TABLE stg.Capaian (
    capaian_id VARCHAR(50),
    indikator_id VARCHAR(50),
    periode VARCHAR(20),
    capaian_value VARCHAR(50),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

-- 2.7 Staging Anggaran Flat (Source: anggaran_flat_510.csv)
CREATE TABLE stg.Anggaran_Flat (
    id VARCHAR(50),
    unit_id VARCHAR(50),
    program_id VARCHAR(50),
    kegiatan VARCHAR(255),
    akun VARCHAR(50),
    pagu VARCHAR(50),
    realisasi VARCHAR(50),
    periode VARCHAR(50),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO
