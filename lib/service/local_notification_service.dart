import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id_1',
          'Default Channel',
          channelDescription: 'Used for scheduled notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
    /// Initialize timezone
    tz.initializeTimeZones();

    /// Initialize notification plugin
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(settings);

    /// Check if this is the first launch
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      // Request permissions on first launch
      await _requestNotificationPermissions();
      await prefs.setBool('is_first_launch', false);
    } else {
      // For subsequent launches, check if permissions were denied before
      if (await Permission.notification.isDenied) {
        // Optionally show a rationale before requesting again
        await _requestNotificationPermissions();
      }
    }
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
}
