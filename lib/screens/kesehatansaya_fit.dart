// import 'package:flutter/material.dart';
// import 'package:health/health.dart';

// class KesehatanSayaFitPage extends StatefulWidget {
//   const KesehatanSayaFitPage({Key? key}) : super(key: key);

//   @override
//   State<KesehatanSayaFitPage> createState() => _KesehatanSayaFitPageState();
// }

// class _KesehatanSayaFitPageState extends State<KesehatanSayaFitPage> {
//   final Health _health = Health();

//   String userName = "Iskandar";
//   int stepsToday = 0;
//   int stepsTarget = 5000;
//   int calories = 0;
//   int caloriesTarget = 300;
//   int heartRate = 0;
//   double distanceKm = 0.0;
//   int activeMinutes = 0;
//   double sleepHours = 0.0;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchHealthData();
//   }

//   Future<void> _fetchHealthData() async {
//     setState(() => _isLoading = true);

//     final types = [
//       HealthDataType.STEPS,
//       HealthDataType.ACTIVE_ENERGY_BURNED,
//       HealthDataType.HEART_RATE,
//       HealthDataType.DISTANCE_WALKING_RUNNING,
//       HealthDataType.EXERCISE_TIME,
//       HealthDataType.SLEEP_ASLEEP,
//     ];

//     final permissions = types.map((e) => HealthDataAccess.READ).toList();

//     bool authorized = await _health.requestAuthorization(
//       types,
//       permissions: permissions,
//     );

//     if (authorized) {
//       final now = DateTime.now();
//       final midnight = DateTime(now.year, now.month, now.day);

//       try {
//         stepsToday =
//             (await _health.getTotalStepsInInterval(midnight, now)) ?? 0;

//         var caloriesData = await _health.getHealthDataFromTypes(midnight, now, [
//           HealthDataType.ACTIVE_ENERGY_BURNED,
//         ]);
//         calories = caloriesData.fold(
//           0,
//           (sum, item) => sum + (item.value as double).toInt(),
//         );

//         var heartRateData = await _health.getHealthDataFromTypes(
//           midnight,
//           now,
//           [HealthDataType.HEART_RATE],
//         );
//         if (heartRateData.isNotEmpty) {
//           heartRate = (heartRateData.last.value as double).toInt();
//         }

//         var distanceData = await _health.getHealthDataFromTypes(midnight, now, [
//           HealthDataType.DISTANCE_WALKING_RUNNING,
//         ]);
//         distanceKm =
//             distanceData.fold(
//               0.0,
//               (sum, item) => sum + (item.value as double),
//             ) /
//             1000;

//         var activeData = await _health.getHealthDataFromTypes(midnight, now, [
//           HealthDataType.ACTIVE_MINUTES,
//         ]);
//         activeMinutes = activeData.fold(
//           0,
//           (sum, item) => sum + (item.value as double).toInt(),
//         );

//         var sleepData = await _health.getHealthDataFromTypes(
//           midnight.subtract(const Duration(days: 1)),
//           now,
//           [HealthDataType.SLEEP_ASLEEP],
//         );
//         sleepHours = sleepData.fold(
//           0.0,
//           (sum, item) => sum + (item.value as double) / (1000 * 60 * 60),
//         );
//       } catch (e) {
//         debugPrint("Error fetching health data: $e");
//       }
//     }

//     setState(() => _isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Kesehatan Saya (Google Fit)")),
//       body:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//                 onRefresh: _fetchHealthData,
//                 child: ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     Text(
//                       "👤 $userName",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _tile("Langkah Hari Ini", "$stepsToday / $stepsTarget"),
//                     _tile(
//                       "Kalori Terbakar",
//                       "$calories / $caloriesTarget kcal",
//                     ),
//                     _tile("Detak Jantung", "$heartRate bpm"),
//                     _tile("Jarak", "${distanceKm.toStringAsFixed(2)} km"),
//                     _tile("Aktivitas", "$activeMinutes menit"),
//                     _tile("Tidur", "${sleepHours.toStringAsFixed(1)} jam"),
//                   ],
//                 ),
//               ),
//     );
//   }

//   Widget _tile(String title, String value) {
//     return ListTile(
//       title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//       trailing: Text(value, style: const TextStyle(fontSize: 16)),
//     );
//   }
// }
