import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inocare/screens/home_page_member.dart';
import 'package:inocare/screens/home_screen.dart';
import 'screens/home_screen_public.dart';
import 'screens/health_records_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_navigation_bar.dart';
import 'screens/doctor_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/user_prefs.dart';

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

enum HomeState { public, member, hospital }

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
      title: 'InoCare',
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
      home: MainPage(
        onNotificationChanged: _toggleNotifications,
        notificationsEnabled: _notificationsEnabled,
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
  HomeState _homeState = HomeState.public;
  bool _loading = true;
  String? _userName;

  Key _bottomNavKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final user = await UserPrefs.getUser();
    if (user == null) {
      setState(() {
        _homeState = HomeState.public;
        _loading = false;
        _userName = null;
      });
    } else {
      if (await UserPrefs.getHospital() == null) {
        setState(() {
          _homeState = HomeState.member;
          _userName = user['name']; // Perbaikan ada di sini
          _loading = false;
        });
      } else {
        setState(() {
          _homeState = HomeState.hospital;
          _loading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    await UserPrefs.clearUser();
    setState(() {
      _homeState = HomeState.public;
      _currentIndex = 0;
      _bottomNavKey = UniqueKey();
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logout berhasil')));
    }
  }

  Future<void> _handleLoginSuccess() async {
    await _checkUserStatus();
    setState(() {
      _currentIndex = 0;
      _bottomNavKey = UniqueKey();
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil')));
    }
  }

  Future<void> _handleHospitalSelected() async {
    await UserPrefs.setHospital("RS Contoh");
    await _checkUserStatus();
    setState(() {
      _currentIndex = 0;
      _bottomNavKey = UniqueKey();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildHomeRoot() {
    switch (_homeState) {
      case HomeState.public:
        return HealthAppHomePage(onLoginSuccess: _handleLoginSuccess);
      case HomeState.member:
        return HomePageMember(
          onHospitalSelected: _handleHospitalSelected,
          userName: _userName,
        );
      case HomeState.hospital:
        return const HomePageHospital();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      _buildHomeRoot(),
      const HealthRecordsScreen(),
      const NotificationsScreen(),
      SettingsScreen(onLogout: _handleLogout),
      const DoctorListScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex.clamp(0, pages.length - 1),
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar( // <-- Gunakan widget yang sudah ada
        key: _bottomNavKey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isLoggedIn: _homeState != HomeState.public, // <-- Perbaiki logika di sini
      ),
    );
  }
}

class HomePageHospital extends StatelessWidget {
  const HomePageHospital({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome to Hospital Home",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}