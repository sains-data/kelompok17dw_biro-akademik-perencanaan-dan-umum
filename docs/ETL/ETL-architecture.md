# Dokumen ETL Architecture - Biro Perencanaan Data Warehouse

## 1. Tujuan Dokumen
Dokumen ini menjelaskan rancangan arsitektur **ETL (Extract, Transform, Load)** untuk Data Warehouse Biro Perencanaan. Isinya mencakup aliran data, sumber-sumber data, proses transformasi, struktur staging, hingga mekanisme pemuatan ke data warehouse.

## 2. Lingkup ETL
* Mengambil data dari sistem operasional (CSV/Database).
* Membersihkan dan menormalkan data di Staging Area.
* Melakukan transformasi bisnis (Data Cleansing & Calculation).
* Memuat data ke tabel dimensi dan fakta di Data Warehouse.
* Menjadwalkan proses ETL secara otomatis.

## 3. Arsitektur Umum
| Komponen | Deskripsi |
| :--- | :--- |
| **Sumber Data** | File Excel (CSV), Sistem Operasional Kampus. |
| **Staging Area** | Database `stg` (Tempat penyimpanan sementara sebelum transformasi). |
| **Transformasi** | Pembersihan spasi, validasi tipe data, mapping Foreign Key, perhitungan KPI. |
| **Data Warehouse** | Database `dbo` dengan skema Star Schema (Fact & Dimension). |
| **Tools** | SQL Server Management Studio (SSMS), T-SQL Stored Procedures. |

## 4. Desain Alur ETL (High-Level Flow)
1.  **Extract:** Import data mentah dari CSV ke tabel Staging.
2.  **Validate:** Cek kualitas data (Null, Duplikat, Konsistensi).
3.  **Transform:** Konversi tipe data, normalisasi nama unit, hitung selisih anggaran.
4.  **Load Dimension:** Masukkan data master baru ke tabel Dimensi.
5.  **Load Fact:** Masukkan data transaksi ke tabel Fakta dengan *Lookup ID*.
6.  **Monitor:** Catat log eksekusi dan status keberhasilan.

## 5. Desain Extract
* Menggunakan **SQL Server Import Wizard** atau **Bulk Insert**.
* Semua kolom di-import sebagai `VARCHAR` terlebih dahulu untuk mencegah error tipe data.
* Nama tabel staging disesuaikan dengan nama file sumber (contoh: `stg.Unit`, `stg.Anggaran_RKAT`).

## 6. Desain Transform
Transformasi utama yang dilakukan meliputi:
* **Data Cleansing:** `UPPER(TRIM())` untuk standarisasi teks.
* **Data Type Conversion:** Mengubah string '100000' menjadi `DECIMAL(18,2)`.
* **Key Lookup:** Mengganti Kode Unit ('UNIT01') menjadi `unit_id` (Integer) dari tabel Dimensi.
* **Calculation:** Menghitung `% Serapan = (Realisasi / Pagu) * 100`.

## 7. Desain Load
* **Load Dimensi:** Menggunakan pola *Insert if Not Exists* (hanya data baru yang masuk).
* **Load Fakta:**
    * Menggunakan metode *Truncate & Load* (bersihkan partisi lalu isi ulang) untuk menjaga konsistensi.
    * Menerapkan *Partitioning* berdasarkan Tahun Anggaran pada tabel `Fact_Anggaran`.

## 8. Arsitektur Tabel Staging
Tabel berikut bersifat sementara (temporary) dan berada di skema `stg`:
* `stg.Unit`
* `stg.Program`
* `stg.Kegiatan`
* `stg.Anggaran_RKAT`
* `stg.Realisasi`
* `stg.Capaian`

## 9. Diagram Arsitektur Data Flow
```mermaid
graph LR
A[CSV Source Files] -->|Extract| B(Staging Area DB)
B -->|Transform & Cleanse| C{ETL Stored Procedures}
C -->|Load Dimension| D[Dim Tables]
C -->|Load Fact| E[Fact Tables]
D --> F[Data Warehouse Star Schema]
E --> F
F -->|Analysis| G[Reporting / Dashboard]
