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

![Star Schema Diagram](docs/02-design/star-schema.png) **Fact Tables (Tabel Fakta):**
* `Fact_Anggaran_Partitioned`: Tabel fakta utama yang menyimpan data transaksi keuangan (Pagu dan Realisasi Belanja). Tabel ini memiliki granularitas per kegiatan dan menggunakan strategi **Partisi Tahunan** untuk optimasi performa kueri.
* `Fact_Kinerja`: Tabel fakta yang menyimpan data evaluasi operasional, mencakup Target dan Nilai Capaian (Output) dari setiap indikator kinerja unit.

**Dimension Tables (Tabel Dimensi):**
* `Dim_Unit`: Menyimpan informasi hierarki struktur organisasi (Biro, Fakultas, Lembaga, UPT) untuk analisis performa per unit kerja.
* `Dim_Program`: Berisi daftar program kerja strategis yang mengacu pada Rencana Strategis (Renstra) institusi.
* `Dim_Kegiatan`: Menyimpan rincian aktivitas operasional yang merupakan turunan dari program kerja.
* `Dim_SumberDana`: Mengklasifikasikan jenis asal dana (misal: Rupiah Murni, PNBP, BOPTN, Hibah).
* `Dim_Indikator`: Menyimpan metadata indikator kinerja (IKU/IK), termasuk nama indikator dan satuan pengukurannya.
* `Dim_Waktu`: Dimensi kalender yang mendukung analisis *time-series* (Tahun, Semester, Triwulan, Bulan).

## Documentation
- [Business Requirements](docs/01-requirements/)
- [Design Documents](docs/02-design/)
- [ETL](docs/ETL/)
- [Performance Report](docs/performance-report/)

## Timeline
- Misi 1: 17 November 2025
- Misi 2: 24 November 2025
- Misi 3: [1 Desember 2025]
