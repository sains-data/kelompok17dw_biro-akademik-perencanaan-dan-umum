USE msdb;
GO

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'ETL_BiroPerencanaan_Daily')
EXEC sp_delete_job @job_name = N'ETL_BiroPerencanaan_Daily', @delete_unused_schedule=1;
GO

EXEC sp_add_job
    @job_name = N'ETL_BiroPerencanaan_Daily',
    @enabled = 1,
    @description = N'Job Harian untuk Update Data Warehouse Biro Perencanaan (Kelompok 17)';
GO

EXEC sp_add_jobstep
    @job_name = N'ETL_BiroPerencanaan_Daily',
    @step_name = N'Execute Master ETL Package',
    @subsystem = N'TSQL',
    @command = N'EXEC DM_BiroPerencanaan_DW.dbo.usp_Master_ETL;', 
    @database_name = N'DM_BiroPerencanaan_DW',
    @retry_attempts = 3,
    @retry_interval = 5;
GO

-- Buat Jadwal (Setiap Hari jam 02:00 Pagi)
EXEC sp_add_schedule
    @schedule_name = N'Daily_2AM_Schedule',
    @freq_type = 4, -- Interval Harian
    @freq_interval = 1,
    @active_start_time = 020000; -- Format: JJMMDD (02:00:00)
GO

EXEC sp_attach_schedule
    @job_name = N'ETL_BiroPerencanaan_Daily',
    @schedule_name = N'Daily_2AM_Schedule';
GO

EXEC sp_add_jobserver
    @job_name = N'ETL_BiroPerencanaan_Daily';
GO