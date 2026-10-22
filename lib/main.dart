import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------- Konstanta ----------
const String namaApp = 'Perpustakaan Online'; // String
const double radiusKartu = 16; // double
const double lebarMaks = 1000; // double
const Color warnaUtama = Color(0xFF7B1E3A);
const List<String> daftarKategori = ['Semua', 'Novel', 'Sastra', 'Pengembangan Diri'];

// ---------- Model ----------
class Buku {
  final String judul;
  final String penulis;
  final String kategori;
  final String sinopsis;
  final int tahun; // int
  final double rating;
  final bool tersedia; // bool
  final Color warna;

  const Buku({
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.sinopsis,
    required this.tahun,
    required this.rating,
    required this.tersedia,
    required this.warna,
  });
}

class Anggota {
  final String nama;
  final String nim;
  final int jumlahPinjam;

  const Anggota({required this.nama, required this.nim, required this.jumlahPinjam});
}

// Object berisi data sendiri
const Anggota anggotaSaya = Anggota(
  nama: 'Ni Nyoman Sutriani',
  nim: '202432037',
  jumlahPinjam: 1,
);

const List<Buku> daftarBuku = [
  Buku(
    judul: 'Laskar Pelangi',
    penulis: 'Andrea Hirata',
    kategori: 'Novel',
    sinopsis: 'Kisah sepuluh anak di Belitung yang berjuang menamatkan sekolah dengan semangat dan persahabatan.',
    tahun: 2005,
    rating: 4.6,
    tersedia: true,
    warna: Color(0xFF3949AB),
  ),
  Buku(
    judul: 'Bumi Manusia',
    penulis: 'Pramoedya Ananta Toer',
    kategori: 'Sastra',
    sinopsis: 'Perjalanan Minke, seorang pribumi terpelajar, menghadapi ketidakadilan di masa kolonial.',
    tahun: 1980,
    rating: 4.8,
    tersedia: false,
    warna: Color(0xFF00695C),
  ),
  Buku(
    judul: 'Laut Bercerita',
    penulis: 'Leila S. Chudori',
    kategori: 'Novel',
    sinopsis: 'Novel tentang aktivis mahasiswa, persahabatan, dan keluarga yang menunggu kepulangan.',
    tahun: 2017,
    rating: 4.7,
    tersedia: true,
    warna: Color(0xFF6A1B9A),
  ),
  Buku(
    judul: 'Filosofi Teras',
    penulis: 'Henry Manampiring',
    kategori: 'Pengembangan Diri',
    sinopsis: 'Pengantar filsafat Stoa untuk menghadapi emosi negatif dan stres sehari-hari.',
    tahun: 2018,
    rating: 4.5,
    tersedia: true,
    warna: Color(0xFFBF6B04),
  ),
];

// ---------- Root: satu-satunya MaterialApp ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: namaApp,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: warnaUtama),
        scaffoldBackgroundColor: const Color(0xFFFFF8F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8F6),
          foregroundColor: warnaUtama,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: warnaUtama,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ---------- Halaman utama: Scaffold tanpa MaterialApp ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String kataKunci = '';
  String kategoriDipilih = 'Semua';

  void _pinjam(Buku buku) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Berhasil meminjam ${buku.judul}'),
      ),
    );
  }

  void _bukaDetail(Buku buku) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(buku: buku, onPinjam: () => _pinjam(buku)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int total = daftarBuku.length;
    final int tersedia = daftarBuku.where((b) => b.tersedia).length;
    final String q = kataKunci.toLowerCase();

    final List<Buku> hasil = daftarBuku.where((b) {
      final bool cocokKategori = kategoriDipilih == 'Semua' || b.kategori == kategoriDipilih;
      final bool cocokKata = b.judul.toLowerCase().contains(q) || b.penulis.toLowerCase().contains(q);
      return cocokKategori && cocokKata;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_library),
            SizedBox(width: 8),
            Text(namaApp, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: lebarMaks),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              KartuRingkasan(anggota: anggotaSaya, total: total, tersedia: tersedia),
              const SizedBox(height: 20),
              TextField(
                onChanged: (v) => setState(() => kataKunci = v),
                decoration: InputDecoration(
                  hintText: 'Cari judul atau penulis',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radiusKartu),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: daftarKategori
                      .map(
                        (k) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(k),
                            selected: kategoriDipilih == k,
                            onSelected: (_) => setState(() => kategoriDipilih = k),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Koleksi Buku',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('${hasil.length} buku'),
                ],
              ),
              const SizedBox(height: 12),
              if (hasil.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Buku tidak ditemukan'),
                    ],
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, c) {
                    const double jarak = 12;
                    final int kolom = c.maxWidth >= 900 ? 3 : (c.maxWidth >= 600 ? 2 : 1);
                    final double lebar = (c.maxWidth - jarak * (kolom - 1)) / kolom;

                    return Wrap(
                      spacing: jarak,
                      runSpacing: jarak,
                      children: hasil
                          .map(
                            (b) => SizedBox(
                              width: lebar,
                              child: KartuBuku(
                                buku: b,
                                onPinjam: () => _pinjam(b),
                                onTap: () => _bukaDetail(b),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Custom widget 1: kartu ringkasan ----------
class KartuRingkasan extends StatelessWidget {
  const KartuRingkasan({
    super.key,
    required this.anggota,
    required this.total,
    required this.tersedia,
  });

  final Anggota anggota;
  final int total;
  final int tersedia;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [warnaUtama, Color(0xFFB4435F)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(46),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selamat datang,', style: TextStyle(color: Colors.white70)),
                    Text(
                      anggota.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'NIM ${anggota.nim}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Statistik(ikon: Icons.collections_bookmark, label: 'Koleksi', nilai: '$total')),
              const SizedBox(width: 8),
              Expanded(child: _Statistik(ikon: Icons.check_circle_outline, label: 'Tersedia', nilai: '$tersedia')),
              const SizedBox(width: 8),
              Expanded(child: _Statistik(ikon: Icons.bookmark_added, label: 'Dipinjam', nilai: '${anggota.jumlahPinjam}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Statistik extends StatelessWidget {
  const _Statistik({required this.ikon, required this.label, required this.nilai});

  final IconData ikon;
  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(ikon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(nilai, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ---------- Custom widget 2: sampul buku ----------
class SampulBuku extends StatelessWidget {
  const SampulBuku({super.key, required this.warna, required this.lebar, required this.tinggi});

  final Color warna;
  final double lebar;
  final double tinggi;

  @override
  Widget build(BuildContext context) {
    final Color gelap = Color.lerp(warna, Colors.black, 0.35)!;

    return Container(
      width: lebar,
      height: tinggi,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [warna, gelap],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Icon(Icons.auto_stories, color: Colors.white, size: lebar * 0.45),
    );
  }
}

// ---------- Custom widget 3: label status ----------
class LabelStatus extends StatelessWidget {
  const LabelStatus({super.key, required this.tersedia});

  final bool tersedia;

  @override
  Widget build(BuildContext context) {
    final Color warnaTeks = tersedia ? const Color(0xFF1B7F4B) : const Color(0xFFC0392B);
    final Color warnaLatar = tersedia ? const Color(0xFFE0F2E9) : const Color(0xFFFDE7E7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tersedia ? 'Tersedia' : 'Dipinjam',
        style: TextStyle(color: warnaTeks, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ---------- Custom widget 4: kartu buku ----------
class KartuBuku extends StatelessWidget {
  const KartuBuku({
    super.key,
    required this.buku,
    required this.onPinjam,
    required this.onTap,
  });

  final Buku buku;
  final VoidCallback onPinjam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusKartu),
        side: BorderSide(color: warna.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SampulBuku(warna: buku.warna, lebar: 80, tinggi: 112),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buku.kategori.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: warna.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      buku.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      buku.penulis,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text('${buku.rating} • ${buku.tahun}'),
                          ],
                        ),
                        LabelStatus(tersedia: buku.tersedia),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: buku.tersedia ? onPinjam : null,
                      child: Text(buku.tersedia ? 'Pinjam' : 'Tidak tersedia'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Halaman detail buku ----------
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.buku, required this.onPinjam});

  final Buku buku;
  final VoidCallback onPinjam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: SampulBuku(warna: buku.warna, lebar: 150, tinggi: 210)),
                const SizedBox(height: 20),
                Text(
                  buku.judul,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(buku.penulis, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(label: Text(buku.kategori)),
                    Chip(avatar: const Icon(Icons.calendar_today, size: 16), label: Text('${buku.tahun}')),
                    Chip(avatar: const Icon(Icons.star, size: 16, color: Colors.amber), label: Text('${buku.rating}')),
                    LabelStatus(tersedia: buku.tersedia),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Sinopsis', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(buku.sinopsis, style: const TextStyle(height: 1.5)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: buku.tersedia ? onPinjam : null,
                    child: Text(buku.tersedia ? 'Pinjam Buku' : 'Tidak Tersedia'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}