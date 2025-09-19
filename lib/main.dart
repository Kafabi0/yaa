import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/health_records_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_navigation_bar.dart';
import 'screens/doctor_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/inotal');

  final DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  // final WindowsInitializationSettings windowsSettings =
  //     WindowsInitializationSettings();

  final InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
    // windows: windowsSettings,
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
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = false;

  void _changeTheme(ThemeMode theme) {
    setState(() {
      _themeMode = theme;
    });
  }

  void _toggleNotifications(bool isEnabled) {
    setState(() {
      _notificationsEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InoCare',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('id'), // Indonesian
      ],
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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textTheme: GoogleFonts.openSansTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: MainPage(
        onThemeChanged: _changeTheme,
        themeMode: _themeMode,
        onNotificationChanged: _toggleNotifications,
        notificationsEnabled: _notificationsEnabled,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  final ThemeMode themeMode;
  final Function(bool)? onNotificationChanged;
  final bool notificationsEnabled;

  const MainPage({
    super.key,
    this.onThemeChanged,
    this.themeMode = ThemeMode.system,
    this.onNotificationChanged,
    this.notificationsEnabled = false,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HealthAppHomePage(),
      const HealthRecordsScreen(),
      const NotificationsScreen(),
      SettingsScreen(
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
        onNotificationChanged: widget.onNotificationChanged,
        notificationsEnabled: widget.notificationsEnabled,
      ),
      const DoctorListScreen(),
    ];
  }

  @override
  void didUpdateWidget(covariant MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pages[3] = SettingsScreen(
      themeMode: widget.themeMode,
      onThemeChanged: widget.onThemeChanged,
      onNotificationChanged: widget.onNotificationChanged,
      notificationsEnabled: widget.notificationsEnabled,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
