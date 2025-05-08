import 'package:flutter/material.dart'; 
import 'package:flutter_easyloading/flutter_easyloading.dart'; 
import 'package:get/get.dart'; 
import 'package:mahasiswa_stt/page/dashboard.dart'; 

// Fungsi utama untuk menjalankan aplikasi
void main() {
  runApp(const MyApp()); // Menjalankan widget MyApp sebagai root widget
}

// Kelas MyApp sebagai widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Konstruktor untuk MyApp, menggunakan super.key untuk widget yang memiliki state

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DAFTAR MAHASISWA', // Judul aplikasi yang akan muncul di taskbar
      theme: ThemeData(
        // Menentukan tema aplikasi, di sini menggunakan warna yang dihasilkan dari seedColor
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Dashboard(), // Halaman utama yang ditampilkan
      defaultTransition: Transition.rightToLeftWithFade, // Menentukan jenis transisi default saat berpindah halaman
      transitionDuration: const Duration(milliseconds: 500), // Durasi transisi halaman dalam milidetik
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug di pojok kanan atas
      builder: EasyLoading.init(), 
    );
  }
}
