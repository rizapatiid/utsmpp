import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DataBaseHelper {
  // Fungsi untuk membuat tabel pada database
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
      """CREATE TABLE mahasiswa (nim INTEGER PRIMARY KEY, nama TEXT, tugas REAL, uts REAL, uas REAL, nilai_akhir REAL)""", // Query untuk membuat tabel mahasiswa
    );
  }

  // Fungsi untuk membuka dan menginisialisasi database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mahasiswa_stt.db', // Nama file database
      version: 1, // Versi database
      onCreate: (sql.Database database, int version) async {
        await createTables(database); // Membuat tabel ketika database pertama kali dibuat
      },
    );
  }

  // Fungsi untuk menghapus data berdasarkan kondisi tertentu
  static Future<void> deleteWhere(String table, String where, int val) async {
    final db = await DataBaseHelper.db();
    try {
      await db.delete(table, where: where, whereArgs: [val]); // Menghapus data berdasarkan kriteria
    } catch (e) {
      print(e); // Menampilkan error jika terjadi kesalahan
      Get.snackbar(
        "Maaf",
        "Gagal Menghapus Data", // Menampilkan pesan kesalahan jika penghapusan gagal
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk menghapus semua data dalam tabel
  static Future<void> deleteAll(String table) async {
    final db = await DataBaseHelper.db();
    try {
      await db.delete(table); // Menghapus semua data dalam tabel
    } catch (e) {
      Get.snackbar(
        "Maaf",
        "Gagal Menghapus Data", // Menampilkan pesan kesalahan jika penghapusan gagal
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk mengambil semua data dari tabel
  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await DataBaseHelper.db();
    return db.query(table); // Mengambil semua data dalam tabel
  }

  // Fungsi untuk mengambil data berdasarkan kondisi tertentu
  static Future<List<Map<String, dynamic>>> getWhere(
    String table,
    String where,
  ) async {
    final db = await DataBaseHelper.db();
    return db.query(table, where: where); // Mengambil data berdasarkan kriteria
  }

  // Fungsi untuk memasukkan data ke dalam tabel
  static Future<int> insert(String table, var content) async {
    final db = await DataBaseHelper.db();
    final data = content;
    final id = await db.insert(
      table,
      data, // Menyisipkan data ke tabel
      conflictAlgorithm: sql.ConflictAlgorithm.replace, // Menggunakan algoritma replace jika ada konflik
    );
    return id; // Mengembalikan id dari data yang baru disisipkan
  }

  // Fungsi untuk memperbarui data dalam tabel berdasarkan kondisi tertentu
  static Future<int> update(
    String table,
    var content,
    String where,
    int val,
  ) async {
    final db = await DataBaseHelper.db();
    final data = content;
    final result = await db.update(table, data, where: where, whereArgs: [val]); // Memperbarui data berdasarkan kondisi
    return result; // Mengembalikan hasil dari operasi update
  }

  // Fungsi untuk menjalankan query kustom yang ditentukan pengguna
  static Future<List<Map<String, dynamic>>> customQuery(String query) async {
    final db = await DataBaseHelper.db();
    return db.rawQuery(query); // Menjalankan query kustom
  }
}
