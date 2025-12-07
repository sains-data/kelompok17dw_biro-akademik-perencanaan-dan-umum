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

Untuk meningkatkan tata kelola perencanaan dan anggaran, sistem Data Warehouse dirancang untuk memenuhi kebutuhan integrasi Untuk memenuhi kebutuhan Integrasi data **RKAT/RBA** pada seluruh unit kerja ini membutuhkan kelengkapan dan konsistensi data yang tinggi. Karena itu, kinerja integrasi diukur melalui KPI seperti:

* **Persentase kelengkapan data anggaran**
* **Tingkat konsistensi data antarsumber**

Metrik pendukung mencakup:

* jumlah unit pengirim data
* jumlah baris data valid
* jumlah data yang hilang atau duplikasi

Selain integrasi, sistem juga menyediakan **pemantauan kinerja anggaran** melalui:

* Persentase realisasi anggaran
* Deviasi antara rencana dan realisasi
* Banyaknya revisi anggaran

Metrik operasional yang digunakan meliputi total pagu, total realisasi, dan jumlah revisi.

Platform ini juga mendukung **analisis rencana vs realisasi** untuk anggaran maupun kinerja unit, dengan KPI antara lain:

* Persentase capaian indikator (IKU/IPK)
* Jumlah kegiatan selesai tepat waktu
* Capaian target per program

Pelaporan menjadi salah satu fokus utama. Efektivitas pelaporan diukur melalui:

* Waktu rata-rata penyusunan laporan
* Persentase laporan yang selesai tepat waktu

Untuk menjaga kualitas seluruh proses, sistem juga memastikan pengelolaan **master data** yang akurat, konsisten, dan bebas duplikasi. KPI untuk ini meliputi:

* Persentase validitas master data
* Jumlah duplikasi data

---

# **Ringkasan Pertanyaan Bisnis, KPI, dan Metrik**

| No    | Pertanyaan Bisnis                                                                                                | KPI                                                                                                     | Metrik                                                                                                |
| ----- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| **1** | Bagaimana mengintegrasikan seluruh data perencanaan & anggaran dalam satu sumber data konsisten?                 | - Persentase kelengkapan data anggaran  <br> - Persentase konsistensi data                              | - Jumlah unit yang mengirim data <br> - Jumlah baris data valid <br> - Jumlah data hilang / duplikasi |
| **2** | Bagaimana memantau kinerja unit secara berkala melalui indikator (IKU/IPK) dan capaian kegiatan?                 | - Persentase realisasi anggaran <br> - Deviasi anggaran <br> - Jumlah revisi anggaran                   | - Total pagu <br> - Total realisasi <br> - Jumlah revisi anggaran                                     |
| **3** | Bagaimana melakukan analisis rencana vs realisasi anggaran dan kinerja unit?                                     | - Persentase capaian indikator <br> - Jumlah kegiatan selesai tepat waktu <br> - Capaian target program | - Nilai capaian indikator <br> - Jumlah kegiatan selesai <br> - Target capaian program                |
| **4** | Bagaimana mempermudah proses pelaporan rutin & strategis?                                                        | - Waktu rata-rata pembuatan laporan <br> - Persentase laporan tepat waktu                               | - Waktu pengerjaan laporan <br> - Jumlah laporan selesai tepat waktu                                  |
| **5** | Bagaimana memastikan master data (unit, program, kegiatan, akun, indikator) dikelola secara standar & konsisten? | - Persentase validitas master data <br> - Jumlah duplikasi                                              | - Jumlah entri master data valid <br> - Jumlah duplikasi master data                                  |

---

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
