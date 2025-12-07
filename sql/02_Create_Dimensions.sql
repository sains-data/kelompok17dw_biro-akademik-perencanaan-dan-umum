USE DM_BiroPerencanaan_DW;
GO

-- CREATE DIMENSION TABLES
-- Dimensi Waktu
CREATE TABLE dbo.Dim_Waktu (
    waktu_key INT PRIMARY KEY,          
    tanggal DATE NOT NULL,
    tahun INT NOT NULL,
    bulan VARCHAR(20) NOT NULL,         
    semester VARCHAR(10) NOT NULL       
);
GO
-- Dimensi Unit
CREATE TABLE dbo.Dim_Unit (
    unit_id INT IDENTITY(1,1) PRIMARY KEY,
    nama_unit VARCHAR(255) NOT NULL,
    fakultas VARCHAR(150),
    tipe_unit VARCHAR(50)
);
GO
-- Dimensi Program
CREATE TABLE dbo.Dim_Program (
    program_id INT IDENTITY(1,1) PRIMARY KEY,
    nama_program VARCHAR(255) NOT NULL,
    tahun_program VARCHAR(20),
    target_program VARCHAR(255)
);
GO
-- Dimensi Kegiatan
CREATE TABLE dbo.Dim_Kegiatan (
    kegiatan_id INT IDENTITY(1,1) PRIMARY KEY,
    nama_kegiatan VARCHAR(255) NOT NULL,
    indikator_kinerja VARCHAR(MAX),
    target_kegiatan VARCHAR(255)
);
GO
-- Dimensi Sumber Dana
CREATE TABLE dbo.Dim_SumberDana (
    sumber_dana_key INT IDENTITY(1,1) PRIMARY KEY,
    sumber_dana VARCHAR(100) NOT NULL
);
GO
-- Dimensi Indikator
CREATE TABLE dbo.Dim_Indikator (
    indikator_id INT IDENTITY(1,1) PRIMARY KEY,
    nama_indikator VARCHAR(255) NOT NULL,
    satuan VARCHAR(50),
    jenis VARCHAR(50),
    target_tahun DECIMAL(18,2)
);
GO
