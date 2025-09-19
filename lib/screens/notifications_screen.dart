import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Patient Assigned',
      'message': 'John Doe has been assigned to your shift.',
      'type': 'task',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'read': false,
    },
    {
      'title': 'Emergency Alert',
      'message': 'Code Red in Room 305!',
      'type': 'emergency',
      'time': DateTime.now().subtract(const Duration(minutes: 20)),
      'read': false,
    },
    {
      'title': 'System Update',
      'message': 'Medical system will be updated at midnight.',
      'type': 'info',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'read': true,
    },
    {
      'title': 'Lab Results Ready',
      'message': 'Blood test results for patient #123 are available.',
      'type': 'task',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'read': false,
    },
    {
      'title': 'Shift Reminder',
      'message': 'Your next shift starts in 2 hours.',
      'type': 'reminder',
      'time': DateTime.now().subtract(const Duration(hours: 4)),
      'read': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color _getTypeColor(String type, {required bool isDark}) {
    Color color;
    switch (type) {
      case 'emergency':
        color = const Color(0xFFEF4444);
        break;
      case 'task':
        color = const Color(0xFF3B82F6);
        break;
      case 'info':
        color = const Color(0xFF10B981);
        break;
      case 'reminder':
        color = const Color(0xFF8B5CF6);
        break;
      default:
        color = const Color(0xFF6B7280);
    }
    // Mengembalikan warna yang lebih terang untuk mode gelap
    return isDark ? color.withOpacity(0.8) : color;
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'emergency':
        return Icons.emergency_rounded;
      case 'task':
        return Icons.task_alt_rounded;
      case 'info':
        return Icons.info_rounded;
      case 'reminder':
        return Icons.access_time_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  void _markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['read'] = true;
      }
    });
  }

  String _formatTime(DateTime time) {
    final duration = DateTime.now().difference(time);
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    if (duration.inDays == 1) return 'Yesterday';
    return DateFormat('MMM dd').format(time);
  }

  int get unreadCount => notifications.where((n) => !n['read']).length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? const Color(0xFF1F1F2F) : Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2E3A59),
                            Color(0xFF3C4A6B),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E40AF),
                            Color(0xFF3B82F6),
                          ],
                        ),
                ),
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.done_all_rounded, color: Colors.white),
                  onPressed: unreadCount > 0 ? _markAllAsRead : null,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: unreadCount > 0 ? primaryColor.withOpacity(0.1) : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: unreadCount > 0 ? primaryColor.withOpacity(0.3) : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$unreadCount unread',
                      style: TextStyle(
                        color: unreadCount > 0 ? primaryColor : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${notifications.length} total',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final notification = notifications[index];
                final isRead = notification['read'] as bool;
                
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 0.1 * (index + 1)),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _fadeController,
                      curve: Interval(
                        0.1 * index,
                        0.5 + (0.1 * index),
                        curve: Curves.easeOut,
                      ),
                    )),
                    child: Dismissible(
                      key: Key('${notification['title']}_${notification['time']}'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deleteNotification(index),
                      background: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.only(right: 24),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_sweep_rounded, 
                                color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text('Delete', 
                                style: TextStyle(color: Colors.white, 
                                fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: !isRead 
                                ? _getTypeColor(notification['type'], isDark: isDark).withOpacity(0.3)
                                : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: !isRead 
                                  ? _getTypeColor(notification['type'], isDark: isDark).withOpacity(isDark ? 0.05 : 0.1)
                                  : Colors.black.withOpacity(isDark ? 0.05 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _markAsRead(index),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(notification['type'], isDark: isDark)
                                          .withOpacity(!isRead ? 0.15 : 0.08),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _getTypeColor(notification['type'], isDark: isDark)
                                            .withOpacity(!isRead ? 0.3 : 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      _getTypeIcon(notification['type']),
                                      color: _getTypeColor(notification['type'], isDark: isDark)
                                          .withOpacity(!isRead ? 1.0 : 0.6),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification['title'],
                                                style: TextStyle(
                                                  fontWeight: !isRead 
                                                      ? FontWeight.w600 
                                                      : FontWeight.w500,
                                                  fontSize: 16,
                                                  color: !isRead 
                                                      ? (isDark ? Colors.white : const Color(0xFF1F2937))
                                                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                                                  letterSpacing: 0.1,
                                                ),
                                              ),
                                            ),
                                            if (!isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(left: 8),
                                                decoration: BoxDecoration(
                                                  color: _getTypeColor(notification['type'], isDark: isDark),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          notification['message'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: !isRead 
                                                ? (isDark ? Colors.grey.shade300 : Colors.grey.shade700)
                                                : (isDark ? Colors.grey.shade500 : Colors.grey.shade500),
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 14,
                                              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _formatTime(notification['time']),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: notifications.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}