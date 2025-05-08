import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as g;

// Model Api untuk menampung data yang diterima dari API
class Api {
  var id, quote, author;

  // Constructor untuk menginisialisasi object Api
  Api({this.id, this.quote, this.author});

  // Factory constructor untuk membuat instance Api dari response JSON
  factory Api.result(dynamic object) {
    return Api(
      id: object['id'],        // Mendapatkan id dari response JSON
      quote: object['quote'],  // Mendapatkan quote dari response JSON
      author: object['author'],// Mendapatkan author dari response JSON
    );
  }

  // Fungsi asinkron untuk mengambil data dari API
  static Future<Api?> getData(BuildContext context) async {
    String apiUrl = "https://dummyjson.com/quotes/random"; // URL API yang digunakan

    EasyLoading.show(status: 'Memuat Data...'); // Menampilkan loading indicator

    // Mengonfigurasi Dio dengan waktu timeout dan header untuk content type
    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 60),   // Timeout untuk koneksi
      receiveTimeout: const Duration(seconds: 30),   // Timeout untuk menerima data
      contentType: "application/json;charset=utf-8",  // Menentukan content type sebagai JSON
    );

    Dio dio = Dio(options); // Membuat instance Dio untuk melakukan request HTTP

    try {
      // Melakukan GET request ke API
      Response response = await dio.get(apiUrl);

      Api? apiResponse;

      // Mengecek apakah response status code adalah 200 (OK)
      if (response.statusCode == 200) {
        dynamic listData = response.data; // Mengambil data dari response

        // Mengonversi data response menjadi object Api
        apiResponse = Api.result(listData);
        EasyLoading.dismiss(); // Menghilangkan loading setelah data diterima
        return apiResponse; // Mengembalikan object Api
      } else {
        // Jika status code bukan 200, tampilkan snackbar error
        g.Get.snackbar(
          "Gagal",
          "Gagal Mengambil Data",
          backgroundColor: Colors.red[800],  // Menentukan warna background snackbar
          colorText: Colors.white,            // Menentukan warna teks snackbar
        );
      }
      EasyLoading.dismiss(); // Menghilangkan loading jika terjadi error
      return null; // Mengembalikan null jika gagal
    } catch (e) {
      // Menangani error jika terjadi kesalahan pada request
      print(e);
      g.Get.snackbar(
        "Gagal",
        "Gagal Mengambil Data",
        backgroundColor: Colors.red[800],  // Menentukan warna background snackbar
        colorText: Colors.white,            // Menentukan warna teks snackbar
      );
      EasyLoading.dismiss(); // Menghilangkan loading jika terjadi error
      return null; // Mengembalikan null jika terjadi exception
    }
  }
}
