import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mahasiswa_stt/helper/database_helper.dart';
import 'package:mahasiswa_stt/page/dashboard.dart';

class Mahasiswa extends StatefulWidget {
  const Mahasiswa({super.key});

  @override
  State<Mahasiswa> createState() => _MahasiswaState();
}

class _MahasiswaState extends State<Mahasiswa> {
  // Controller untuk mengontrol input dari user
  TextEditingController nameController = TextEditingController();
  TextEditingController nimController = TextEditingController();
  TextEditingController tugasController = TextEditingController();
  TextEditingController utsController = TextEditingController();
  TextEditingController uasController = TextEditingController();

  // Variabel untuk menyimpan nilai akhir yang dihitung
  var _nilaiAkhir = 0.0;
  bool isEdit = false; // Flag untuk menandakan apakah kita sedang mengedit data atau tidak

  @override
  void initState() {
    super.initState();
    // Mengecek apakah data mahasiswa diteruskan dari halaman sebelumnya (edit mode)
    if (Get.arguments != null) {
      var data = Get.arguments;
      nameController.text = data['nama'];
      nimController.text = data['nim'].toString();
      tugasController.text = data['tugas'].toString();
      utsController.text = data['uts'].toString();
      uasController.text = data['uas'].toString();
      _nilaiAkhir = data['nilai_akhir'];
      isEdit = true; // Menandakan bahwa kita sedang dalam mode edit
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Detail Mahasiswa" : "Input Mahasiswa"), // Judul berbeda untuk edit dan input baru
        actions: [
          Visibility(
            visible: isEdit, // Tombol delete hanya muncul saat dalam mode edit
            child: IconButton(
              onPressed: () {
                // Konfirmasi untuk menghapus data mahasiswa
                Get.defaultDialog(
                  title: "Hapus Semua Data",
                  middleText: "Apakah Anda yakin ingin menghapus semua data?",
                  onConfirm: () {
                    DataBaseHelper.deleteWhere(
                      'mahasiswa',
                      'nim=?',
                      int.parse(nimController.text), // Menghapus data berdasarkan NIM
                    );
                    Get.offAll(() => Dashboard()); // Kembali ke halaman Dashboard setelah penghapusan
                  },
                  onCancel: () {
                    Get.closeAllSnackbars(); // Menutup snackbar jika cancel
                  },
                );
              },
              icon: Icon(Icons.delete), // Ikon untuk tombol delete
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input untuk Nama Mahasiswa
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Input untuk NIM, hanya bisa memasukkan angka
            TextField(
              controller: nimController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              readOnly: isEdit, // NIM hanya bisa dibaca jika sedang dalam mode edit
              decoration: InputDecoration(
                labelText: "NIM",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Input untuk Nilai Tugas
            TextField(
              controller: tugasController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nilai Tugas",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Input untuk Nilai UTS
            TextField(
              controller: utsController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nilai UTS",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Input untuk Nilai UAS
            TextField(
              controller: uasController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nilai UAS",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Tombol untuk menghitung nilai akhir
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Mengecek apakah semua field telah diisi
                  if (nameController.text.isNotEmpty &&
                      nimController.text.isNotEmpty &&
                      tugasController.text.isNotEmpty &&
                      utsController.text.isNotEmpty &&
                      uasController.text.isNotEmpty) {
                    // Menghitung nilai akhir dengan bobot 30% tugas, 30% UTS, 40% UAS
                    double tugas = double.parse(tugasController.text);
                    double uts = double.parse(utsController.text);
                    double uas = double.parse(uasController.text);

                    setState(() {
                      _nilaiAkhir = (tugas * 0.3) + (uts * 0.3) + (uas * 0.4); // Perhitungan nilai akhir
                    });
                  } else {
                    Get.snackbar(
                      "Error",
                      "Semua field harus diisi", // Menampilkan snackbar jika ada field kosong
                      backgroundColor: Colors.red[900],
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text("Hitung Nilai"),
              ),
            ),
            SizedBox(height: 10),
            // Menampilkan Nilai Akhir
            Text("Nilai Akhir: $_nilaiAkhir", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save), // Ikon untuk tombol save
        onPressed: () {
          // Mengecek apakah semua field sudah diisi dan nilai akhir sudah dihitung
          if (nameController.text.isNotEmpty &&
              nimController.text.isNotEmpty &&
              tugasController.text.isNotEmpty &&
              utsController.text.isNotEmpty &&
              uasController.text.isNotEmpty &&
              _nilaiAkhir != 0) {
            // Konfirmasi sebelum menyimpan data
            Get.defaultDialog(
              title: "Simpan Data",
              middleText: "Apakah Anda yakin ingin menyimpan data?",
              onConfirm: () {
                if (isEdit) {
                  // Jika sedang dalam mode edit, hapus data lama dan simpan yang baru
                  DataBaseHelper.deleteWhere(
                    'mahasiswa',
                    'nim=?',
                    int.parse(nimController.text),
                  );
                  DataBaseHelper.insert('mahasiswa', {
                    'nim': int.parse(nimController.text),
                    'nama': nameController.text,
                    'tugas': double.parse(tugasController.text),
                    'uts': double.parse(utsController.text),
                    'uas': double.parse(uasController.text),
                    'nilai_akhir': _nilaiAkhir,
                  });
                  Get.offAll(() => Dashboard()); // Kembali ke halaman Dashboard setelah simpan
                } else {
                  // Mengecek apakah NIM sudah terdaftar
                  DataBaseHelper.getWhere(
                    "mahasiswa",
                    "nim=${nimController.text}",
                  ).then((value) {
                    if (value.isNotEmpty) {
                      Get.snackbar(
                        "Error",
                        "NIM sudah terdaftar", // Menampilkan pesan kesalahan jika NIM sudah ada
                        backgroundColor: Colors.red[900],
                        colorText: Colors.white,
                      );
                    } else {
                      // Menyimpan data mahasiswa baru ke database
                      DataBaseHelper.insert('mahasiswa', {
                        'nim': int.parse(nimController.text),
                        'nama': nameController.text,
                        'tugas': double.parse(tugasController.text),
                        'uts': double.parse(utsController.text),
                        'uas': double.parse(uasController.text),
                        'nilai_akhir': _nilaiAkhir,
                      });
                      Get.offAll(() => Dashboard()); // Kembali ke halaman Dashboard setelah simpan
                    }
                  });
                }
              },
              onCancel: () {
                Get.closeAllSnackbars(); // Menutup snackbar jika cancel
              },
            );
          } else {
            Get.snackbar(
              "Error",
              "Semua field harus diisi, dan pastikan nilai akhir sudah dihitung", // Pesan kesalahan jika ada field kosong atau nilai akhir belum dihitung
              backgroundColor: Colors.red[900],
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }
}
