# **Project Overview**

Proyek ini bertujuan untuk membangun **Data Warehouse** yang mengintegrasikan data perencanaan, penganggaran, dan kinerja di lingkungan **ITERA**. Sistem ini dirancang untuk mendukung analisis strategis, monitoring operasional, serta menyediakan satu sumber data yang konsisten bagi pimpinan, unit kerja, dan pengelola keuangan.

Data Warehouse mencakup proses:

* **Perencanaan** (program & kegiatan)
* **Penganggaran** (pagu, revisi, realisasi)
* **Indikator kinerja** (IKU, IPK, IK)
* **Capaian unit** pada berbagai periode

Sistem ini diharapkan menjadi fondasi analitik institusi dengan meningkatkan akurasi, konsistensi, dan ketersediaan data lintas proses bisnis.

---

# **Business Requirements**

Biro Akademik, Perencanaan, dan Umum (Biro Perencanaan) di ITERA saat ini menghadapi tantangan signifikan dalam pengelolaan data perencanaan dan anggaran yang masih terfragmentasi. Data perencanaan (RKAT/RBA) dan data realisasi keuangan tersimpan dalam format file CSV yang terpisah, sehingga menyulitkan proses rekonsiliasi dan pemantauan kinerja secara holistik. 

Kebutuhan bisnis utama yang mendasari pengembangan Data Warehouse ini adalah urgensi untuk mengintegrasikan seluruh data tersebut menjadi satu sumber kebenaran tunggal (Single Source of Truth). Integrasi ini krusial untuk menghilangkan inkonsistensi data antar unit kerja dan mempercepat proses pelaporan yang selama ini dilakukan secara manual. 

Selain integrasi, manajemen membutuhkan alat bantu visual untuk memantau efektivitas penggunaan anggaran secara real-time. Sistem dituntut untuk mampu menyandingkan data rencana anggaran (Pagu) dengan realisasi belanja aktual guna menghitung persentase serapan anggaran. Informasi ini diperlukan untuk mendeteksi dini adanya underspending (penyerapan rendah) atau over-spending pada setiap unit kerja sebelum periode tahun anggaran berakhir. 

Kebutuhan bisnis selanjutnya berfokus pada evaluasi kinerja operasional. Selain aspek keuangan, Biro Perencanaan perlu mengukur produktivitas unit melalui indikator kinerja (IKU/IK). Sistem harus mampu memetakan capaian volume keluaran (output) dari setiap kegiatan unit kerja, sehingga pimpinan dapat menilai apakah anggaran yang diserap sejalan dengan hasil kinerja yang dicapai.


# **Functional Requirement**

Untuk menjawab kebutuhan bisnis tersebut, sistem Data Warehouse ini dibangun dengan spesifikasi fungsional yang berfokus pada otomatisasi dan validasi data. Pada sisi pengolahan data (back-end), sistem memiliki fungsi ETL (Extract, Transform, Load) yang mampu membaca tujuh file sumber berformat CSV dan melakukan pembersihan data secara otomatis. Fungsi ini mencakup validasi format tahun untuk mencegah masuknya data sampah (seperti teks non-numerik pada kolom tahun) serta penanganan data referensi yang tidak lengkap menggunakan mekanisme default value. 

Dari sisi penyimpanan, sistem difungsikan untuk mengelola data historis dalam struktur model dimensional (Star Schema) yang optimal untuk analitik. Sistem menerapkan strategi partisi (partitioning) pada tabel fakta anggaran berdasarkan tahun, yang memungkinkan akses data historis tetap cepat meskipun volume data transaksi bertambah seiring waktu. Hal ini memastikan performa sistem tetap stabil saat digunakan untuk analisis tren tahunan. 

Pada sisi antarmuka pengguna (Front-end), fungsi pelaporan diwujudkan melalui dashboard interaktif yang terhubung langsung dengan basis data. Sistem menyediakan fitur penyaringan dinamis (Slicer) yang memungkinkan pengguna membedah data berdasarkan Tahun Anggaran dan Unit Kerja. Selain itu, fungsi drill-down disediakan agar pengguna dapat menelusuri data dari level agregat (Fakultas/Biro) hingga ke rincian program atau kegiatan spesifik.

# **KPI & Metrics**

Keberhasilan implementasi sistem diukur melalui serangkaian Indikator Kinerja Utama (KPI) yang mencerminkan kesehatan finansial dan operasional institusi. KPI ini diturunkan langsung dari ketersediaan data pada tabel fakta anggaran dan kinerja. 

Pada aspek keuangan, indikator utamanya adalah Efektivitas Penyerapan Anggaran. KPI ini dihitung dengan membandingkan total realisasi belanja terhadap total pagu anggaran untuk menghasilkan persentase serapan. Metrik pendukungnya meliputi Sisa Anggaran, yang merupakan selisih nominal antara pagu dan realisasi, memberikan gambaran langsung mengenai dana yang belum terserap. Analisis juga diperdalam dengan melihat Tren Belanja Bulanan, yang memetakan pola pengeluaran sepanjang tahun untuk mendeteksi anomali realisasi di bulan-bulan tertentu. 

Pada aspek operasional, fokus KPI adalah Ketercapaian Kinerja Unit. Indikator ini diukur melalui total volume capaian (output) yang dilaporkan oleh unit kerja. Metrik ini disandingkan dengan target (baik target asli maupun benchmark rata-rata) untuk menentukan status kinerja unit, apakah "Tercapai" atau "Belum Tercapai". Selain itu, metrik Kontribusi Program digunakan untuk melihat proporsi anggaran yang diserap oleh masing-masing program kerja utama, memastikan alokasi sumber daya sejalan dengan prioritas institusi.

Berikut adalah ringkasan dari pertanyaan bisnis, KPI, serta metrik yang dinilai pada proyek ini:

| No | Pertanyaan Bisnis | KPI | Metrik |
|----|--------------------|-----|--------|
| 1 | Bagaimana tingkat efisiensi penggunaan anggaran oleh setiap unit kerja dibandingkan dengan rencana yang telah ditetapkan? | Efektivitas Penyerapan Anggaran (Mengukur seberapa optimal dana terserap) | 1. Persentase Serapan Anggaran (% Realisasi terhadap Pagu).<br>2. Total Sisa Anggaran (Deviasi Rupiah).<br>3. Tren Realisasi Bulanan (Pola belanja). |
| 2 | Sejauh mana target strategis institusi (IKU/IPK) berhasil dicapai oleh unit-unit kerja pada periode berjalan? | Ketercapaian Target Kinerja Unit (Mengukur hasil kerja/output) | 1. Rata-rata Persentase Capaian (IKU/IPK).<br>2. Status Kinerja (Jumlah indikator “Tercapai” vs “Belum”).<br>3. Detail Capaian per Program. |
| 3 | Bagaimana memastikan seluruh data perencanaan yang terintegrasi memiliki validitas tinggi, konsisten, dan bebas dari duplikasi? | Indeks Kesehatan & Validitas Data (Mengukur kebersihan data di warehouse) | 1. Tingkat Kelengkapan Data (% Unit yang datanya masuk).<br>2. Validitas Data (Jumlah baris data error; misal nilai minus atau orphan key).<br>3. Tingkat Duplikasi (Jumlah data ganda pada master data). |

Dalam pengelolaan anggaran, pimpinan institusi memantau kondisi keuangan dan menetapkan arah strategis. Biro Perencanaan & Keuangan mengelola seluruh siklus data RKAT/RBA, mulai dari pengumpulan hingga pelaporan. Fakultas dan Program Studi memasukkan data anggaran serta memonitor realisasi kegiatan masing-masing. Tim Data/IT menjaga integrasi sistem, kualitas master data, dan penyediaan infrastruktur laporan. Auditor internal maupun eksternal kemudian memanfaatkan data tersebut untuk menilai akuntabilitas dan kepatuhan proses anggaran.


# **Stakeholders**

Beberapa pihak utama yang terlibat dalam pengelolaan dan analisis anggaran institusi:

* **Pimpinan Institusi**
  Memantau kondisi anggaran secara keseluruhan dan mengambil keputusan strategis.

* **Biro Perencanaan & Keuangan**
  Mengelola data RKAT/RBA dari pengumpulan, validasi, hingga penyusunan laporan.

* **Unit Fakultas & Program Studi**
  Mengirim data anggaran dan memantau realisasi kegiatan masing-masing.

* **Tim Data / IT**
  Menjaga kelancaran integrasi data, kualitas master data, dan infrastruktur pelaporan.

* **Auditor Internal / Eksternal**
  Menggunakan data untuk memastikan akuntabilitas dan kepatuhan terhadap regulasi.
