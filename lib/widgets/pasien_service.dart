import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/pasien_transaksi.dart';

class PasienService {
  static const String baseUrl = "http://192.168.1.38:8080";

  static Future<List<Pasien>> getAllPasien() async {
    final response = await http.get(Uri.parse("$baseUrl/pasien"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Pasien.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load pasien");
    }
  }

  static Future<Pasien> getPasienById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/pasien/$id"));
    if (response.statusCode == 200) {
      return Pasien.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load pasien");
    }
  }

  // 🔹 Tambah pasien dengan foto
  static Future<Pasien> createPasienWithFoto({
    required String name,
    required String jenisKelamin,
    required String nik,
    required String alamat,
    required String noTelp,
    required String email,
    required String tanggalLahir,
    File? foto,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/pasien"));

    // field pasien
    request.fields['name'] = name;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['nik'] = nik;
    request.fields['alamat'] = alamat;
    request.fields['no_telp'] = noTelp;
    request.fields['email'] = email;
    request.fields['tanggal_lahir'] = tanggalLahir;

    // file foto kalau ada
    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      return Pasien.fromJson(jsonDecode(resStr));
    } else {
      throw Exception("Failed to create pasien with foto");
    }
  }

  // 🔹 Update pasien dengan foto
  static Future<Pasien> updatePasienWithFoto({
    required int id,
    required String name,
    required String jenisKelamin,
    required String nik,
    required String alamat,
    required String noTelp,
    required String email,
    required String tanggalLahir,
    File? foto,
  }) async {
    var request = http.MultipartRequest("PUT", Uri.parse("$baseUrl/pasien/$id"));

    // field pasien
    request.fields['name'] = name;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['nik'] = nik;
    request.fields['alamat'] = alamat;
    request.fields['no_telp'] = noTelp;
    request.fields['email'] = email;
    request.fields['tanggal_lahir'] = tanggalLahir;

    // file foto kalau ada
    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      return Pasien.fromJson(jsonDecode(resStr));
    } else {
      throw Exception("Failed to update pasien with foto");
    }
  }

  // 🔹 Delete pasien
  static Future<void> deletePasien(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/pasien/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete pasien");
    }
  }
}
