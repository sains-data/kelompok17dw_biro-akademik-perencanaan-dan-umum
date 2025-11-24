USE DM_BiroPerencanaan_DW;
GO

-- Create Partition Function
CREATE PARTITION FUNCTION PF_TahunAnggaran (INT)
AS RANGE RIGHT FOR VALUES
(
    20210101, 
    20220101, 
    20230101, 
    20240101, 
    20250101  
);
GO

-- Create Partition Scheme
CREATE PARTITION SCHEME PS_TahunAnggaran
AS PARTITION PF_TahunAnggaran
ALL TO ([PRIMARY]);
GO

-- Create Partitioned Fact Table
CREATE TABLE dbo.Fact_Anggaran_Partitioned (
    fact_anggaran_id BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Foreign Keys
    waktu_key INT NOT NULL,
    unit_id INT NOT NULL,
    program_id INT NOT NULL,
    kegiatan_id INT NOT NULL,
    sumber_dana_key INT NOT NULL,
    
    -- Degenerate Dimensions
    revisi_ke INT DEFAULT 0,
    
    -- Measures
    pagu DECIMAL(18,2) DEFAULT 0 NOT NULL,
    realisasi DECIMAL(18,2) DEFAULT 0 NOT NULL,
    persentase_serapan DECIMAL(5,2) DEFAULT 0,
    selisih_pagu_realisasi DECIMAL(18,2) DEFAULT 0,
    
    -- Metadata
    SourceSystem VARCHAR(50) DEFAULT 'Sistem Anggaran' NOT NULL,
    LoadDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_Fact_Anggaran_Partitioned 
        PRIMARY KEY (fact_anggaran_id, waktu_key),

    CONSTRAINT FK_Fact_Anggaran_Part_Waktu 
        FOREIGN KEY (waktu_key) REFERENCES dbo.Dim_Waktu(waktu_key),
    CONSTRAINT FK_Fact_Anggaran_Part_Unit 
        FOREIGN KEY (unit_id) REFERENCES dbo.Dim_Unit(unit_id)

) ON PS_TahunAnggaran(waktu_key); 
GO