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

## 📂 Repository Structure

Berikut adalah struktur direktori dan file dalam repositori ini:

```text
README.md
dashboard/
  └── Dashboard Kelompok 17 Pergudangan Data.pbix
docs/
  ├── 01-requirements/
  │     ├── business-requirements.md
  │     └── data-sources.md
  ├── 02-design/
  │     ├── DDM - Kelompok 17.png
  │     ├── ERD - Kelompok 17.png
  │     ├── ETL Design_Kel7.png
  │     └── data-dictionary.xlsx
  └── 03-implementation/
        └── performance-report.md
etl/
  ├── ETL-architecture.md
  ├── ETL_Execution_Log.txt
  └── Mapping_Final.csv
presentations/
  └── Presentations Slides.pdf
sql/
  ├── 01_Create_Database.sql
  ├── 02_Create_Dimensions.sql
  ├── 03_Create_Facts.sql
  ├── 04_Create_Indexes.sql
  ├── 05_Create_Partitions.sql
  ├── 06_Create_Staging.sql
  ├── 07_ETL_Procedures.sql
  ├── 10_Create_Job.sql
  ├── 11_Create_Analytical_Views.sql
  ├── 12_Security.sql
  └── 13_Backup.sql
tests/
  ├── 08_Data_Quality_Checks.sql
  ├── 09_Test_Queries.sql
  └── testing.md
```

## 🚀 Getting Started

### Prerequisites
Pastikan perangkat Anda memenuhi persyaratan berikut:
- **Database Engine**: Microsoft SQL Server 2019 atau 2022.
- **Tools**: SQL Server Management Studio (SSMS).
- **Visualization**: Microsoft Power BI Desktop.
- **Environment**: Windows (Localhost Deployment).

### Installation

1. **Clone repository**  
   Unduh source code ke komputer lokal Anda:

   ```bash
   git clone https://github.com/sains-data/kelompok17dw_biro-akademik-perencanaan-dan-umum.git
   ```

2. **Execute SQL scripts in order**  
   Buka SSMS, hubungkan ke Localhost, dan jalankan script di folder `sql/` secara berurutan mulai dari `01` sampai `13`.

   *Contoh via Command Line (sqlcmd):*
   ```bash
   sqlcmd -S localhost -i sql/01_Create_Database.sql
   sqlcmd -S localhost -d DM_BiroPerencanaan_DW -i sql/02_Create_Dimensions.sql
   # ... lanjutkan sesuai urutan file
   ```

3. **Run ETL Process**  
   Jalankan Stored Procedure utama untuk memuat data dari CSV ke Data Mart:

   ```sql
   USE DM_BiroPerencanaan_DW;
   EXEC dbo.usp_Master_ETL;
   ```

   *Pastikan pesan "ETL Completed Successfully" muncul pada tab Messages.*

4. **Open Power BI Dashboard**
   - Buka folder `dashboard/`.
   - Klik ganda file **`Dashboard Kelompok 17 Pergudangan Data.pbix`**.
   - Tekan tombol **Refresh** pada menu Home untuk menarik data terbaru.

## 📊 Dashboards Features

- **Executive Dashboard (Keuangan)**: High-level KPIs terkait Pagu Anggaran, Realisasi Belanja, Sisa Anggaran, dan Tren Penyerapan Bulanan.
- **Operational Dashboard (Kinerja)**: Analisis detail mengenai Skor Kinerja Unit, Status Ketercapaian Indikator (Tercapai/Belum), dan Matriks Detail Kegiatan.
- **Custom Reports**: Fitur interaktif (Drill-down & Slicer) untuk analisis ad-hoc per unit kerja.

## 📚 Documentation

Dokumentasi teknis dan fungsional proyek:

- [Business Requirements](docs/01-requirements/business-requirements.md)
- [Data Sources](docs/01-requirements/data-sources.md)  
- [Data Dictionary](docs/02-design/data-dictionary.xlsx)  
- [ETL Architecture](etl/ETL-architecture.md)  
- [Performance Report](docs/03-implementation/performance-report.md)  

## 🧪 Testing Results

Ringkasan hasil pengujian:

| Kategori Test | Hasil Pengujian | Status |
| :--- | :--- | :--- |
| **Data Quality** | **100% Valid (Pass)** pada uji kelengkapan (NULL check) dan konsistensi referensi (FK check). |  **PASS** |
| **Performance** | Waktu eksekusi query agregasi rata-rata **< 0.05 detik**. |  **PASS** |
| **UAT** | Seluruh fitur fungsional dashboard berjalan lancar sesuai skenario pengujian user. |  **PASS** |

## 📅 Project Timeline

- **Misi 1** (Perancangan): Completed [17 November 2025]  
- **Misi 2** (Implementasi ETL): Completed [24 November 2025]  
- **Misi 3** (Visualisasi & Finalisasi): Completed [01 Desember 2025]  
- **Revisi** (Laporan Final): Completed [07 Desember 2025]
  
## 🔒 Security

- **Role-Based Access Control (RBAC)**: Implementasi peran `db_executive` (Full Access), `db_analyst` (Staging), dan `db_viewer` (Read-Only).
- **Audit Trail**: Perekaman otomatis setiap perubahan data (Insert/Update/Delete) pada tabel fakta menggunakan **Database Triggers**.

## 📄 License

Proyek ini dikembangkan sebagai bagian dari tugas akademik mata kuliah Pergudangan Data di **Institut Teknologi Sumatera**.

## 👏 Acknowledgments

- **Program Studi Sains Data**, Fakultas Sains, ITERA.  
- **Dosen Pengampu Mata Kuliah** Pergudangan Data  

## 📞 Issues & Contact

- 🐛 **Report Issues** – Laporkan bug atau request fitur melalui GitHub Issues.
- ✉️ **Email Tim**  
  - Lidia Natasyah Marpaung — lidia.123450015@students.itera.ac.id  
  - Wulan Lumbantoruan — wulan.123450027@students.itera.ac.id  
  - Aisyah Musfirah — aisyah.123450084@students.itera.ac.id
- 💬 **Diskusi**: Gunakan GitHub Discussions untuk tanya jawab dan saran.

