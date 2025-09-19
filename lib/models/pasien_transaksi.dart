class Pasien {
  final int id;
  final String name;
  final String jenisKelamin;
  final String nik;
  final String alamat;
  final String noTelp;
  final String email;
  final String foto;
  final String tanggalLahir;
  final List<Transaksi> transaksi;

  Pasien({
    required this.id,
    required this.name,
    required this.jenisKelamin,
    required this.nik,
    required this.alamat,
    required this.noTelp,
    required this.email,
    required this.foto,
    required this.tanggalLahir,
    required this.transaksi,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      id:
          json['ID'] is int
              ? json['ID']
              : int.tryParse(json['ID'].toString()) ?? 0,
      name: json['name'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      nik: json['nik'] ?? '',
      alamat: json['alamat'] ?? '',
      noTelp: json['no_telp'] ?? '',
      email: json['email'] ?? '',
      foto: json['foto'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      transaksi:
          (json['transaksi'] as List<dynamic>?)
              ?.map((e) => Transaksi.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Transaksi {
  final int id;
  final int pasienId;
  final int total;
  final String tanggalTransaksi;

  Transaksi({
    required this.id,
    required this.pasienId,
    required this.total,
    required this.tanggalTransaksi,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] ?? 0,
      pasienId: json['pasien_id'] ?? 0,
      total: json['total'] ?? 0,
      tanggalTransaksi: json['tanggal_transaksi'] ?? '',
    );
  }
}

class ChartData {
  final String bulan;
  final int total;

  ChartData({required this.bulan, required this.total});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      bulan: json['bulan'] ?? '',
      total: (json['total'] ?? 0).toInt(),
    );
  }
}
