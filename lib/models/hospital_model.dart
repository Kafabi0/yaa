class Hospital {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final List<String> services;
  final bool isOpen24Hours;
  final bool hasBloodStock;
  final bool acceptsBPJS;
  final bool hasIGD;
  final bool hasMCU;
  final Map<String, int>? bloodStock;
  final Map<String, Map<String, int>>? bedAvailability;
  final Map<String, Map<String, int>>? mobilAvailability;
  final double rating;
  final String operatingHours;
  final double? distance;
  
  // Getter untuk kompatibilitas
  int get reviewCount => 0;
  bool get isOpen => isOpen24Hours;
  String get imagePath => imageUrl;
  String get type => acceptsBPJS ? 'RS Pemerintah' : 'RS Swasta';
  
  Map<String, BloodStock> get bloodStockInfo {
    Map<String, BloodStock> result = {};
    if (bloodStock != null) {
      bloodStock!.forEach((type, count) {
        result[type] = BloodStock(
          type: type,
          available: count > 0,
          count: count,
        );
      });
    } else {
      for (String type in ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']) {
        result[type] = BloodStock(type: type, available: false, count: 0);
      }
    }
    return result;
  }
  
  Map<String, dynamic> get facilities {
    return {
      'kamarVip': services.contains('Rawat Inap') ? 10 : 0,
      'igd': hasIGD ? 5 : 0,
      'dokter': 25,
      'antrian': isOpen24Hours ? 'Pendek' : 'Sedang',
    };
  }
  
  List<String> get specialties => [];

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.services,
    required this.isOpen24Hours,
    required this.hasBloodStock,
    required this.acceptsBPJS,
    required this.hasIGD,
    required this.hasMCU,
    this.bloodStock,
    this.bedAvailability,
    this.mobilAvailability,
    required this.rating,
    required this.operatingHours,
    this.distance, // <-- BERI DEFAULT VALUE
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      isOpen24Hours: json['isOpen24Hours'] ?? false,
      hasBloodStock: json['hasBloodStock'] ?? false,
      acceptsBPJS: json['acceptsBPJS'] ?? false,
      hasIGD: json['hasIGD'] ?? false,
      hasMCU: json['hasMCU'] ?? false,
      bloodStock: json['bloodStock'] != null 
          ? Map<String, int>.from(json['bloodStock']) 
          : null,
      bedAvailability: json['bedAvailability'] != null 
          ? Map<String, Map<String, int>>.from(
              json['bedAvailability'].map((key, value) => 
                MapEntry(key, Map<String, int>.from(value))
              )
            ) 
          : null,
      mobilAvailability: json['mobilAvailability'] != null 
          ? Map<String, Map<String, int>>.from(
              json['mobilAvailability'].map((key, value) => 
                MapEntry(key, Map<String, int>.from(value))
              )
            ) 
          : null,
      rating: (json['rating'] ?? 0).toDouble(),
      operatingHours: json['operatingHours'] ?? '',
      distance: null, // <-- DEFAULT
    );
  }

  Hospital copyWith({
    double? distance, // <-- GANTI DARI double? MENJADI String?
  }) {
    return Hospital(
      id: id,
      name: name,
      address: address,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      services: services,
      isOpen24Hours: isOpen24Hours,
      hasBloodStock: hasBloodStock,
      acceptsBPJS: acceptsBPJS,
      hasIGD: hasIGD,
      hasMCU: hasMCU,
      bloodStock: bloodStock,
      bedAvailability: bedAvailability,
      mobilAvailability: mobilAvailability,
      rating: rating,
      operatingHours: operatingHours,
      distance: distance ?? this.distance,
    );
  }
}

class BloodStock {
  final String type;
  final bool available;
  final int count;

  BloodStock({
    required this.type,
    required this.available,
    required this.count,
  });
}