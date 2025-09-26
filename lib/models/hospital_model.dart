// hospital_model.dart
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
  final Map<String, Map<String, int>>? bedAvailability; // Tambahkan ini
  final double rating;
  final String operatingHours;
  double? distance;

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
    this.bedAvailability, // Tambahkan ini
    required this.rating,
    required this.operatingHours,
    this.distance,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['imageUrl'],
      services: List<String>.from(json['services']),
      isOpen24Hours: json['isOpen24Hours'],
      hasBloodStock: json['hasBloodStock'],
      acceptsBPJS: json['acceptsBPJS'],
      hasIGD: json['hasIGD'],
      hasMCU: json['hasMCU'],
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
      rating: json['rating'],
      operatingHours: json['operatingHours'],
    );
  }

  Hospital copyWith({
    double? distance,
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
      rating: rating,
      operatingHours: operatingHours,
      distance: distance ?? this.distance,
    );
  }
}