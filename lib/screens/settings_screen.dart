import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

enum ThemeOption { system, light, dark }

class SettingsScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool>? onNotificationChanged;

  const SettingsScreen({
    super.key,
    this.themeMode = ThemeMode.system,
    this.onThemeChanged,
    this.notificationsEnabled = false,
    this.onNotificationChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late ThemeOption _themeOption;
  late bool _notificationsEnabled;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.notificationsEnabled;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.themeMode == ThemeMode.dark) {
      _themeOption = ThemeOption.dark;
    } else if (widget.themeMode == ThemeMode.light) {
      _themeOption = ThemeOption.light;
    } else {
      _themeOption = ThemeOption.system;
    }

    _checkNotificationPermission();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      setState(() => _notificationsEnabled = true);
      widget.onNotificationChanged?.call(true);
    } else {
      setState(() => _notificationsEnabled = false);
    }
  }

  Future<void> _toggleNotifications(bool val) async {
    if (val) {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        setState(() => _notificationsEnabled = true);
        widget.onNotificationChanged?.call(true);
        _showSampleNotification();
      } else {
        final result = await Permission.notification.request();
        if (result.isGranted) {
          setState(() => _notificationsEnabled = true);
          widget.onNotificationChanged?.call(true);
          _showSampleNotification();
        } else {
          setState(() => _notificationsEnabled = false);
          widget.onNotificationChanged?.call(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Izin notifikasi ditolak'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } else {
      setState(() => _notificationsEnabled = false);
      widget.onNotificationChanged?.call(false);
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  void _showSampleNotification() {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'General',
      channelDescription: 'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    flutterLocalNotificationsPlugin.show(
      0,
      'Notifikasi Aktif',
      'Anda akan menerima pemberitahuan dari app.',
      notificationDetails,
    );
  }

  void _changeTheme(ThemeOption option) {
    setState(() => _themeOption = option);
    switch (option) {
      case ThemeOption.light:
        widget.onThemeChanged?.call(ThemeMode.light);
        break;
      case ThemeOption.dark:
        widget.onThemeChanged?.call(ThemeMode.dark);
        break;
      case ThemeOption.system:
        widget.onThemeChanged?.call(ThemeMode.system);
        break;
    }
  }

  TextStyle _getAdaptiveTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color? lightColor,
    Color? darkColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color textColor;
    if (lightColor != null && darkColor != null) {
      textColor = isDark ? darkColor : lightColor;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 60,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF2563EB),
              flexibleSpace: Container(
                decoration: const BoxDecoration(color: Color(0xFF2563EB)),
                child: FlexibleSpaceBar(
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              // leading: Container(
              //   margin: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: IconButton(
              //     icon: const Icon(
              //       Icons.arrow_back_ios_new,
              //       color: Colors.white,
              //     ),
              //     onPressed: () => Navigator.pop(context),
              //   ),
              // ),
            ),

            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPremiumProfileCard(isDark),

                      const SizedBox(height: 32),

                      Text(
                        'Preferences',
                        style: _getAdaptiveTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          lightColor: const Color(0xFF1F2937),
                          darkColor: Colors.white,
                        ).copyWith(letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 16),

                      _buildPremiumSettingCard(
                        icon: Icons.notifications_active_rounded,
                        title: 'Notifications',
                        subtitle: 'Manage your notification preferences',
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch.adaptive(
                            value: _notificationsEnabled,
                            onChanged: _toggleNotifications,
                            activeColor: const Color(0xFF667EEA),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        isDark: isDark,
                      ),

                      _buildPremiumSettingCard(
                        icon: Icons.palette_rounded,
                        title: 'Theme',
                        subtitle: 'Choose your preferred theme',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(113, 84, 107, 210), Color.fromARGB(100, 156, 111, 201)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButton<ThemeOption>(
                            value: _themeOption,
                            underline: const SizedBox(),
                            dropdownColor:
                                isDark ? const Color(0xFF1E1E2C) : Colors.white,
                            style: _getAdaptiveTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              lightColor: Colors.white,
                              darkColor: Colors.white,
                            ),
                            iconEnabledColor: Colors.white,
                            onChanged: (val) {
                              if (val != null) _changeTheme(val);
                            },
                            items: [
                              DropdownMenuItem(
                                value: ThemeOption.system,
                                child: Text(
                                  'System',
                                  style: _getAdaptiveTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: ThemeOption.light,
                                child: Text(
                                  'Light',
                                  style: _getAdaptiveTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: ThemeOption.dark,
                                child: Text(
                                  'Dark',
                                  style: _getAdaptiveTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Account',
                        style: _getAdaptiveTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          lightColor: const Color(0xFF1F2937),
                          darkColor: Colors.white,
                        ).copyWith(letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 16),

                      _buildPremiumSettingCard(
                        icon: Icons.lock_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your account password',
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF667EEA).withOpacity(0.1),
                                const Color(0xFF764BA2).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF667EEA),
                          ),
                        ),
                        isDark: isDark,
                      ),

                      _buildPremiumSettingCard(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: 'Select your preferred language',
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF667EEA).withOpacity(0.1),
                                const Color(0xFF764BA2).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF667EEA),
                          ),
                        ),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Support',
                        style: _getAdaptiveTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          lightColor: const Color(0xFF1F2937),
                          darkColor: Colors.white,
                        ).copyWith(letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 16),

                      _buildPremiumSettingCard(
                        icon: Icons.info_rounded,
                        title: 'About App',
                        subtitle: 'Learn more about this application',
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF667EEA).withOpacity(0.1),
                                const Color(0xFF764BA2).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF667EEA),
                          ),
                        ),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Version 1.0.0 ',
                            style: _getAdaptiveTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              lightColor: Colors.black.withOpacity(0.6),
                              darkColor: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumProfileCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [const Color(0xFF1E1E2C), const Color(0xFF252545)]
                  : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border:
            isDark
                ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
                : null,
      ),
      child: Row(
        children: [
          Hero(
            tag: 'user-profile',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 33,
                    backgroundImage: const AssetImage('assets/dokter/doctor55.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dokter ',
                  style: _getAdaptiveTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    lightColor: const Color(0xFF1F2937),
                    darkColor: Colors.white,
                  ).copyWith(letterSpacing: -0.3),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Medical Officer',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'rsj',
                      style: _getAdaptiveTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        lightColor: const Color(0xFF6B7280),
                        darkColor: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [const Color(0xFF1E1E2C), const Color(0xFF252545)]
                  : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.2)
                    : const Color(0xFF1F2937).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border:
            isDark
                ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: _getAdaptiveTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          lightColor: const Color(0xFF1F2937),
                          darkColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: _getAdaptiveTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          lightColor: const Color(0xFF6B7280),
                          darkColor: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
