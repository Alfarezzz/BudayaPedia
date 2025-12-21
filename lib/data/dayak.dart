// lib/data/dayak.dart

// Wajib: Import Model Content dari file tunggal
import '../pages/module_content_model.dart';

// Data Kursus "Manik-Manik dan Busana Adat Suku Dayak"
final List<ModuleContent> dayakModules = [
  // --- INDEKS 0: PENGANTAR ---
  ModuleContent(
    title: 'COURSE OVERVIEW',
    duration: '03:00',
    contentTitle: 'Pengantar Budaya Material Suku Dayak',
    contentText:
        """Kursus ini berfokus pada eksplorasi budaya material Suku Dayak di Kalimantan, terutama sub-suku Dayak Kenyah, Kayan, dan Maloh. Kita akan mendalami bagaimana seni kriya, khususnya manik-manik dan ukiran, berfungsi sebagai penanda identitas, kekayaan, status sosial, bahkan sebagai media komunikasi dengan dunia spiritual.

Manik-manik (Lue) dan busana adat Dayak bukan sekadar pakaian atau perhiasan. Mereka adalah benda pusaka yang menceritakan sejarah, mitologi, dan kearifan lokal. Beberapa manik kuno (Manik Lawas) bahkan dianggap memiliki "roh" dan nilai tukar yang sangat tinggi di masa lalu, setara dengan properti berharga lainnya.

Selain manik, kita akan mengulas filosofi di balik Busana Adat yang terbuat dari kulit kayu, seperti King Baba (pria) dan King Bibinge (wanita), serta senjata khas seperti Mandau. Ini menunjukkan kehebatan teknologi tekstil primitif yang ramah lingkungan dan sepenuhnya memanfaatkan alam.

Pada akhir kursus, Anda akan memahami bahwa setiap pola, warna, dan material dalam Busana Adat Dayak memegang makna yang mendalam, mencerminkan pandangan hidup mereka yang harmonis dengan alam dan kepercayaan kepada roh leluhur (dunia atas dan dunia bawah).""",
  ),

  // --- MODUL 1: FILOSOFI MANIK-MANIK (Indeks 1, 2) ---
  ModuleContent(
    title: 'Makna Manik-Manik',
    duration: '09:00',
    contentTitle: 'Manik-Manik: Kekayaan, Status, dan Spiritualitas',
    contentText:
        """Bagi Suku Dayak, manik-manik (Lue) adalah benda pusaka yang memiliki nilai spiritual dan sosial yang sangat tinggi, melampaui sekadar hiasan. Manik-manik kuno (Manik Lawas atau Manik Lukut) yang terbuat dari batu, kaca, atau keramik, masuk ke Kalimantan melalui jalur perdagangan ribuan tahun lalu. Manik lawas ini menjadi simbol kekayaan tertinggi, sering digunakan sebagai mahar atau denda adat.

Nilai dari manik-manik ditentukan oleh kualitas, usia, dan riwayat pewarisannya. Kualitas, warna, dan pola pada manik juga menunjukkan status sosial dan asal-usul klan seseorang. Misalnya, pada masa lalu, motif utuh seperti wajah manusia atau harimau hanya diizinkan dipakai oleh kaum bangsawan (Paren), sementara rakyat biasa (Panyen) hanya boleh memakai motif geometris atau flora.

Manik-manik juga memiliki fungsi ritual yang mendalam. Ia digunakan dalam upacara penyembuhan (Balian), sebagai bekal kubur agar roh lancar menuju alam baka, dan yang terpenting, sebagai penolak bala atau jimat perlindungan. Kepercayaan bahwa manik-manik membawa roh atau kekuatan magis membuatnya menjadi warisan yang harus dijaga dengan hati-hati.

Setiap untaian manik Dayak wajib mengandung Simbolisme "Lima Warna Kehidupan". Merah melambangkan keberanian dan tenaga (maskulin), Kuning melambangkan keagungan dan kemakmuran (bangsawan), Hitam melambangkan kerahasiaan alam gaib dan keteguhan hati, Putih melambangkan kesucian, dan Hijau melambangkan kesuburan dan pertumbuhan.""",
  ),
  ModuleContent(
    title: 'Teknik Merangkai Dasar',
    duration: '07:30',
    contentTitle: 'Teknik Merangkai dan Pola Geometris',
    contentText:
        """Seni merangkai manik (beadwork) Suku Dayak membutuhkan kombinasi antara ketelitian, kesabaran, dan apa yang bisa disebut "matematika visual". Teknik ini bertujuan mengubah manik-manik butiran menjadi lembaran kain manik yang rapat dan kaku namun tetap memiliki kelenturan.

Teknik utama yang digunakan adalah **Anyam Silang**. Proses ini memanfaatkan benang kuat (tradisionalnya serat nanas, kini sering menggunakan nilon) untuk mengunci setiap manik. Pengrajin senior seringkali tidak menggunakan pola tertulis di kertas; mereka menghafal urutan warna dan jumlah butir manik untuk menciptakan pola geometris yang kompleks di kepala mereka (memory-based).

Pola geometris yang diciptakan mewakili elemen-elemen penting dalam mitologi Dayak. Pola yang paling sakral adalah **Aso** (Naga/Anjing mitologi) dan **Burung Enggang** (Rangkong). Pola-pola ini tidak hanya berfungsi sebagai estetika tetapi sebagai simbol spiritual yang membawa perlindungan.

Salah satu mahakarya seni manik yang memadukan teknik dan filosofi adalah **Ba** (gendongan bayi). Bagian punggung gendongan ini dilapisi manik-manik penuh dengan motif Udoq (topeng seram) atau Aso. Motif yang "menakutkan" ini bertujuan untuk mengusir roh jahat yang diyakini rentan mengganggu jiwa bayi saat dibawa keluar rumah (ke ladang atau hutan).""",
  ),

  // --- MODUL 2: BUSANA TRADISIONAL (Indeks 3, 4) ---
  ModuleContent(
    title: 'Busana King Baba',
    duration: '10:45',
    contentTitle: 'Pakaian Adat Pria: King Baba dan Perisai',
    contentText:
        """Pakaian adat pria Dayak dikenal sebagai **King Baba**, yang secara harfiah berarti "Baju Bapak" atau "Baju Laki-laki". Busana ini melambangkan keberanian, ketangguhan, dan kedekatan pria Dayak dengan alam hutan. King Baba dibuat dari kulit kayu, khususnya kulit dalam (bast) dari pohon jenis Artocarpus (seperti Kapuo atau Ampuro).

Proses pembuatan kulit kayu menjadi kain sangat unik dan merupakan teknologi tekstil kuno yang luar biasa. Kulit kayu dilepas, dipisahkan dari kulit luar, lalu dipukul ribuan kali menggunakan alat pemukul bergerigi (Panggah atau Sida). Proses pemukulan ini memecah serat, membuat kulit menjadi lunak dan melebar hingga tiga kali lipat. Kain kulit ini kemudian diwarnai menggunakan pewarna alami, seperti buah jernang (merah darah).

King Baba umumnya berbentuk rompi tanpa lengan, dipadukan dengan cawat (Avet). Busana ini selalu dilengkapi dengan aksesoris wajib yang melambangkan status ksatria: Mandau (senjata keramat) dan Perisai (Talawang). Perisai ini juga dihiasi ukiran Aso atau wajah seram untuk memberikan perlindungan spiritual dalam pertempuran.

Busana King Baba mencerminkan peran tradisional laki-laki sebagai pelindung suku, pemburu, dan penegak adat. Meskipun sederhana secara desain, materialnya sangat kuat dan ramah lingkungan, menegaskan kearifan lokal Suku Dayak dalam memanfaatkan sumber daya hutan secara berkelanjutan.""",
  ),
  ModuleContent(
    title: 'Busana King Bibinge',
    duration: '08:20',
    contentTitle: 'Pakaian Adat Wanita: King Bibinge',
    contentText:
        """Pakaian wanita Dayak disebut **King Bibinge**, atau "Baju Ibu". Berbeda dengan King Baba yang fokus pada ketangguhan material, King Bibinge memiliki penekanan lebih pada kekayaan hiasan dan simbolisme kemuliaan serta kesuburan wanita.

Seperti King Baba, King Bibinge juga dibuat dari kulit kayu yang diproses menggunakan teknik Sida (pemukulan). Namun, busana ini kemudian dihiasi secara intensif dengan tempelan manik-manik, biji-bijian, uang logam kuno, atau sulaman benang. Hiasan manik-manik pada King Bibinge jauh lebih kaya dan kompleks, menegaskan status wanita sebagai pewaris dan penjaga harta pusaka.

Aksesoris yang wajib melengkapi King Bibinge adalah topi manik (Tangkuluk) dan kalung manik yang panjang dan berat (Uleng). Kalung yang berat ini juga berfungsi sebagai simbol kesabaran dan martabat. Busana ini menunjukkan bahwa wanita Dayak memiliki kedudukan terhormat sebagai pusat kaum dan penjaga kehidupan.

King Bibinge kini sering dipakai dalam upacara adat besar, seperti Gawai Dayak atau pernikahan. Busana ini secara keseluruhan melambangkan keindahan, kesuburan, dan martabat wanita Dayak sebagai Lue (manik) yang menjadi poros kekerabatan dan penentu garis keturunan dalam sistem adat Suku Dayak.""",
  ),

  // --- QUIZ MODUL 1 & 2 (Indeks 5) ---
  ModuleContent(
    title: 'Quiz Modul 1 & 2',
    duration: '00:00',
    contentTitle: 'Uji Pemahaman: Manik-Manik & Busana',
    contentText:
        'Uji pengetahuan Anda tentang status manik-manik, pola *Aso*, dan perbedaan busana King Baba/King Bibinge.',
    isQuiz: true,
  ),

  // --- MODUL 3: UKIRAN DAN SIMBOLISME (Indeks 6, 7) ---
  ModuleContent(
    title: 'Ukiran Kayu (Pamat)',
    duration: '11:00',
    contentTitle: 'Filosofi Ukiran Kayu (Pamat) Dayak',
    contentText:
        """Ukiran kayu Suku Dayak, atau *Pamat*, adalah seni visual yang sarat akan simbolisme magis dan berfungsi sebagai narasi visual dari kepercayaan mereka. Ukiran ini dapat ditemukan pada berbagai benda, mulai dari tiang rumah adat (Lamin), perisai perang (Talawang), hingga peti mati. Tujuan utama ukiran adalah sebagai penolak bala (penangkal roh jahat) dan penanda sejarah kaum.

Motif ukiran didominasi oleh perwujudan makhluk mitologi, dengan pola naga/anjing (Aso) dan Burung Enggang (Rangkong) sebagai yang paling utama. Motif *Aso* melambangkan penguasa dunia bawah (air dan tanah), digambarkan dengan mulut terbuka dan taring. Keberadaan motif ini pada rumah atau perisai dipercaya sebagai Protektor Tertinggi.

Pada masa lalu, sama seperti manik-manik, motif ukiran juga diatur berdasarkan strata sosial. Hanya kaum bangsawan (Paren) yang diizinkan menggunakan ukiran rumit dan motif yang menggambarkan wajah utuh atau figur manusia. Pelanggaran terhadap aturan ini dianggap melanggar adat dan dapat dikenakan denda yang berat.

Ukiran Dayak, dengan kombinasi pola geometris, flora, dan fauna mitologis, adalah ekspresi nyata dari pandangan dunia Dayak yang menganggap alam semesta terbagi menjadi dunia atas, dunia tengah (manusia), dan dunia bawah. Setiap ukiran adalah jembatan yang menghubungkan manusia dengan kekuatan alam dan spiritualitas leluhur.""",
  ),
  ModuleContent(
    title: 'Simbol Burung Enggang',
    duration: '07:15',
    contentTitle: 'Burung Enggang: Simbol Keagungan',
    contentText:
        """Burung Enggang (Rangkong) adalah salah satu simbol paling keramat dan agung dalam kebudayaan Suku Dayak, sering disebut sebagai "Burung Dewata". Enggang melambangkan penguasa dunia atas (langit) dan berfungsi sebagai jembatan komunikasi antara manusia dengan Tuhan (Dewata) serta roh leluhur.

Keagungan burung Enggang terlihat dari ukuran tubuhnya yang besar, sayapnya yang lebar, dan paruhnya yang unik. Simbolisme ini diterjemahkan menjadi makna kepemimpinan, kearifan, dan kebesaran jiwa. Bulu-bulu burung enggang, khususnya, sering disematkan pada topi adat, hiasan kepala, atau gagang pedang Mandau sebagai penanda bahwa pemakainya memiliki kedudukan tinggi, berani, atau memiliki hubungan spiritual yang kuat.

Bentuk sayap burung Enggang yang melebar saat terbang melambangkan persatuan dan keterbukaan masyarakat Dayak. Paruhnya yang besar melambangkan kekuatan dan ketegasan dalam berbicara. Oleh karena itu, penggunaan simbol Enggang dalam ritual dan busana adat bersifat sakral dan menunjukkan penghormatan yang sangat besar terhadap alam dan otoritas.

Meskipun kini perburuan Enggang dilarang keras untuk menjaga kelestarian, citra dan filosofi burung ini tetap menjadi inti dari identitas Dayak. Ia mengajarkan tentang pentingnya memelihara keseimbangan antara kehidupan di bumi dan penghormatan terhadap alam spiritual, menjadikannya simbol kebanggaan seluruh Suku Dayak.""",
  ),

  // --- MODUL 4: STUDI KASUS DAN PENUTUP (Indeks 8, 9, 10) ---
  ModuleContent(
    title: 'Studi Kasus: Tari Hudoq',
    duration: '09:40',
    contentTitle: 'Tari Hudoq: Tarian Ritual Kesuburan',
    contentText:
        """Tari Hudoq adalah salah satu tarian ritual Suku Dayak (terutama Dayak Bahau dan Kenyah) yang paling kuno dan dramatis. Tarian ini diyakini sebagai ritual utama untuk memohon kesuburan dan hasil panen yang melimpah dari roh-roh leluhur dan dewa-dewi pertanian. Tarian ini biasanya dilakukan setelah musim tanam padi, sebagai wujud syukur sekaligus permohonan agar tanaman dilindungi dari hama.

Ciri khas Tari Hudoq adalah penggunaan topeng (Hudoq) yang menakutkan dan terkadang menyerupai wajah binatang buas atau makhluk mitologi. Para penari, yang seringkali adalah laki-laki, mengenakan topeng dan busana dari serat pisang atau daun yang melambangkan roh-roh pelindung atau hama yang harus diusir. Gerakannya sangat energik dan ekspresif.

Filosofi di balik topeng yang menyeramkan adalah bahwa roh-roh pelindung harus memiliki kekuatan yang cukup untuk menakuti dan mengusir roh jahat (hama) yang mencoba mengganggu kesuburan ladang. Tarian ini adalah media komunikasi vertikal, menghubungkan komunitas manusia dengan alam gaib dan kekuatan di dunia atas.

Tari Hudoq menegaskan pentingnya siklus pertanian dan hubungan spiritual antara manusia Dayak dengan tanah. Melalui tarian ini, masyarakat Dayak menunjukkan kepatuhan mereka terhadap hukum alam dan leluhur, memastikan bahwa kehidupan komunal mereka tetap berlanjut dengan restu dari dunia atas.""",
  ),
  ModuleContent(
    title: 'Musik Adat dan Alatnya',
    duration: '06:50',
    contentTitle: 'Sampe dan Gong: Iringan Utama',
    contentText:
        """Musik memiliki peran vital dalam kehidupan ritual dan sosial Suku Dayak. Instrumen musik utama yang mendominasi adalah *Sampe* dan berbagai jenis Gong. Musik Dayak seringkali bersifat meditatif dan instrumental, dirancang untuk mengiringi tarian adat atau upacara penyembuhan.

**Sampe** adalah alat musik petik tradisional yang menyerupai gitar atau lute, terbuat dari kayu yang diukir indah dengan motif khas Dayak (seperti Enggang atau Aso). Sampe dimainkan dengan teknik petikan yang lembut hingga keras, menghasilkan melodi yang seringkali melankolis dan memanggil suasana spiritual. Sampe adalah representasi suara hati dan alam Dayak.

Gong digunakan dalam berbagai ukuran dan jenis, memberikan ritme dasar yang kuat untuk tarian dan upacara. Bunyi Gong yang berulang dan stabil berfungsi untuk menjaga tempo ritual dan membantu para penari atau Balian (dukun) memasuki kondisi trans. Kombinasi Sampe dan Gong menciptakan iringan yang unik dan otentik.

Musik ini, terutama yang dimainkan Sampe, sering digunakan untuk meninabobokan bayi di gendongan *Ba*, mengiringi Tari Hudoq, hingga mengiringi prosesi pemakaman. Musik adat Dayak adalah media transmisi budaya yang efektif, mengajarkan kisah-kisah leluhur dan menjaga ritme kehidupan komunal agar selaras dengan alam.""",
  ),

  ModuleContent(
    title: 'Final Assessment',
    duration: '00:00',
    contentTitle: 'Ujian Akhir Kursus Budaya Dayak',
    contentText:
        'Selamat! Anda telah menguasai budaya material dan spiritual Suku Dayak. Saatnya membuktikan pemahaman Anda dalam Ujian Akhir.',
    isQuiz: true,
  ),
];