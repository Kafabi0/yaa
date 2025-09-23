import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

class KesehatanSayaSensorPage extends StatefulWidget {
  const KesehatanSayaSensorPage({super.key});

  @override
  State<KesehatanSayaSensorPage> createState() => _KesehatanSayaSensorPageState();
}

class _KesehatanSayaSensorPageState extends State<KesehatanSayaSensorPage> {
  StreamSubscription<StepCount>? _subscription;
  int _steps = 0;
  String _status = "Menunggu sensor..."; // ✅ status sensor

  @override
  void initState() {
    super.initState();
    _startStepCounting();
  }

  void _startStepCounting() {
    try {
      _subscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          setState(() {
            _steps = event.steps;
            _status = "Sensor aktif ✅";
          });
        },
        onError: (error) {
          setState(() {
            _status = "Sensor tidak tersedia ❌";
          });
          debugPrint("Step count error: $error");
        },
        cancelOnError: true,
      );
    } catch (e) {
      setState(() {
        _status = "Sensor tidak tersedia ❌";
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Estimasi jarak (1 langkah ~ 0.8 meter)
  double get _distanceKm => (_steps * 0.8) / 1000;

  /// Estimasi kalori (1 langkah ~ 0.04 kkal)
  double get _calories => _steps * 0.04;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kesehatan Saya (Sensor)"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Status sensor
            Text(
              _status,
              style: TextStyle(
                fontSize: 16,
                color: _status.contains("❌") ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Jika sensor ada, tampilkan data
            if (_status.contains("✅")) ...[
              _buildStatCard("Langkah", "$_steps langkah", Icons.directions_walk, Colors.blue),
              const SizedBox(height: 16),
              _buildStatCard("Jarak", "${_distanceKm.toStringAsFixed(2)} km", Icons.social_distance, Colors.green),
              const SizedBox(height: 16),
              _buildStatCard("Kalori", "${_calories.toStringAsFixed(1)} kkal", Icons.local_fire_department, Colors.red),
            ] else
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 8),
                    Text(
                      "Sensor langkah tidak tersedia di perangkat ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withAlpha(50),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
