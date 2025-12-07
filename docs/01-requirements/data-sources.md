# **Data Sources Overview**

Infrastruktur data dibangun di atas data sekunder yang merepresentasikan ekosistem operasional Biro Perencanaan. Sumber data terdiri dari enam file utama yang berfungsi sebagai input sistem dan satu file pendukung validasi. Data diklasifikasikan menjadi dua kategori: data master yang bersifat statis dan data transaksi yang dinamis. 
Berikut adalah sumber data yang digunakan untuk analisis pada proyek ini:


| **Nama Data Source**  | **Tipe**        | **Volume** | **Update Frequency**       |
| --------------------- | --------------- | ---------- | -------------------------- |
| **anggaran_flat.csv** | CSV (Synthetic) | 510 rows   | One-time (manual generate) |
| **unit.csv**          | CSV (Synthetic) | 7 rows     | Static (master data)       |
| **programs.csv**      | CSV (Synthetic) | 6 rows     | Annual                     |
| **kegiatan.csv**      | CSV (Synthetic) | 6 rows     | Annual                     |
| **realisasi.csv**     | CSV (Synthetic) | 510 rows   | Monthly                    |
| **anggaran_rkat.csv** | CSV (Synthetic) | 510 rows   | Annual                     |
| **capaian.csv**       | CSV (Synthetic) | 109 rows   | Monthly / Triwulan         |
