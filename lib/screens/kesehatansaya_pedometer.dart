import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class KesehatanSayaPedometerPage extends StatefulWidget {
  const KesehatanSayaPedometerPage({Key? key}) : super(key: key);

  @override
  State<KesehatanSayaPedometerPage> createState() => _KesehatanSayaPedometerPageState();
}

class _KesehatanSayaPedometerPageState extends State<KesehatanSayaPedometerPage> {
  String userName = "Iskandar";
  int _stepsToday = 0;
  int stepsTarget = 5000;

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }

  void _initPedometer() {
    Pedometer.stepCountStream.listen((StepCount event) {
      setState(() {
        _stepsToday = event.steps;
      });
    }, onError: (error) {
      debugPrint("Error pedometer: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_stepsToday / stepsTarget).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text("Kesehatan Saya (Sensor Pedometer)")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("👤 $userName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Langkah Hari Ini", style: const TextStyle(fontSize: 16)),
            Text("$_stepsToday / $stepsTarget", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}
