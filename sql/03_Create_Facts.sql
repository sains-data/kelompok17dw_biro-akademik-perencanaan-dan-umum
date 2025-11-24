USE DM_BiroPerencanaan_DW;
GO

-- =============================================
-- 3. CREATE FACT TABLES
-- =============================================

-- Fact Table: Fact_Anggaran
CREATE TABLE dbo.Fact_Anggaran (
    fact_anggaran_id BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    
    -- Foreign Keys to Dimensions
    waktu_key INT NOT NULL,
    unit_id INT NOT NULL,
    program_id INT NOT NULL,
    kegiatan_id INT NOT NULL,
    sumber_dana_key INT NOT NULL,
    
    -- Degenerate Dimensions 
    revisi_ke INT DEFAULT 0, 
    
    -- Measures (Metrik Numerik)
    pagu DECIMAL(18,2) DEFAULT 0 NOT NULL,
    realisasi DECIMAL(18,2) DEFAULT 0 NOT NULL,
    persentase_serapan DECIMAL(5,2) DEFAULT 0,
    selisih_pagu_realisasi DECIMAL(18,2) DEFAULT 0,
    
    -- Metadata (Kolom Audit sesuai contoh dosen)
    SourceSystem VARCHAR(50) DEFAULT 'Sistem Anggaran' NOT NULL,
    LoadDate DATETIME DEFAULT GETDATE(),
    
    -- Foreign Key Constraints 
    CONSTRAINT FK_Fact_Anggaran_Waktu 
        FOREIGN KEY (waktu_key) REFERENCES dbo.Dim_Waktu(waktu_key),
    CONSTRAINT FK_Fact_Anggaran_Unit 
        FOREIGN KEY (unit_id) REFERENCES dbo.Dim_Unit(unit_id),
    CONSTRAINT FK_Fact_Anggaran_Program 
        FOREIGN KEY (program_id) REFERENCES dbo.Dim_Program(program_id),
    CONSTRAINT FK_Fact_Anggaran_Kegiatan 
        FOREIGN KEY (kegiatan_id) REFERENCES dbo.Dim_Kegiatan(kegiatan_id),
    CONSTRAINT FK_Fact_Anggaran_SumberDana 
        FOREIGN KEY (sumber_dana_key) REFERENCES dbo.Dim_SumberDana(sumber_dana_key)
);
GO

-- Fact Table: Fact_Kinerja
CREATE TABLE dbo.Fact_Kinerja (
    fact_kinerja_id BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    
    -- Foreign Keys to Dimensions
    waktu_key INT NOT NULL,
    unit_id INT NOT NULL,
    indikator_id INT NOT NULL,
    
    -- Measures
    target DECIMAL(18,2) DEFAULT 0 NOT NULL,
    capaian_value DECIMAL(18,2) DEFAULT 0 NOT NULL,
    persentase_capaian DECIMAL(5,2) DEFAULT 0,
    
    -- Metadata
    SourceSystem VARCHAR(100) NULL, -- Asal data (Manual/System)
    LoadDate DATETIME DEFAULT GETDATE(),
    
    -- Foreign Key Constraints
    CONSTRAINT FK_Fact_Kinerja_Waktu 
        FOREIGN KEY (waktu_key) REFERENCES dbo.Dim_Waktu(waktu_key),
    CONSTRAINT FK_Fact_Kinerja_Unit 
        FOREIGN KEY (unit_id) REFERENCES dbo.Dim_Unit(unit_id),
    CONSTRAINT FK_Fact_Kinerja_Indikator 
        FOREIGN KEY (indikator_id) REFERENCES dbo.Dim_Indikator(indikator_id)
);
GO