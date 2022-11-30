# Analyzing_eCommerce_Business
Dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce </br>
Query: https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/mini-project.sql </br>
Tool: PostgreSQL </br>


#### `1. Data preparation`
Tahap paling awal yang harus dilakukan adalah mempersiapkan data mentah menjadi data yang terstruktur dan siap diolah. Pada tahap ini kita membuat relasi antar tabel menggunakan foreign key untuk memudahkan membuat query antar tabel. Sehingga relasi antar tabel dapat dilihat sebagai berikut: 
![alt text](https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/new%20erd.png?raw=true)


#### `2. Annual Customer Activity growth `
Salah satu metrik yang digunakan untuk mengukur performa bisnis eCommerce adalah aktivitas customer yang berinteraksi di dalam platform eCommerce tersebut. Beberapa metrik yang berhubungan dengan aktivitas customer seperti jumlah customer aktif, jumlah customer baru, jumlah customer yang melakukan repeat order dan juga rata-rata transaksi yang dilakukan customer setiap tahun.
![alt text](https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/annual%20customer%20activity.PNG?raw=true)

Data yang tersedia dimulai dari data transaksi bulan September 2016 sehingga  pertumbuhan customer baru pada tahun 2017 sangat meningkat. Namun di sisi lain, dari segi rata-rata pemesanan/order yang dilakukan customer tidak terlalu baik, tidak ada peningkatan yang signifikan dari tahun 2016-2017. 

### `3. Annual Product Category Quarter`
Performa bisnis eCommerce tentunya sangat berkaitan erat dengan produk-produk yang tersedia di dalamnya. Menganalisis kualitas dari produk dalam eCommerce dapat memberikan keputusan untuk mengembangkan bisnis lebih baik.
![alt text](https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/annual%20product%20category_table.PNG?raw=true)

Dari analisis ini, terlihat bahwa tiap tahun revenue meningkat cukup baik. Kategori produk yang memberi revenue terbanyak setiap tahunnya mengalami perubahan. Kategori dengan cancel terbanyak  juga mengalami perubahan setiap tahun. Hal yang perlu diperhatikan yaitu kategori health and beauty yang memberi revenue terbanyak sekaligus produk yang mengalami cancel terbanyak di tahun 2018. 

![alt text](https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/annual%20product%20category.png?raw=true)

#### `4. Analysis of Annual Payment Usage`
Bisnis eCommerce umumnya menyediakan sistem pembayaran berbasis open-payment yang memungkinkan customer untuk memilih berbagai macam tipe pembayaran yang tersedia. Menganalisis performa dari tipe pembayaran yang ada dapat memberikan insight untuk menciptakan strategic partnership dengan perusahaan penyedia jasa pembayaran dengan lebih baik. Dari data ini kita bisa lihat sistem pembayaran yang tersedia:

![alt text](https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/annual%20payment.PNG?raw=true)

Credit card menjadi tipe pembayaran yang banyak dipilih oleh customer setiap tahunnya, sehingga dapat dilakukan analisis lebih lanjut mengenai kebiasaan pelanggan dalam menggunakan credit card semisal lama tenor yang dipilih, kategori produk apa saja yang biasa dibeli dengan credit card. 

![alt text](https://github.com/almaratussaliha/Analyzing_eCommerce_Business/blob/main/annual%20payment%20type.png?raw=true)

Hal lain yang menarik untuk diperhatikan adalah peningkatan pengguna kartu debit yang signifikan yaitu lebih dari 100% dari tahun 2017-2018. Penggunaan voucher justru menurun dari tahun 2017 ke tahun 2018. Hal ini bisa terjadi karena mungkin adanya promosi atau kerja sama dengan kartu debit tertentu dan juga pengurangan promosi menggunakan voucher. Untuk memastikan hasil analisis inidapat melakukan konfirmasi lanjut dengan departemen lain semisal Marketing atau Business Development.
