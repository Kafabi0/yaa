import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/inotal');
  const iosSettings = DarwinInitializationSettings();
  const initSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> showErrorNotification(String message) async {
  const androidDetails = AndroidNotificationDetails(
    'qr_channel',
    'QR Scanner',
    channelDescription: 'Notifications for QR scan errors',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/inotal',
  );
  const notificationDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    'QR Scan Error',
    message,
    notificationDetails,
  );
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  bool scanned = false;
  bool isFlashOn = false;
  MobileScannerController cameraController = MobileScannerController();
  late AnimationController _lineController;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    requestCameraPermission();
    initNotifications();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        if (!mounted) return;
        showErrorNotification("Izin kamera ditolak. QR scanner tidak bisa digunakan.");
      }
    }
  }

  Future<void> _handleBarcode(String code) async {
    Uri? uri = Uri.tryParse(code);

    if (uri == null || uri.scheme.isEmpty) {
      uri = Uri.tryParse('https://$code');
    }

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      showErrorNotification("QR ini bukan link alat medis yang tersedia");
    }
  }

  @override
  void dispose() {
    _lineController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanSize = size.width * 0.7;

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              if (scanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;

              final String? code = barcodes.first.rawValue;
              if (code == null) return;

              scanned = true;

              await _handleBarcode(code);

              if (!mounted) return;
              await Future.delayed(const Duration(seconds: 5));
              setState(() => scanned = false);
            },
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SizedBox(
              width: scanSize,
              height: scanSize,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(color: Colors.transparent),
                  ),
                  AnimatedBuilder(
                    animation: _lineController,
                    builder: (context, child) {
                      return Positioned(
                        top: scanSize * _lineController.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.redAccent.withOpacity(0.8),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(child: CustomPaint(painter: _FramePainter())),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            child: IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                cameraController.toggleTorch();
                setState(() => isFlashOn = !isFlashOn);
              },
            ),
          ),
          Positioned(
            bottom: 50,
            right: 40,
            child: IconButton(
              icon: const Icon(
                Icons.cameraswitch_rounded,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => cameraController.switchCamera(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const borderWidth = 4.0;
    const cornerLength = 30.0;
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    canvas.drawLine(Offset(size.width - cornerLength, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height - cornerLength), Offset(0, size.height), paint);

    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
