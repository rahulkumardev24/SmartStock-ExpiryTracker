import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> scheduleDailyNotifications({
    required int id,
    required String title,
    required String body,
    required DateTime firstNotificationDate,
    required int daysUntilExpiry,
  }) async {
    try {
      final now = DateTime.now();
      bool hasExactAlarmPermission = await _checkExactAlarmPermission();

      for (int daysLeft = daysUntilExpiry; daysLeft >= 0; daysLeft--) {
        final notificationTime = firstNotificationDate.add(
          Duration(days: daysUntilExpiry - daysLeft),
        );

        // Skip past notifications
        if (notificationTime.isBefore(now)) continue;

        String notificationBody;
        if (daysLeft == 0) {
          notificationBody = '❗$title expires TODAY!';
        } else if (daysLeft == 1) {
          notificationBody = '⚠️ $title expires tomorrow!';
        } else {
          notificationBody = '⚠️ $title expires in $daysLeft days';
        }

        try {
          await _notificationsPlugin.zonedSchedule(
            id + daysLeft,
            title,
            notificationBody,
            tz.TZDateTime.from(notificationTime, tz.local),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'expiry_channel_id',
                'Expiry Alerts',
                channelDescription: 'Notifications for expiring items',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
            ),
            androidScheduleMode: hasExactAlarmPermission
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.inexactAllowWhileIdle,
          );

          debugPrint('✅ Scheduled notification for $notificationTime');
        } catch (e) {
          debugPrint('❌ Error scheduling notification for $notificationTime: $e');
          // Fallback to inexact if exact fails
          await _notificationsPlugin.zonedSchedule(
            id + daysLeft,
            title,
            notificationBody,
            tz.TZDateTime.from(notificationTime, tz.local),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'expiry_channel_id',
                'Expiry Alerts',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
        }
      }
    } catch (e) {
      debugPrint('❌ General error in scheduleDailyNotifications: $e');
    }
  }

  static Future<bool> _checkExactAlarmPermission() async {
    if (!Platform.isAndroid) return false;

    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) { // Android 12+
        return await Permission.scheduleExactAlarm.isGranted;
      }
      return true; // For versions below Android 12
    } catch (e) {
      debugPrint('❌ Error checking exact alarm permission: $e');
      return false;
    }
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    try {
      await _requestNotificationPermissions();
      await _notificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'expiry_channel_id',
            'Expiry Alerts',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error showing instant notification: $e');
    }
  }

  static Future<void> openExactAlarmSettings() async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } catch (e) {
        debugPrint('❌ Error opening exact alarm settings: $e');
      }
    }
  }

  static Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      await _requestNotificationPermissions();

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'expiry_channel_id',
        'Expiry Alerts',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      await _notificationsPlugin.initialize(
        const InitializationSettings(android: initializationSettingsAndroid),
        onDidReceiveNotificationResponse: (details) {
          // Handle notification tap
        },
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
      >()
          ?.createNotificationChannel(channel);
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
    }
  }

  static Future<void> _requestNotificationPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          final status = await Permission.notification.request();
          if (!status.isGranted) {
            debugPrint('Notification permission not granted');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permissions: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('❌ Error canceling notifications: $e');
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 31) {
          await Permission.scheduleExactAlarm.request();
        }
      } catch (e) {
        debugPrint('❌ Error requesting exact alarm permission: $e');
      }
    }
  }
}