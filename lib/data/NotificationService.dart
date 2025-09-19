// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future init() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = IOSInitializationSettings();

//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notifications.initialize(initSettings);
//   }

//   static Future showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       channelDescription: 'channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const iosDetails = IOSNotificationDetails();

//     const generalNotificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(id, title, body, generalNotificationDetails);
//   }
// }
