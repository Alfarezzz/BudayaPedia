// lib/data/minangkabau.dart (KODE FINAL YANG PALING BERSIH DAN LENGKAP)

// >>> GANTI DEFINISI KELAS DENGAN IMPORT MODEL TUNGGAL INI <<<
import '../pages/module_content_model.dart';
// >>> END IMPORT MODEL <<<

// HAPUS DEFINISI LAMA CLASS MODULECONTENT DI SINI!
// class ModuleContent { ... } <--- HARUS DIHAPUS TOTAL DARI FILE INI!


// Data Kursus "Filosofi Adat dan Rumah Gadang Minangkabau"
// Tipe data ModuleContent sekarang diambil dari module_content_model.dart
final List<ModuleContent> papedaModules = [
  // --- INDEKS 0: PENGANTAR ---
  ModuleContent(
    title: 'COURSE OVERVIEW',
    duration: '03:00',
    contentTitle: 'Pengantar Kursus Minangkabau',
    contentText:
        "Kursus ini dirancang untuk memberikan pemahaman komprehensif mengenai peradaban Minangkabau yang unik, khususnya melalui lensa struktur sosial matrilineal dan filosofi arsitektur Rumah Gadang. Minangkabau tidak hanya dikenal dengan keindahan alamnya di Sumatera Barat, tetapi juga dengan sistem adatnya yang kompleks, yang telah bertahan selama berabad-abad meskipun terjadi perubahan zaman dan modernisasi.\n\n" +
        "Fokus utama kursus ini adalah menguraikan empat pilar utama kebudayaan Minang: sistem garis keturunan ibu (matrilineal), peran sentral wanita (Bundo Kanduang), kepemimpinan adat laki-laki (Niniak Mamak), dan Rumah Gadang sebagai pusat kosmik kaum. Dengan memahami pilar-pilar ini, peserta diharapkan dapat mengapresiasi harmonisasi antara Adat dan Syarak (Islam) yang menjadi filosofi hidup masyarakat Minang.\n\n" +
        "Anda akan dibawa untuk menelusuri bagaimana matrilineal tidak hanya mengatur pewarisan harta, tetapi juga membentuk ikatan keluarga yang kuat dan mendorong laki-laki untuk merantau (mencari ilmu dan kemakmuran di luar kampung). Setiap modul disusun secara bertahap, mulai dari konsep dasar hingga aplikasi praktis dalam upacara adat.\n\n" +
        "Pada akhirnya, kursus ini bertujuan untuk memperjelas bahwa adat Minangkabau adalah sistem yang dinamis dan berkeadilan. Meskipun kepemimpinan adat dipegang oleh laki-laki (Niniak Mamak), hak kepemilikan dan otoritas spiritual tetap berada di tangan perempuan (Bundo Kanduang), menciptakan keseimbangan kekuasaan yang jarang ditemukan dalam kebudayaan lain di dunia.",
  ),

  // --- MODUL 1: STRUKTUR SOSIAL MATRILINEAL (Indeks 1, 2) ---
  ModuleContent(
    title: 'Pengantar Matrilineal',
    duration: '08:00',
    contentTitle: 'Sistem Garis Keturunan Ibu (Matrilineal)',
    contentText:
        "Minangkabau memegang teguh salah satu sistem matrilineal terbesar dan paling konsisten di dunia, yang berarti garis keturunan ditentukan dan diwariskan dari pihak ibu. Konsekuensi dari sistem ini sangat fundamental, karena ia membentuk inti dari struktur sosial, ekonomi, hingga politik masyarakat Minang. Seorang anak akan selalu menjadi anggota Suku ibunya, dan ikatan ini lebih kuat daripada ikatan perkawinan.\n\n" +
        "Dalam konteks ekonomi dan properti, sistem matrilineal menentukan hak waris atas harta pusaka. Harta pusaka tinggi, seperti sawah, ladang, dan yang paling penting, Rumah Gadang, secara turun-temurun dipegang oleh kaum wanita. Harta ini tidak dapat dijual atau dibagi-bagi secara individu, melainkan menjadi milik komunal kaum yang dikelola oleh Bundo Kanduang dan diawasi oleh Niniak Mamak. Posisi perempuan sebagai pewaris ini memberikan mereka otoritas dan perlindungan sosial yang kuat.\n\n" +
        "Peran laki-laki dalam sistem ini tidak hilang, namun bergeser. Laki-laki Minang memiliki tanggung jawab ganda: mereka bertanggung jawab memelihara kaum saudara perempuannya (sebagai Mamak atau Paman) dan, pada saat yang sama, mencari nafkah untuk anak-anaknya yang berada di bawah naungan kaum istrinya. Pergeseran tanggung jawab ini mendorong tradisi merantau, yaitu pergi mencari ilmu dan penghidupan di luar kampung, untuk kemudian membawa pulang kemuliaan bagi kaum istrinya dan kampungnya.\n\n" +
        "Inti dari sistem matrilineal Minangkabau adalah filosofi menjaga keutuhan kaum. Dengan mewariskan aset melalui perempuan, sistem ini memastikan bahwa Rumah Gadang sebagai pusat identitas kaum akan selalu dihuni dan dipelihara. Ini juga memperkuat kedudukan ibu dan perempuan sebagai penjaga adat dan moralitas, menjadikannya kunci keberlangsungan peradaban Minangkabau.",
  ),
  ModuleContent(
    title: 'Peran Suku dan Kampung',
    duration: '07:30',
    contentTitle: 'Ikatan Suku (Klan) dan Wilayah Adat (Nagari)',
    contentText:
        "Setiap orang Minang wajib menjadi anggota dari salah satu Suku atau klan. Suku adalah kelompok kekerabatan besar yang terbentuk dari beberapa kaum (keluarga besar). Menjadi anggota suku adalah penentu identitas, hak, dan kewajiban adat seseorang. Ikatan suku sangat penting dalam upacara besar dan musyawarah adat.\n\n" +
        "Suku di Minangkabau diatur berdasarkan sistem matrilineal, di mana anak akan mengikuti suku ibunya. Suku berfungsi sebagai jaring pengaman sosial, ekonomi, dan politik. Dalam tradisi, pernikahan hanya boleh dilakukan antara anggota suku yang berbeda (eksogami). Hal ini memastikan perluasan ikatan kekerabatan dan mencegah dominasi kekuasaan oleh satu kelompok.\n\n" +
        "Kesatuan dari beberapa suku membentuk Nagari, yaitu kesatuan masyarakat hukum adat yang memiliki wilayah, batas, dan pemerintahan sendiri. Nagari adalah unit sosial-politik tertua dan fundamental di Minangkabau. Nagari bukan hanya desa, tetapi juga sebuah republik mini yang mengatur dirinya sendiri berdasarkan hukum adat yang disepakati bersama oleh para pemimpin adat (Niniak Mamak).\n\n" +
        "Struktur Nagari ini mencerminkan semangat demokrasi khas Minangkabau yang berlandaskan musyawarah dan mufakat. Para Niniak Mamak dari berbagai suku dalam nagari berkumpul di Balai Adat untuk mengambil keputusan penting, mengatur tata ruang, hingga menyelesaikan konflik. Nagari adalah wujud nyata dari kedaulatan masyarakat adat di tanah Minangkabau.",
  ),

  // --- MODUL 2: PERAN PENTING (Indeks 3, 4) ---
  ModuleContent(
    title: 'Adat Basandi Syarak',
    duration: '10:15',
    contentTitle: 'Filosofi Hidup: ABS-SBK',
    contentText:
        "Filosofi dasar yang mengikat masyarakat Minang adalah \"Adat Basandi Syarak, Syarak Basandi Kitabullah\" (ABS-SBK). Prinsip ini berarti Adat berdiri di atas Syariat Islam, dan Syariat Islam berdiri di atas Kitabullah (Al-Qur'an). Prinsip ini adalah penegas bahwa sejak Islam masuk, hukum adat tidak boleh bertentangan dengan ajaran agama.\n\n" +
        "ABS-SBK bukan sekadar slogan, melainkan revolusi budaya besar yang terjadi pada abad ke-19, terutama pasca Perang Padri. Sebelumnya, ada beberapa tradisi yang bertentangan dengan Islam (adat nan kawi). Konsensus ini berhasil menyelaraskan norma-norma sosial dengan nilai-nilai agama, menciptakan identitas Minangkabau yang unik sebagai masyarakat matrilineal yang religius.\n\n" +
        "Harmonisasi ini melahirkan struktur kepemimpinan Tiga Tungku Sejarangan atau Empat Tungku yang mencakup Niniak Mamak (pemangku adat), Alim Ulama (penegak syarak), dan Cadiak Pandai (cendekiawan/intelektual). Ketiga elemen ini wajib bekerja sama dan saling menasihati untuk menjaga keadilan dan kesejahteraan masyarakat dalam Nagari.\n\n" +
        "Penerapan ABS-SBK terlihat dalam semua aspek kehidupan, mulai dari musyawarah, pernikahan, hingga pembangunan Rumah Gadang. Contohnya, tata krama adat dalam berpakaian dan berbicara harus sesuai dengan etika Islam. Dengan demikian, adat berfungsi sebagai pembungkus budaya, sementara Islam menjadi intinya, memastikan moralitas dan spiritualitas tetap terjaga di tengah sistem kekerabatan yang kompleks.",
  ),
  ModuleContent(
    title: 'Siapa Itu Bundo Kanduang?',
    duration: '09:40',
    contentTitle: 'Peran Sentral Wanita dalam Keluarga Adat',
    contentText:
        "Bundo Kanduang secara harfiah berarti \"Ibu Kandung\" atau \"Ibu Sejati,\" tetapi dalam konteks adat, ia adalah gelar kehormatan yang diberikan kepada wanita yang telah matang, bijaksana, dan memegang peran sebagai pemimpin spiritual di dalam kaumnya. Bundo Kanduang adalah simbol martabat kaum, penjaga moralitas, dan penentu kebijakan internal rumah tangga yang berkaitan dengan adat dan tradisi.\n\n" +
        "Peran Bundo Kanduang sangat sentral karena ia adalah pemegang kunci kepemilikan atas harta pusaka tinggi, termasuk Rumah Gadang. Meskipun ia tidak dapat menjual aset tersebut, ia memiliki wewenang penuh dalam mengelola dan mendistribusikan manfaat dari harta tersebut kepada anggota kaumnya. Keputusannya dalam urusan rumah tangga dan pengelolaan aset warisan harus dihormati oleh semua anggota kaum, termasuk suaminya dan Niniak Mamak.\n\n" +
        "Dalam konteks kepemimpinan, Bundo Kanduang berfungsi sebagai mitra dari Niniak Mamak (saudara laki-laki dari pihak ibu). Sementara Niniak Mamak mewakili kaum di ruang publik, musyawarah nagari, dan penyelesaian sengketa, Bundo Kanduang bertanggung jawab atas pendidikan karakter dan adat di dalam rumah tangga. Filosofi menyebutkan, \"Laki-laki mencari dan mengatur di luar, perempuan merawat dan mendidik di dalam,\" yang menekankan pembagian tugas yang saling melengkapi.\n\n" +
        "Kedudukan Bundo Kanduang memperkuat sistem Matrilineal, memastikan bahwa nilai-nilai adat dan agama diajarkan secara efektif dari generasi ke generasi. Ia adalah orang pertama yang mendidik anak-anak (termasuk calon pemimpin adat) tentang adat basandi syarak (adat berdasarkan syariat). Kehadirannya adalah penjamin bahwa identitas kaum akan terus berlanjut, menjadikannya figur yang sangat dihormati dan diutamakan dalam setiap aspek kehidupan adat Minangkabau.",
  ),

  // --- QUIZ (Indeks 5) ---
  ModuleContent(
    title: 'Quiz Modul 1 & 2',
    duration: '00:00',
    contentTitle: 'Uji Pemahaman: Struktur Sosial dan Peran Adat',
    contentText:
        'Ayo uji pemahaman Anda mengenai sistem matrilineal, Suku, Bundo Kanduang, dan Niniak Mamak.',
    isQuiz: true,
  ),

  // --- MODUL 3: RUMAH GADANG (Indeks 6, 7, 8) ---
  ModuleContent(
    title: 'Niniak Mamak: Fungsi Adat',
    duration: '08:25',
    contentTitle: 'Pemimpin Adat dan Pengambil Keputusan',
    contentText:
        "Niniak Mamak adalah gelar kolektif untuk semua paman dari pihak ibu (saudara laki-laki Bundo Kanduang) yang memimpin kaum. Mereka adalah pemimpin resmi kaum dan Datuak, yaitu pemangku adat yang memegang gelar kebesaran. Niniak Mamak bertanggung jawab penuh atas urusan adat, penyelesaian sengketa, dan mewakili kaum dalam musyawarah nagari (desa adat).\n\n" +
        "Peran utama Niniak Mamak adalah menjaga dan memastikan hukum adat ditegakkan. Mereka bertindak sebagai mediator dan hakim, menyelesaikan masalah-masalah internal kaum atau sengketa antar-kaum. Mereka juga menjadi penasihat bagi kemenakan (anak dari saudara perempuan) mereka, membimbing mereka dalam bersikap dan bertindak sesuai norma adat Minangkabau.\n\n" +
        "Secara filosofis, Niniak Mamak adalah \"pemegang tali\" yang menghubungkan kaum dengan dunia luar. Mereka mewakili suara kaum di ranah publik, terutama dalam sistem kepemimpinan Kerapatan Adat Nagari (KAN). Tanggung jawab ini menuntut mereka untuk memiliki pengetahuan adat yang mendalam, kearifan, dan kemampuan berdiplomasi yang tinggi.\n\n" +
        "Walaupun Bundo Kanduang mengelola harta pusaka, Niniak Mamak adalah yang memiliki wewenang untuk mengambil keputusan strategis terkait aset kaum (misalnya, menyewakan tanah pusaka untuk keperluan adat) setelah bermusyawarah dengan Bundo Kanduang dan anggota kaum. Sinergi antara Niniak Mamak (pemimpin di ranah publik) dan Bundo Kanduang (pemimpin di ranah domestik) adalah kunci keseimbangan kepemimpinan dalam Matrilineal Minangkabau.",
  ),
  ModuleContent(
    title: 'Atap Gonjong dan Maknanya',
    duration: '11:00',
    contentTitle: 'Filosofi Atap Bertanduk Kerbau',
    contentText:
        "Atap gonjong (melengkung tajam ke atas seperti tanduk kerbau) adalah ciri khas arsitektur Rumah Gadang yang paling ikonik. Bentuknya yang khas tidak hanya estetika, tetapi mengandung filosofi mendalam yang terhubung dengan legenda asal nama Minangkabau, yakni kemenangan kerbau.\n\n" +
        "Secara filosofis, bentuk gonjong melambangkan falsafah \"Manjauah ka Langik, Mairik ka Bumi\" (Menjauh ke Langit, Menghimpit ke Bumi). Ini melambangkan ketinggian cita-cita dan ketaatan kepada Tuhan, bahwa meskipun mengejar kemakmuran, masyarakat Minang harus selalu menunduk dan berpijak pada syariat dan adat yang berlaku. Lengkungan atap yang mirip perahu juga melambangkan bahtera yang membawa kaum menuju masa depan yang lebih baik.\n\n" +
        "Material dan konstruksi atap juga memiliki makna simbolis. Pada masa lalu, atap Gonjong sering dibuat dari ijuk yang tebal, memastikan daya tahan terhadap cuaca dan melambangkan kekokohan adat yang melindungi seluruh kaum di dalamnya. Jumlah gonjong pada Rumah Gadang bisa bervariasi, dan ini seringkali mencerminkan status sosial atau jumlah keluarga inti yang mendiami rumah tersebut.\n\n" +
        "Rumah Gadang dan Atap Gonjong adalah representasi fisik dari sistem sosial Minangkabau itu sendiri. Ia menghadap ke utara/selatan dan memiliki anjuang (tempat musyawarah) di bagian ujung. Setiap bagian arsitektur, mulai dari tiang hingga atap, berfungsi sebagai pengingat visual bagi penghuninya tentang hierarki adat, peran gender, dan nilai-nilai kolektif yang harus dijaga oleh kaum.",
  ),
  ModuleContent(
    title: 'Ukiran dan Simbolisme',
    duration: '12:30',
    contentTitle: 'Pesan Moral dalam Seni Ukir Dinding',
    contentText:
        "Hampir seluruh dinding luar Rumah Gadang dihiasi ukiran bermotif flora dan fauna yang sangat detail dan berwarna cerah. Motif-motif ini tidak sekadar dekorasi, melainkan menyimpan pesan moral, ajaran adat, dan kearifan lokal yang berfungsi sebagai ensiklopedia visual bagi penghuninya. Setiap ukiran adalah pepatah yang dibentuk dalam visual.\n\n" +
        "Ukiran tradisional Minangkabau didominasi oleh motif-motif alam, seperti **Pucuak Rabuang** (tunas bambu), yang melambangkan harapan pertumbuhan yang berkelanjutan dan kearifan untuk mengambil manfaat dari alam. Ada pula motif **Itiak Pulang Patang** (itik pulang sore), yang melambangkan kebersamaan dan keteraturan dalam kaum, di mana semua anggota harus pulang ke rumah (kaum) pada waktunya.\n\n" +
        "Warna yang digunakan dalam ukiran sangat simbolis. Warna merah melambangkan keberanian dan kepandaian, warna hitam melambangkan kepemimpinan dan keteguhan adat, sementara warna kuning keemasan melambangkan keagungan dan kekayaan. Kombinasi warna ini menunjukkan tiga nilai utama yang harus dijunjung tinggi oleh masyarakat Minangkabau.\n\n" +
        "Fungsi ukiran melampaui estetika. Posisinya yang dipahat di bagian luar rumah bertujuan untuk mengedukasi masyarakat luas dan tamu yang datang. Setiap dinding, tiang, dan balok dihiasi dengan motif yang berbeda, menceritakan kisah tentang sejarah kaum, peraturan yang berlaku, dan bagaimana seharusnya seseorang hidup harmonis sesuai dengan Adat Basandi Syarak.",
  ),

  // --- MODUL 4: UPACARA ADAT (Indeks 9, 10, 11) ---
  ModuleContent(
    title: 'Struktur Ruangan dan Fungsinya',
    duration: '09:15',
    contentTitle: 'Ruang Komunal dan Peran Anggota Keluarga',
    contentText:
        "Rumah Gadang bukan hanya tempat tinggal pribadi, melainkan pusat komunal atau rumah induk bagi seluruh anggota kaum. Fungsinya mencakup tempat tinggal, ruang musyawarah, dan lokasi upacara adat. Tata letak ruangan diatur secara ketat berdasarkan adat, mencerminkan hierarki dan peran anggota keluarga.\n\n" +
        "Pembagian ruang utama terdiri dari **Laras** (ruang tengah) yang berfungsi sebagai ruang umum untuk berkumpul dan musyawarah, serta **Bilik** (kamar tidur). Yang unik adalah penempatan Bilik; kamar tidur disediakan untuk wanita yang sudah menikah dan anak-anak mereka. Laki-laki, termasuk suami dari wanita penghuni Bilik, tidak memiliki kamar pribadi di Rumah Gadang, melambangkan peran suami sebagai \"tamu\" bagi kaum istrinya.\n\n" +
        "Di bagian ujung rumah sering terdapat **Anjuang**, yaitu panggung yang ditinggikan. Anjuang ini adalah tempat Niniak Mamak dan Bundo Kanduang duduk saat musyawarah atau upacara adat, menandakan status mereka sebagai pemimpin. Di sisi lain, *Dapur* dan *Lumbuang Padi* (tempat penyimpanan padi) diletakkan terpisah atau di bagian belakang, menekankan pentingnya lumbung sebagai simbol kemakmuran kaum.\n\n" +
        "Struktur ini secara fisik mengukuhkan sistem matrilineal. Karena perempuan yang sudah menikah tinggal di Bilik bersama anak-anaknya, ini memastikan bahwa anak-anak selalu berada di bawah perlindungan dan didikan kaum ibu, dan harta pusaka (Rumah Gadang) selalu dijaga oleh para pewaris sahnya. Filosofi di balik struktur ini adalah kolektivisme, di mana privasi diutamakan hanya untuk kaum perempuan yang memiliki peran strategis.",
  ),
  ModuleContent(
    title: 'Tahapan Pra-Pernikahan',
    duration: '07:55',
    contentTitle: 'Maresek dan Manjapuik Marapulai',
    contentText:
        "Pernikahan Minangkabau adalah proses adat yang panjang dan detail, yang secara unik dimulai dengan inisiatif dari pihak wanita. Tahap pertama adalah **Maresek**, yaitu proses penjajakan dan penyelidikan yang dilakukan oleh utusan keluarga wanita. Mereka mendatangi keluarga pria untuk melihat bibit, bebet, dan bobot calon pengantin pria, serta memastikan adanya kesesuaian suku dan garis keturunan.\n\n" +
        "Setelah Maresek berhasil dan kesepakatan awal dicapai, barulah diikuti tahap-tahap penentuan mahar, janji adat, dan tanggal pernikahan. Semua proses ini dilakukan dengan musyawarah antara kedua kaum dan disaksikan oleh Niniak Mamak dari kedua belah pihak. Seluruh proses ini sangat formal dan bertujuan untuk menyatukan bukan hanya dua individu, tetapi dua kaum besar.\n\n" +
        "Salah satu tahapan paling ikonik dan menegaskan peran sentral wanita dalam adat adalah **Manjapuik Marapulai** (Menjemput Pengantin Pria). Pada hari pernikahan, rombongan besar keluarga wanita secara resmi pergi ke rumah calon pengantin pria untuk menjemputnya. Pria tersebut kemudian dibawa ke Rumah Gadang istrinya untuk memulai hidup baru.\n\n" +
        "Proses Manjapuik Marapulai adalah simbol penyerahan tanggung jawab seorang pria dari Mamak-nya (paman dari pihak ibu) kepada kaum istrinya, yang diwakili oleh Bundo Kanduang. Meskipun pria menjadi kepala rumah tangga di keluarganya sendiri, ia tetap dihormati sebagai *sumando* (menantu) yang harus memuliakan kaum istrinya. Prosesi ini menunjukkan bahwa dalam pernikahan, pihak wanita memiliki peran aktif yang dominan.",
  ),

  ModuleContent(
    title: 'Adat Baralek (Pesta)',
    duration: '08:50',
    contentTitle: 'Jamuan Besar dan Ritual Adat',
    contentText:
        "Pesta pernikahan, atau *Baralek*, adalah puncak dari rangkaian upacara perkawinan Minangkabau. Ini adalah acara besar yang melibatkan tidak hanya kedua kaum yang menikah, tetapi juga seluruh Nagari (desa adat). Baralek berfungsi sebagai wujud syukuran, sosialisasi, dan pengukuhan ikatan persaudaraan antar-kaum.\n\n" +
        "Baralek dikenal dengan kemewahan dan keramaiannya, diisi dengan jamuan makan besar dan pertunjukan kesenian tradisional seperti Tari Piring, Gandang Tasa, dan Saluang. Logistik Baralek menuntut kegotongroyongan yang luar biasa, di mana anggota kaum, tetangga, dan suku-suku lain ikut membantu dalam persiapan, memasak, dan melayani tamu. Hal ini menunjukkan betapa kuatnya sistem sosial komunal di Minangkabau.\n\n" +
        "Salah satu ritual penting selama Baralek adalah *Makan Bajamba*, yaitu makan bersama dalam wadah besar secara adat. Makan Bajamba melambangkan kebersamaan, persatuan, dan persamaan derajat semua anggota masyarakat yang hadir, terlepas dari status mereka. Ini menunjukkan filosofi keadilan dalam adat Minangkabau.\n\n" +
        "Baralek tidak hanya sekadar pesta, tetapi juga penegasan status sosial. Selama Baralek, gelar adat (Datuak) dapat dikukuhkan, atau harta pusaka tertentu diumumkan secara resmi. Pesta ini adalah media komunikasi adat yang memastikan semua pihak mengetahui status baru pengantin, serta menunjukkan kemuliaan dan kemampuan kaum dalam menyelenggarakan acara adat.",
  ),

  // --- FINAL ASSESSMENT (Indeks 12) ---
  ModuleContent(
    title: 'Final Assessment',
    duration: '00:00',
    contentTitle: 'Ujian Akhir Kursus',
    contentText:
        'Selamat! Anda telah menyelesaikan seluruh materi. Sekarang saatnya membuktikan penguasaan Anda atas Filosofi Adat dan Rumah Gadang Minangkabau.',
    isQuiz: true,
  ),
];