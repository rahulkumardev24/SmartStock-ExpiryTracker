import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      for (int daysLeft = daysUntilExpiry; daysLeft >= 0; daysLeft--) {
        final notificationTime = firstNotificationDate.add(
          Duration(days: daysUntilExpiry - daysLeft),
        );

        // Skip past notifications
        if (notificationTime.isBefore(now)) continue;

        String notificationBody;
        if (daysLeft == 0) {
          notificationBody = '❗ $title expires TODAY!';
        } else if (daysLeft == 1) {
          notificationBody = '⚠️ $title expires tomorrow!';
        } else {
          notificationBody = '🔔 $title expires in $daysLeft days';
        }

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
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );

        debugPrint('✅ Scheduled notification for $notificationTime');
      }
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
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
  }

  static Future<void> openExactAlarmSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // Set up notification channel for Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'expiry_channel_id',
      'Expiry Alerts',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    // Initialize plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _notificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Create channel (Android 8.0+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestNotificationPermissions() async {
    // Request Notification Permission (Android 13+)
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ uses the new notification permission
        await Permission.notification.request();
      } else {
        // For older versions, we need to ensure notifications are enabled
        // This is usually handled by the notification channel creation
      }
    }

    // Check Exact Alarm Permission (Android 12+)
    if (Platform.isAndroid && await _isExactAlarmPermissionRequired()) {
      // Check if we already have permission
      final hasExactAlarmPermission = await _checkExactAlarmPermission();

      if (!hasExactAlarmPermission) {
        // Show a dialog explaining why we need this permission
        // Then open settings
        await openExactAlarmSettings();
      }
    }
  }

  // Helper method to check if exact alarm permission is needed
  static Future<bool> _isExactAlarmPermissionRequired() async {
    if (Platform.isAndroid) {
      final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      return sdkInt >= 31; // Android 12 (S) and above
    }
    return false;
  }

  // Helper method to check if exact alarm permission is granted
  static Future<bool> _checkExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        return await Permission.scheduleExactAlarm.isGranted;
      }
    }
    return true; // For versions that don't require this permission
  }

  // Add this method
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
