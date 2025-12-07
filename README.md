# Data Mart - Biro Akademik, Perencanaan dan Umum
Tugas Besar Pergudangan Data - Kelompok 17

# Perancangan dan Implementasi Data Mart untuk Monitoring Anggaran dan Evaluasi Kinerja (Biro Perencanaan ITERA)

## 📌 Executive Summary
Proyek ini bertujuan untuk membangun solusi **Data Mart** yang terintegrasi bagi Biro Akademik, Perencanaan, dan Umum (Biro Perencanaan) Institut Teknologi Sumatera (ITERA). Sistem ini dirancang untuk mengatasi masalah fragmentasi data antara Rencana Anggaran (RKAT/RBA), Realisasi Belanja, dan Capaian Kinerja Unit. 

Dengan menerapkan konsep *Single Source of Truth* dan metodologi **Kimball Dimensional Modeling**, Data Mart ini mendukung pimpinan dalam memonitor efektivitas penyerapan anggaran, mendeteksi *underspending/overspending*, dan mengevaluasi kinerja unit kerja secara *real-time* melalui dashboard analitik interaktif.

## 👥 Team Members - Kelompok 17
Berikut adalah pembagian peran utama dalam pengembangan proyek ini:

| NIM | Nama | Peran Utama |
|-----|------|-------------|
| **123450084** | **Aisyah Musfirah** | **Project Leader & Business Analyst** | 
| **123450027** | **Wulan Lumbantoruan** | **ETL Developer & Documentation** | 
| **123450015** | **Lidia Natasyah Marpaung** | **BI Developer & QA** | 

## 🏢 Business Domain
Analisis difokuskan pada **Biro Akademik, Perencanaan, dan Umum** khususnya bagian **Perencanaan** dengan cakupan:
* **Proses Bisnis:** Perencanaan Anggaran (RKAT), Monitoring Realisasi Belanja, dan Evaluasi Indikator Kinerja (IKU/IK).
* **Masalah Utama:** Data tersebar (CSV terpisah), format tidak konsisten, dan kesulitan rekonsiliasi manual.
* **Solusi:** Integrasi data terpusat dengan validasi otomatis.

## 🎯 Objectives
1.  **Integrasi Data:** Menyatukan data perencanaan, realisasi, dan kinerja ke dalam satu repositori *Star Schema*.
2.  **Monitoring Real-time:** Menyediakan visualisasi persentase serapan anggaran dan status capaian kinerja.
3.  **Peningkatan Kualitas Data:** Mengurangi kesalahan data melalui validasi ETL otomatis (*Zero Error Policy*).

## 📈 Key Performance Indicators (KPIs)

Keberhasilan implementasi sistem diukur melalui tiga indikator utama yang mencerminkan kesehatan finansial, operasional, dan kualitas data:
| Kategori | KPI Utama | Metrik Pengukuran | Deskripsi |
| :--- | :--- | :--- | :--- |
| **Keuangan** | **Efektivitas Penyerapan Anggaran** | • Persentase Serapan (%)<br>• Total Sisa Anggaran (Rp)<br>• Tren Realisasi Bulanan | Mengukur seberapa optimal dana anggaran digunakan oleh unit kerja dibandingkan dengan pagu yang ditetapkan. |
| **Operasional** | **Ketercapaian Target Kinerja** | • Rata-rata Skor Kinerja<br>• Status Ketercapaian (Tercapai/Belum)<br>• Kontribusi Program | Mengukur produktivitas unit berdasarkan output kegiatan dan target indikator (IKU/IK). |
| **Data Quality** | **Indeks Kesehatan Data** | • Tingkat Kelengkapan (No NULL)<br>• Konsistensi Referensi (Valid FK)<br>• Validitas Nilai (No Negative) | Memastikan data di dalam Data Mart bersih, valid, dan konsisten setelah proses ETL. |

## 🛠️ Tech Stack & Architecture
* **Methodology:** Kimball Dimensional Modeling (Star Schema).
* **Database:** Microsoft SQL Server 2022 Developer Edition (On-Premise/Localhost).
* **ETL Tool:** Native T-SQL Stored Procedures.
* **Visualization:** Microsoft Power BI Desktop.
* **Version Control:** GitHub.

### Data Model (Star Schema)

**Fact Tables (Tabel Fakta):**
* `Fact_Anggaran_Partitioned`: Tabel fakta utama yang menyimpan data transaksi keuangan (Pagu dan Realisasi Belanja). 
* `Fact_Kinerja`: Tabel fakta yang menyimpan data evaluasi operasional, mencakup Target dan Nilai Capaian (Output) dari setiap indikator kinerja unit.

**Dimension Tables (Tabel Dimensi):**
* `Dim_Unit`: Menyimpan informasi hierarki struktur organisasi (Biro, Fakultas, Lembaga, UPT) untuk analisis performa per unit kerja.
* `Dim_Program`: Berisi daftar program kerja strategis yang mengacu pada Rencana Strategis (Renstra) institusi.
* `Dim_Kegiatan`: Menyimpan rincian aktivitas operasional yang merupakan turunan dari program kerja.
* `Dim_SumberDana`: Mengklasifikasikan jenis asal dana.
* `Dim_Indikator`: Menyimpan metadata indikator kinerja (IKU/IK), termasuk nama indikator dan satuan pengukurannya.
* `Dim_Waktu`: Dimensi kalender yang mendukung analisis *time-series* (Tahun, Semester, Triwulan, Bulan).

## Repository Structure

Berikut adalah struktur direktori dan file dalam repositori ini. Klik pada nama file untuk melihat isinya.

- [README.md](README.md)
- **dashboard**
  - [Dashboard Kelompok 17 Pergudangan Data.pbix](dashboard/Dashboard%20Kelompok%2017%20Pergudangan%20Data.pbix)
- **docs**
  - **01-requirements**
    - [business-requirements.md](docs/01-requirements/business-requirements.md)
    - [data-sources.md](docs/01-requirements/data-sources.md)
  - **02-design**
    - [DDM - Kelompok 17.png](docs/02-design/DDM%20-%20Kelompok%2017.png)
    - [ERD - Kelompok 17.png](docs/02-design/ERD%20-%20Kelompok%2017.png)
    - [ETL Design_Kel7.png](docs/02-design/ETL%20Design_Kel7.png)
    - [data-dictionary.xlsx](docs/02-design/data-dictionary.xlsx)
  - **03-implementation**
    - [performance-report.md](docs/03-implementation/performance-report.md)
- **etl**
  - [ETL-architecture.md](etl/ETL-architecture.md)
  - [ETL_Execution_Log.txt](etl/ETL_Execution_Log.txt)
  - [Mapping_Final.csv](etl/Mapping_Final.csv)
- **presentations**
  - [Presentations Slides.pdf](presentations/Presentations%20Slides.pdf)
- **sql**
  - [01_Create_Database.sql](sql/01_Create_Database.sql)
  - [02_Create_Dimensions.sql](sql/02_Create_Dimensions.sql)
  - [03_Create_Facts.sql](sql/03_Create_Facts.sql)
  - [04_Create_Indexes.sql](sql/04_Create_Indexes.sql)
  - [05_Create_Partitions.sql](sql/05_Create_Partitions.sql)
  - [06_Create_Staging.sql](sql/06_Create_Staging.sql)
  - [07_ETL_Procedures.sql](sql/07_ETL_Procedures.sql)
  - [08_Data_Quality_Checks.sql](sql/08_Data_Quality_Checks.sql)
  - [09_Test_Queries.sql](sql/09_Test_Queries.sql)
  - [10_Create_Job.sql](sql/10_Create_Job.sql)
  - [11_Create_Analytical_Views.sql](sql/11_Create_Analytical_Views.sql)
  - [12_Security.sql](sql/12_Security.sql)
  - [13_Backup.sql](sql/13_Backup.sql)
- **tests**
  - [08_Data_Quality_Checks.sql](tests/08_Data_Quality_Checks.sql)
  - [09_Test_Queries.sql](tests/09_Test_Queries.sql)
  - [testing.md](tests/testing.md)

## Timeline
- Misi 1: 17 November 2025
- Misi 2: 24 November 2025
- Misi 3: 1 Desember 2025
