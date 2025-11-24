# Dokumen ETL Architecture

## 1. Tujuan Dokumen
Dokumen ini menjelaskan rancangan arsitektur ETL (Extract, Transform, Load) untuk Data Warehouse Biro Perencanaan. Isinya mencakup aliran data, sumber-sumber data, proses transformasi, struktur staging, hingga mekanisme pemuatan ke data warehouse.

## 2. Lingkup ETL
* Mengambil data dari sistem operasional
* Membersihkan dan menormalkan data
* Melakukan transformasi bisnis
* Memuat data ke tabel dimension dan fact di data warehouse
* Menjadwalkan proses ETL

## 3. Arsitektur Umum
* **Sumber Data:** Sistem operasional, file Excel, database lokal
* **Staging Area:** Tempat penyimpanan awal sebelum transformasi
* **Transformasi:** Pembersihan, validasi, mapping kode, perhitungan
* **Data Warehouse:** Tabel Dimensi dan Tabel Fakta
* **Tools:** SSMS + SQL Jobs atau SSIS (jika dipakai)

## 4. Desain Alur ETL (High-Level Flow)
1. Extract dari sumber data ke staging
2. Validasi kualitas data
3. Transformasi (konversi, normalisasi, join, kalkulasi)
4. Load ke Dimensi (SCD jika diperlukan)
5. Load ke Fakta (append atau incremental)
6. Monitoring & logging

## 5. Desain Extract
* Mengambil data dari tabel operasional menggunakan query
* Menyimpan hasil extract ke staging dengan nama tabel sementara
* Menangani format data berbeda (jika ada)

## 6. Desain Transform
Transformasi yang dilakukan:
* Konversi tipe data
* Normalisasi kode unit
* Perhitungan persentase serapan
* Mapping foreign key ke dimensi
* Pemeriksaan data null dan anomali

## 7. Desain Load
* **Load Dimensi:**
    * Insert data baru
    * Update data jika ada perubahan (opsional)
* **Load Fakta:**
    * Insert baris transaksi anggaran
    * Menggunakan partitioning untuk kinerja

## 8. Arsitektur Tabel Staging
* Staging_Unit
* Staging_Anggaran
* Staging_Realisasi

Semua tabel bersifat sementara dan dibersihkan secara berkala.

## 9. Mekanisme Penjadwalan ETL
* Menggunakan SQL Server Agent Job
* Frekuensi: mingguan atau bulanan
* Tahapan job:
    1. Extract
    2. Transform
    3. Load Dimensi
    4. Load Fakta

## 10. Monitoring & Logging
* Log keberhasilan ETL
* Log error
* Notifikasi email jika job gagal

## 11. Diagram Arsitektur
Sumber Data → Staging Area → Transform Engine → Dimensi → Fakta → Reporting

## 12. Catatan Implementasi
* Gunakan transaksi untuk proses load
* Gunakan index setelah data stabil
* Pastikan validasi data berjalan sebelum load
