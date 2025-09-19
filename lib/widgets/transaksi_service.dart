import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pasien_transaksi.dart';

class TransaksiService {
  static const String baseUrl = "http://192.168.1.38:8080";

  // Ambil semua transaksi
  static Future<List<Transaksi>> getTransaksi() async {
    final response = await http.get(Uri.parse("$baseUrl/transaksi"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Transaksi.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load transaksi");
    }
  }

  // Buat transaksi baru
  static Future<Transaksi> createTransaksi(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transaksi"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Transaksi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create transaksi");
    }
  }

  // Ambil data chart bar per pasien
  // Bar chart pasien
static Future<List<ChartData>> getBarChart(int pasienId) async {
  final res = await http.get(Uri.parse("$baseUrl/pasien/$pasienId/chart"));
  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);
    return data.map((e) => ChartData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch bar chart");
  }
}

static Future<List<ChartData>> getPieChart(int pasienId) async {
  final res = await http.get(Uri.parse("$baseUrl/pasien/$pasienId/pie"));
  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);
    return data.map((e) => ChartData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch pie chart");
  }
}


}
