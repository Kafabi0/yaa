// File: lib/models/hospital_model.dart

class Hospital {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String phone;
  final List<String> services;
  final double? distance;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.phone,
    required this.services,
    this.distance,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      phone: json['phone'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      distance: json['distance']?.toDouble(),
    );
  }

  Hospital copyWith({double? distance}) {
    return Hospital(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      phone: phone,
      services: services,
      distance: distance ?? this.distance,
    );
  }
}