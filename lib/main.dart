import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inocare/screens/notifikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:inocare/screens/order.dart';
// import 'package:inocare/screens/tiketantrian.dart';
import 'screens/home_screen.dart';
import 'screens/health_records_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_navigation_bar.dart';
import 'screens/doctor_list.dart';
import 'services/user_prefs.dart';
import 'screens/splashscreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  final InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      Future.microtask(() {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const NotificationsPage()),
        );
      });
    },
  );

  final androidImplementation =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  if (androidImplementation != null) {
    await androidImplementation.requestNotificationsPermission();
  }
}

Future<void> showIGDRegistrationNotification(
  String triaseLevel,
  String nomorAntrian,
) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'igd_channel_id',
    'Notifikasi IGD',
    channelDescription: 'Notifikasi konfirmasi pendaftaran IGD',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    1, // ID unik, pastikan berbeda dari notifikasi lainnya
    'Registrasi IGD Berhasil!',
    'Nomor antrian Anda: $nomorAntrian. Level triase: $triaseLevel.',
    platformChannelDetails,
  );
}

Future<void> showRegistrationSuccessNotification(
  String serviceType,
  String nomorAntrian,
) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'registrasi_channel_id',
    'Notifikasi Registrasi',
    channelDescription: 'Notifikasi konfirmasi pendaftaran layanan rumah sakit',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Registrasi Berhasil! ',
    'Pendaftaran Anda untuk $serviceType berhasil. Nomor antrian Anda: $nomorAntrian.',
    platformChannelDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(const InoCareApp());
}

class InoCareApp extends StatefulWidget {
    final String? initialPayload;
  const InoCareApp({super.key, this.initialPayload});

  @override
  State<InoCareApp> createState() => _InoCareAppState();
}

class _InoCareAppState extends State<InoCareApp> {
  // bool _notificationsEnabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final nik = prefs.getString('current_nik'); // atau _keyCurrentNik

  if (nik != null) {
    final user = await UserPrefs.getUser(nik); // 👈 pakai parameter
    print("User ditemukan: $user");
  }

  setState(() {
    _loading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      navigatorKey:
          navigatorKey, // 👈 wajib supaya push dari luar context bisa jalan

      title: 'Digital Hospital',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
      locale: const Locale('id'),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0D6EFD),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D6EFD),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: Builder(
        builder:
            (context) => SplashOnboarding(
              onCompleted: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => HealthAppHomePage()),
                );
              },
            ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await UserPrefs.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<void> _handleLogout() async {
    await UserPrefs.logout();
    setState(() {
      _isLoggedIn = false;
      _currentIndex = 0;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logout berhasil')));
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HealthAppHomePage(
          onLoginSuccess: () {
            _checkLoginStatus();
            setState(() {
              _currentIndex = 0;
            });
          },
        );
      case 1:
        return const HealthRecordsScreen();
      case 2:
        return const NotificationsScreen();
      case 3:
        return SettingsScreen(onLogout: _handleLogout);
      case 4:
        return const DoctorListScreen();
      default:
        return const Center(child: Text("Halaman tidak ditemukan"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isLoggedIn: _isLoggedIn,
      ),
    );
  }
}
