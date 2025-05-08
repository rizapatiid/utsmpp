import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:mahasiswa_stt/helper/api.dart'; 
import 'package:mahasiswa_stt/helper/database_helper.dart'; 
import 'package:mahasiswa_stt/page/mahasiswa.dart'; 

class Dashboard extends StatefulWidget {
  const Dashboard({super.key}); // Konstruktor Dashboard dengan key.

  @override
  State<Dashboard> createState() => _DashboardState(); // Membuat state untuk Dashboard.
}

class _DashboardState extends State<Dashboard> {
  List<Widget> mahasiswaList = []; // List untuk menyimpan widget mahasiswa.
  var quotes = "Jangan pernah menyerah pada impianmu, karena impian adalah kunci kesuksesan.",
      author = "Unknown"; // Variabel untuk menyimpan kutipan dan penulis.

  @override
  void initState() {
    super.initState();
    getListMahasiswa(); // Memanggil fungsi untuk mengambil data mahasiswa.
    getQuotes(); // Memanggil fungsi untuk mengambil kutipan.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row( // Menampilkan logo dan judul dalam satu baris.
          children: [
            Image.network(
              'https://rizapatiid.github.io/tugasakhirwebpro2/assets/img/STTP%20LOGO/headersttp1.png', 
              height: 30, // Mengatur tinggi logo.
            ),
            SizedBox(width: 10), // Spasi antara logo dan judul.
            const Text(""), // Judul halaman Text.
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              getListMahasiswa(); // Memperbarui daftar mahasiswa saat tombol refresh ditekan.
              getQuotes(); // Memperbarui kutipan saat tombol refresh ditekan.
            },
            icon: Icon(Icons.refresh), // Tombol refresh.
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "API Quotes :\n\"$quotes\" \n- $author", // Menampilkan kutipan.
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: mahasiswaList.length, // Jumlah item yang akan ditampilkan.
                itemBuilder: (context, index) {
                  return mahasiswaList[index]; // Mengembalikan widget mahasiswa.
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const Mahasiswa(), transition: Transition.rightToLeft); // Navigasi ke halaman Mahasiswa.
        },
        child: const Icon(Icons.person_add), // Ikon untuk tombol aksi floating.
      ),
    );
  }

  void getListMahasiswa() {
    mahasiswaList.clear(); // Menghapus data mahasiswa yang lama sebelum mengambil yang baru.
    DataBaseHelper.getAll('mahasiswa').then((value) { // Mengambil data mahasiswa dari database lokal.
      for (var element in value) {
        setState(() {
          mahasiswaList.add(
            InkWell(
              onTap: () {
                Get.to(() => Mahasiswa(), arguments: element); // Navigasi ke halaman Mahasiswa dengan data mahasiswa.
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(6),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    children: [
                      TableRow(
                        children: [
                          const Text("NIM"),
                          const Text(":"),
                          Text(element['nim'].toString()),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text("Nama"),
                          const Text(":"),
                          Text(element['nama'].toString().toUpperCase()),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text("Nilai Akhir"),
                          const Text(":"),
                          Text(element['nilai_akhir'].toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }
    });
    setState(() {}); // Memperbarui state setelah mengambil data mahasiswa.
  }

  void getQuotes() {
    Api.getData(context).then((value) { // Mengambil kutipan dari API.
      print(value);
      if (value != null) {
        setState(() {
          quotes = value.quote!; // Menyimpan kutipan dari API.
          author = value.author!; // Menyimpan penulis kutipan dari API.
        });
      } else {
        setState(() {
          quotes = "Gagal Mengambil Data"; // Jika gagal mengambil data, tampilkan pesan error.
          author = "Unknown"; // Penulis tidak diketahui.
        });
      }
    });
  }
}
