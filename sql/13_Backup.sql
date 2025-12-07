USE master;
GO

-- FULL BACKUP 
BACKUP DATABASE DM_BiroPerencanaan_DW
TO DISK = N'C:\Backup\DM_BiroPerencanaan_DW_Full.bak'
WITH 
    FORMAT, 
    COMPRESSION, 
    INIT,
    NAME = N'Full Database Backup - Biro Perencanaan', 
    STATS = 10;
GO
PRINT 'Full Backup Selesai.';

-- DIFFERENTIAL BACKUP 
BACKUP DATABASE DM_BiroPerencanaan_DW
TO DISK = N'C:\Backup\DM_BiroPerencanaan_DW_Diff.bak'
WITH 
    DIFFERENTIAL, 
    COMPRESSION, 
    INIT,
    NAME = N'Differential Database Backup', 
    STATS = 10;
GO
PRINT 'Differential Backup Selesai.';

-- TRANSACTION LOG BACKUP
BACKUP LOG DM_BiroPerencanaan_DW
TO DISK = N'C:\Backup\DM_BiroPerencanaan_DW_Log.trn'
WITH 
    COMPRESSION, 
    NOINIT, 
    NAME = N'Transaction Log Backup', 
    STATS = 10;
GO
PRINT 'Transaction Log Backup Selesai.';