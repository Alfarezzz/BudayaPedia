// lib/data/tari_keraton.dart (KODE FINAL YANG BENAR)

// >>> GANTI DEFINISI KELAS DENGAN IMPORT MODEL TUNGGAL INI <<<
import '../pages/module_content_model.dart';
// >>> END IMPORT MODEL <<<

// HAPUS DEFINISI LAMA CLASS MODULECONTENT DARI FILE INI!

// Data Kursus "Gerak Anggun Tari Klasik Keraton Jawa"
final List<ModuleContent> tariKeratonModules = [
  // --- INDEKS 0: PENGANTAR ---
  ModuleContent(
    title: 'COURSE OVERVIEW',
    duration: '03:30',
    contentTitle: 'Pengantar Tari Klasik Keraton Jawa',
    contentText:
        'Tari Klasik Keraton Jawa (Serimpi dan Bedhaya) adalah seni yang sangat sakral, melambangkan kehalusan budi, ketenangan, dan filosofi spiritual Jawa. Kursus ini akan mengeksplorasi setiap aspek, dari gerakan hingga busana.',
  ),

  // --- MODUL 1: FILOSOFI DAN PERAN (Indeks 1, 2) ---
  ModuleContent(
    title: 'Makna Filosofis Tarian',
    duration: '09:00',
    contentTitle: 'Kehalusan Budi: Gerak Estetik dan Simbolis',
    contentText:
        'Tari klasik Jawa bukan sekadar hiburan; ia adalah meditasi bergerak. Setiap gerakan tangan (*mudra*), kaki, dan kepala diatur sedemikian rupa untuk mencerminkan *sabar* (kesabaran), *nrima* (menerima), dan *tata krama* (etika). Tarian ini melambangkan pertarungan batin antara kebaikan dan keburukan.',
  ),
  ModuleContent(
    title: 'Perbedaan Bedhaya & Serimpi',
    duration: '08:15',
    contentTitle: 'Tari Sakral (Bedhaya) vs. Tarian Peringatan (Serimpi)',
    contentText:
        'Tari Bedhaya (biasanya 9 penari) sangat sakral, sering kali terkait dengan legenda spiritual dan hanya dipentaskan untuk upacara tertentu. Tari Serimpi (biasanya 4 penari) juga sakral, tetapi sering melambangkan pertarungan dua hal yang seimbang, seperti air dan api, atau Ratu Kidul dan Raja Mataram.',
  ),

  // --- MODUL 2: TEKNIK DASAR GERAKAN (Indeks 3, 4) ---
  ModuleContent(
    title: 'Posisi Dasar & Gerak Tangan',
    duration: '11:45',
    contentTitle: 'Sikap Dasar (*Sabet*) dan Gerakan Tangan (*Ukel*)',
    contentText:
        'Gerakan dasar Jawa disebut *Sabet* (dasar langkah kaki) dan *Ukel* (putar pergelangan tangan yang lembut). Kunci utamanya adalah *Lemes* (lentur) dan *Anteng* (tenang), memastikan seluruh tubuh bergerak lambat dengan kontrol penuh, seolah mengambang di udara.',
  ),
  ModuleContent(
    title: 'Pola Lantai dan Iringan',
    duration: '07:20',
    contentTitle: 'Formasi (*Gawang*) dan Peran Gamelan',
    contentText:
        'Pola lantai (disebut *Gawang*) sangat geometris dan lambat, mencerminkan ketertiban kosmos. Iringan Gamelan harus lembut (*Laras Pelog*) dengan tempo yang sangat lambat, dipimpin oleh suara Kendhang dan Rebana yang memberikan energi spiritual.',
  ),

  // --- QUIZ MODUL 1 & 2 (Indeks 5) ---
  ModuleContent(
    title: 'Quiz Modul 1 & 2',
    duration: '00:00',
    contentTitle: 'Uji Pemahaman: Filosofi dan Teknik Dasar Tari',
    contentText:
        'Uji pengetahuan Anda tentang makna Bedhaya, Serimpi, dan istilah gerakan dasar seperti Sabet dan Ukel.',
    isQuiz: true,
  ),

  // --- MODUL 3: BUSANA DAN ATRIBUT (Indeks 6, 7, 8) ---
  ModuleContent(
    title: 'Busana Bedhaya',
    duration: '10:00',
    contentTitle: 'Busana Dodot, Gelung, dan Selendang',
    contentText:
        'Busana Tari Bedhaya sangat minimalis dan tradisional, sering menggunakan kain *Dodot* (kain panjang yang dililit) dan *Gelung* (sanggul) yang sederhana. Warna busana mencerminkan kemurnian dan kekudusan. Penari harus mengenakan busana yang identik untuk melambangkan kesatuan spiritual.',
  ),
  ModuleContent(
    title: 'Aksesoris dan Makna',
    duration: '09:30',
    contentTitle: 'Simbolisme Perhiasan Emas dan Kembang',
    contentText:
        'Perhiasan yang digunakan (misalnya *anting-anting*, *gelang*) melambangkan kekayaan spiritual. Bunga (*Kembang*) yang diletakkan di sanggul sering memiliki makna tertentu, seperti melambangkan kesucian dan keindahan alam semesta.',
  ),
  ModuleContent(
    title: 'Tinjauan Kesenian',
    duration: '05:40',
    contentTitle: 'Pelestarian Tari Klasik Keraton di Era Modern',
    contentText:
        'Bagaimana Keraton Yogyakarta dan Surakarta terus melestarikan warisan ini, dan tantangan yang dihadapi oleh para penari muda (*Abdi Dalem*) dalam menjaga kemurnian tradisi.',
  ),

  // --- MODUL 4: STUDI KASUS DAN PENUTUP (Indeks 9, 10, 11) ---
  ModuleContent(
    title: 'Studi Kasus: Tari Serimpi',
    duration: '07:10',
    contentTitle: 'Analisis Gerakan Tari Serimpi (*Papat*)',
    contentText:
        'Analisis mendalam terhadap Tari Serimpi, di mana empat penari utama melambangkan empat penjuru mata angin atau empat elemen kehidupan (air, api, tanah, udara), bergerak dalam sinkronisasi yang sempurna.',
  ),
  ModuleContent(
    title: 'Etika Penari dan Penonton',
    duration: '06:20',
    contentTitle: 'Etika Kultural dalam Menghargai Tarian Sakral',
    contentText:
        'Tarian ini memiliki etika ketat; penari harus dalam kondisi suci, dan penonton diminta untuk menjaga ketenangan dan fokus karena tarian ini adalah ritual, bukan pertunjukan biasa.',
  ),

  ModuleContent(
    title: 'Final Assessment',
    duration: '00:00',
    contentTitle: 'Ujian Akhir Kursus Tari Klasik',
    contentText:
        'Selamat! Anda telah menguasai filosofi dan teknik dasar Tari Klasik Keraton Jawa. Saatnya membuktikan pemahaman Anda dalam Ujian Akhir.',
    isQuiz: true,
  ),
];