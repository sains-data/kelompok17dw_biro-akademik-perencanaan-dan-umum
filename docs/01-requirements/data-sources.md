# **Data Sources Overview**

Berikut adalah daftar sumber data yang digunakan dalam pembangunan Data Warehouse. Seluruh dataset merupakan **data sintetis (synthetic)** yang dihasilkan secara manual untuk keperluan simulasi proses perencanaan, penganggaran, dan kinerja di lingkungan ITERA.

| **Nama Data Source**  | **Tipe**        | **Volume** | **Update Frequency**       |
| --------------------- | --------------- | ---------- | -------------------------- |
| **anggaran_flat.csv** | CSV (Synthetic) | 510 rows   | One-time (manual generate) |
| **unit.csv**          | CSV (Synthetic) | 7 rows     | Static (master data)       |
| **programs.csv**      | CSV (Synthetic) | 6 rows     | Annual                     |
| **kegiatan.csv**      | CSV (Synthetic) | 6 rows     | Annual                     |
| **realisasi.csv**     | CSV (Synthetic) | 510 rows   | Monthly                    |
| **anggaran_rkat.csv** | CSV (Synthetic) | 510 rows   | Annual                     |
| **capaian.csv**       | CSV (Synthetic) | 109 rows   | Monthly / Triwulan         |
