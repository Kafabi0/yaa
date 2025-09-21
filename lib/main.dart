import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/health_records_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_navigation_bar.dart';
import 'screens/doctor_list.dart';
import 'services/user_prefs.dart';
import 'screens/splashscreen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/inotal');

  final DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  final InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {},
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(const InoCareApp());
}

class InoCareApp extends StatefulWidget {
  const InoCareApp({super.key});

  @override
  State<InoCareApp> createState() => _InoCareAppState();
}

class _InoCareAppState extends State<InoCareApp> {
  bool _notificationsEnabled = false;
  bool _loading = true;

  void _toggleNotifications(bool isEnabled) {
    setState(() {
      _notificationsEnabled = isEnabled;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await UserPrefs.getUser();
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
        builder: (context) => SplashOnboarding(
          onCompleted: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HealthAppHomePage(
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final Function(bool)? onNotificationChanged;
  final bool notificationsEnabled;

  const MainPage({
    super.key,
    this.onNotificationChanged,
    this.notificationsEnabled = false,
  });

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
    await UserPrefs.clearUser();
    setState(() {
      _isLoggedIn = false;
      _currentIndex = 0;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout berhasil')),
      );
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
