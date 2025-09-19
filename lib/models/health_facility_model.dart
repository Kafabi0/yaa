import 'package:flutter/material.dart';

class HealthFacility {
  final String name;
  final String type;
  final String location;
  final String province;
  final double rating;
  final int reviewCount;
  final String image;
  final String description;
  final List<Service> services;
  final Map<String, String> hours;
  final String contact;
  final List<String> gallery;
  final List<Review> reviews;

  const HealthFacility({
    required this.name,
    required this.type,
    required this.location,
    required this.province,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.description,
    required this.services,
    required this.hours,
    required this.contact,
    required this.gallery,
    required this.reviews,
  });
}

class Service {
  final IconData icon;
  final String label;

  const Service({required this.icon, required this.label});
}

class Review {
  final String name;
  final String comment;
  final int rating;

  const Review({required this.name, required this.comment, required this.rating});
}
