USE DM_BiroPerencanaan_DW;
GO

-- LOAD DIMENSIONS
CREATE OR ALTER PROCEDURE dbo.usp_Load_Dimensions
AS
BEGIN
    SET NOCOUNT ON;

    -- Load Dim_Unit
    INSERT INTO dbo.Dim_Unit (nama_unit, fakultas, tipe_unit)
    SELECT DISTINCT 
        UPPER(TRIM(unit_name)), 
        UPPER(TRIM(fakultas)), 
        UPPER(TRIM(tipe_unit))
    FROM stg.Unit s
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Dim_Unit d 
        WHERE d.nama_unit = UPPER(TRIM(s.unit_name))
    );

    -- Load Dim_Program
    INSERT INTO dbo.Dim_Program (nama_program, tahun_program, target_program)
    SELECT DISTINCT 
        program_name, tahun, target_program
    FROM stg.Program s
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Dim_Program d 
        WHERE d.nama_program = s.program_name
    );

    -- Load Dim_Kegiatan
    INSERT INTO dbo.Dim_Kegiatan (nama_kegiatan, indikator_kinerja, target_kegiatan)
    SELECT DISTINCT 
        kegiatan_name, indikator_kinerja, target_kegiatan
    FROM stg.Kegiatan s
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Dim_Kegiatan d 
        WHERE d.nama_kegiatan = s.kegiatan_name
    );

    -- Load Dim_SumberDana & Indikator
    IF NOT EXISTS (SELECT 1 FROM dbo.Dim_SumberDana WHERE sumber_dana = 'Tidak Diketahui')
        INSERT INTO dbo.Dim_SumberDana VALUES ('Tidak Diketahui');

    INSERT INTO dbo.Dim_SumberDana (sumber_dana)
    SELECT DISTINCT sumber_dana FROM stg.Realisasi s
    WHERE NOT EXISTS (SELECT 1 FROM dbo.Dim_SumberDana d WHERE d.sumber_dana = s.sumber_dana);

    INSERT INTO dbo.Dim_Indikator (nama_indikator, satuan, jenis, target_tahun)
    SELECT DISTINCT indikator_id, 'Satuan', 'Output', 0 FROM stg.Capaian s
    WHERE NOT EXISTS (SELECT 1 FROM dbo.Dim_Indikator d WHERE d.nama_indikator = s.indikator_id);
    
    PRINT 'Dimensions Loaded Successfully';
END;
GO

-- LOAD FACT ANGGARAN
CREATE OR ALTER PROCEDURE dbo.usp_Load_Fact_Anggaran
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.Fact_Anggaran_Partitioned;

    -- Setup Default ID untuk menangani Foreign Key yang hilang
    DECLARE @DefUnit INT = (SELECT TOP 1 unit_id FROM dbo.Dim_Unit);
    DECLARE @DefProg INT = (SELECT TOP 1 program_id FROM dbo.Dim_Program);
    DECLARE @DefKeg  INT = (SELECT TOP 1 kegiatan_id FROM dbo.Dim_Kegiatan);
    DECLARE @DefDana INT = (SELECT TOP 1 sumber_dana_key FROM dbo.Dim_SumberDana);

    -- Insert dari RKAT (Rencana)
    INSERT INTO dbo.Fact_Anggaran_Partitioned (
        waktu_key, unit_id, program_id, kegiatan_id, sumber_dana_key, 
        pagu, realisasi, revisi_ke, SourceSystem
    )
    SELECT 
        CAST(rkat.tahun + '0101' AS INT),
        ISNULL(du.unit_id, @DefUnit),
        ISNULL(dp.program_id, @DefProg),
        ISNULL(dk.kegiatan_id, @DefKeg),
        @DefDana,
        TRY_CAST(rkat.pagu AS DECIMAL(18,2)), 
        0, 
        TRY_CAST(rkat.revisi_ke AS INT),
        'Sistem RKAT'
    FROM stg.Anggaran_RKAT rkat
    LEFT JOIN stg.Unit su ON rkat.unit_pk = su.unit_pk 
    LEFT JOIN dbo.Dim_Unit du ON UPPER(TRIM(su.unit_name)) = du.nama_unit
    LEFT JOIN stg.Kegiatan sk ON rkat.kegiatan_pk = sk.kegiatan_pk 
    LEFT JOIN dbo.Dim_Kegiatan dk ON UPPER(TRIM(sk.kegiatan_name)) = dk.nama_kegiatan
    LEFT JOIN stg.Program sp ON sk.program_pk = sp.program_pk 
    LEFT JOIN dbo.Dim_Program dp ON UPPER(TRIM(sp.program_name)) = dp.nama_program
    WHERE ISNUMERIC(rkat.tahun) = 1 AND LEN(rkat.tahun) = 4; -- Filter Data Kotor

    -- Insert dari Realisasi (Belanja)
    INSERT INTO dbo.Fact_Anggaran_Partitioned (
        waktu_key, unit_id, program_id, kegiatan_id, sumber_dana_key, 
        pagu, realisasi, revisi_ke, SourceSystem
    )
    SELECT 
        CAST(CONVERT(VARCHAR(8), CAST(r.tanggal AS DATE), 112) AS INT),
        ISNULL(du.unit_id, @DefUnit),
        ISNULL(dp.program_id, @DefProg),
        ISNULL(dk.kegiatan_id, @DefKeg),
        ISNULL(ds.sumber_dana_key, @DefDana),
        0, 
        TRY_CAST(r.jumlah_realisasi AS DECIMAL(18,2)), 
        0,
        'Sistem Realisasi'
    FROM stg.Realisasi r
    LEFT JOIN stg.Anggaran_RKAT ark ON r.anggaran_id = ark.anggaran_id
    LEFT JOIN stg.Unit su ON ark.unit_pk = su.unit_pk 
    LEFT JOIN dbo.Dim_Unit du ON UPPER(TRIM(su.unit_name)) = du.nama_unit
    LEFT JOIN stg.Kegiatan sk ON ark.kegiatan_pk = sk.kegiatan_pk 
    LEFT JOIN dbo.Dim_Kegiatan dk ON UPPER(TRIM(sk.kegiatan_name)) = dk.nama_kegiatan
    LEFT JOIN stg.Program sp ON sk.program_pk = sp.program_pk 
    LEFT JOIN dbo.Dim_Program dp ON UPPER(TRIM(sp.program_name)) = dp.nama_program
    LEFT JOIN dbo.Dim_SumberDana ds ON r.sumber_dana = ds.sumber_dana
    WHERE ISDATE(r.tanggal) = 1; -- Filter Tanggal Kotor
    
    PRINT 'Fact Anggaran Loaded Successfully';
END;
GO

-- LOAD FACT KINERJA
CREATE OR ALTER PROCEDURE dbo.usp_Load_Fact_Kinerja
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE dbo.Fact_Kinerja;

    INSERT INTO dbo.Fact_Kinerja (waktu_key, unit_id, indikator_id, target, capaian_value, SourceSystem)
    SELECT 
        CAST(s.periode + '0101' AS INT),
        (SELECT TOP 1 unit_id FROM dbo.Dim_Unit), 
        ISNULL(di.indikator_id, -1),
        0, 
        TRY_CAST(s.capaian_value AS DECIMAL(18,2)), 
        'Sistem Kinerja'
    FROM stg.Capaian s
    LEFT JOIN dbo.Dim_Indikator di ON s.indikator_id = di.nama_indikator
    WHERE ISNUMERIC(s.periode) = 1 AND LEN(s.periode) = 4;
    
    PRINT 'Fact Kinerja Loaded Successfully';
END;
GO

-- MASTER ETL PROCEDURE
CREATE OR ALTER PROCEDURE dbo.usp_Master_ETL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        PRINT '>>> Starting ETL Process for Biro Perencanaan...';

        -- Load Dimensions
        EXEC dbo.usp_Load_Dim_Waktu; 
        EXEC dbo.usp_Load_Dimensions;
        
        -- Load Facts
        EXEC dbo.usp_Load_Fact_Anggaran;
        EXEC dbo.usp_Load_Fact_Kinerja;
        
        -- Update Statistics
        UPDATE STATISTICS dbo.Dim_Unit;
        UPDATE STATISTICS dbo.Fact_Anggaran_Partitioned;
        UPDATE STATISTICS dbo.Fact_Kinerja;

        COMMIT TRANSACTION;
        
        PRINT '>>> ETL Completed Successfully <<<';
    END TRY
    BEGIN CATCH
        -- Error Handling: Rollback jika ada yang gagal
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        PRINT '!!! ETL FAILED. Transaction Rolled Back !!!';
    END CATCH
END;
GO

EXEC dbo.usp_Master_ETL;
