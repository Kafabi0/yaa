class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospitalId;
  final String hospitalName;
  final String location;
  final List<DoctorSchedule> schedule;
  final String photo;
  final String status;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospitalId,
    required this.hospitalName,
    required this.location,
    required this.schedule,
    this.photo = 'assets/images/doctor_placeholder.jpg',
    required this.status,
    required this.isAvailable,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    List<DoctorSchedule> schedules = [];

    if (json['schedule'] != null) {
      if (json['schedule'] is List) {
        schedules = (json['schedule'] as List)
            .map((schedule) => DoctorSchedule.fromJson(schedule))
            .toList();
      } else if (json['schedule'] is String) {
        schedules = [DoctorSchedule(day: 'N/A', time: json['schedule'])];
      }
    }

    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      hospitalId: json['hospitalId'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      location: json['location'] ?? '',
      schedule: schedules,
      photo: json['photo'] ?? 'assets/images/doctor_placeholder.jpg',
      status: json['status'] ?? '',
      isAvailable: json['isAvailable'] is bool ? json['isAvailable'] : false,
    );
  }
}

class DoctorSchedule {
  final String day;
  final String time;

  DoctorSchedule({required this.day, required this.time});

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      day: json['day'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'time': time,
    };
  }
}