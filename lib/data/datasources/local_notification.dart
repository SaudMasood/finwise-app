
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../core/prefrences/app_prefrences.dart';

class LocalNotificationService {
  LocalNotificationService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FlutterLocalNotificationsPlugin? plugin,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance,
        notifications = plugin ?? FlutterLocalNotificationsPlugin();

  static final LocalNotificationService instance =
  LocalNotificationService();

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FlutterLocalNotificationsPlugin notifications;

  bool _initialized = false;

  static const Map<String, bool> defaultSettings = {
    'generalNotification': true,
    'sound': true,
    'soundCall': true,
    'vibrate': true,
    'transactionUpdate': true,
    'expenseReminder': true,
    'budgetNotifications': true,
    'lowBalanceAlerts': true,
  };

  CollectionReference<Map<String, dynamic>> get notificationCollection {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Please log in first.');
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications');
  }

  // INITIALIZATION

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (error) {
      debugPrint('Timezone setup failed: $error');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await notifications.initialize(
      settings: initializationSettings,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  // NOTIFICATION SETTINGS

  Future<Map<String, bool>> getSettings() async {
    final uid = auth.currentUser?.uid ?? 'guest';

    final savedSettings =
    await AppPreferences.getNotificationSettings(uid);

    // Ensure every supported setting has a value.
    return {
      for (final entry in defaultSettings.entries)
        entry.key: savedSettings[entry.key] ?? entry.value,
    };
  }

  Future<void> updateSetting(String key, bool value) async {
    if (!defaultSettings.containsKey(key)) {
      throw ArgumentError('Unknown notification setting: $key');
    }

    final uid = auth.currentUser?.uid ?? 'guest';

    await AppPreferences.saveNotificationSetting(
      uid: uid,
      key: key,
      enabled: value,
    );

    if (key == 'generalNotification' ||
        key == 'expenseReminder') {
      await refreshReminderSchedule();
    }
  }

  Future<bool> isEnabled(String type) async {
    final settings = await getSettings();

    if (settings['generalNotification'] != true) {
      return false;
    }

    switch (type.toLowerCase()) {
      case 'expense':
      case 'income':
      case 'transaction':
        return settings['transactionUpdate'] == true;

      case 'reminder':
      case 'expense_reminder':
        return settings['expenseReminder'] == true;

      case 'low_balance':
        return settings['lowBalanceAlerts'] == true;

      case 'budget':
        return settings['budgetNotifications'] == true;

      default:
        return true;
    }
  }

  // FIRESTORE NOTIFICATION RECORDS

  Future<String?> createNotification({
    required String title,
    required String message,
    required String type,
    String details = '',
    DateTime? scheduledAt,
  }) async {
    if (auth.currentUser == null) return null;

    if (!await isEnabled(type)) return null;

    final document = await notificationCollection.add({
      'title': title,
      'message': message,
      'details': details,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'scheduledAt': scheduledAt == null
          ? null
          : Timestamp.fromDate(scheduledAt),
    });

    return document.id;
  }


  // SHOW LOCAL NOTIFICATION

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String type,
    String? payload,
  }) async {
    await initialize();

    if (!await isEnabled(type)) return;

    final settings = await getSettings();

    await notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'finwise_$type',
          'FinWise ${type.replaceAll('_', ' ')}',
          channelDescription: 'FinWise financial notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: settings['sound'] == true,
          enableVibration: settings['vibrate'] == true,
        ),
      ),
      payload: payload,
    );
  }

  // TRANSACTION NOTIFICATIONS

  Future<void> addTransactionNotification({
    required String title,
    required String message,
    required String details,
    required String type,
  }) async {
    if (!await isEnabled(type)) return;

    await createNotification(
      title: title,
      message: message,
      details: details,
      type: type,
    );

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(
        2147483647,
      ),
      title: title,
      body: message,
      type: type,
      payload: type,
    );
  }

  // LOW BALANCE ALERTS

  Future<void> addLowBalanceNotification({
    required double balance,
  }) async {
    if (!await isEnabled('low_balance')) return;

    final message =
        'Your current balance is Rs. ${balance.toStringAsFixed(2)}.';

    await createNotification(
      title: 'Low Balance Alert',
      message: message,
      details: 'Your balance is below Rs. 5,000.',
      type: 'low_balance',
    );

    await showNotification(
      id: 5002,
      title: 'Low Balance Alert',
      body: message,
      type: 'low_balance',
      payload: 'low_balance',
    );
  }

  // SCHEDULE A REMINDER

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await initialize();

    if (!await isEnabled('reminder')) {
      await cancelReminder(id);
      return;
    }

    if (!scheduledDate.isAfter(DateTime.now())) {
      throw ArgumentError(
        'Choose a future reminder date and time.',
      );
    }

    final scheduledTime =
    tz.TZDateTime.from(scheduledDate, tz.local);

    final settings = await getSettings();

    await notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'finwise_reminders',
          'FinWise Reminders',
          channelDescription: 'Scheduled finance reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: settings['sound'] == true,
          enableVibration: settings['vibrate'] == true,
        ),
      ),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'reminder:$id',
    );

    if (auth.currentUser != null) {
      await notificationCollection.doc('reminder_$id').set({
        'title': title,
        'message': body,
        'details': 'Reminder scheduled for $scheduledTime',
        'type': 'reminder',
        'createdAt': FieldValue.serverTimestamp(),
        'scheduledAt': Timestamp.fromDate(scheduledDate),
        'isRead': false,
      });
    }
  }

  // DEFAULT WEEKLY EXPENSE REMINDER

  Future<void> scheduleDefaultWeeklyExpenseReminder() async {
    await initialize();

    final settings = await getSettings();

    if (settings['generalNotification'] != true ||
        settings['expenseReminder'] != true) {
      await cancelReminder(5001);
      return;
    }

    final now = tz.TZDateTime.now(tz.local);

    var nextSunday = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
    );

    while (nextSunday.weekday != DateTime.sunday ||
        !nextSunday.isAfter(now)) {
      nextSunday = nextSunday.add(const Duration(days: 1));
    }

    await notifications.zonedSchedule(
      id: 5001,
      title: 'Weekly Expense Reminder',
      body: 'Time to review your weekly expenses in FinWise.',
      scheduledDate: nextSunday,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'finwise_weekly_expenses',
          'Weekly Expense Reminders',
          channelDescription: 'Weekly reminders to review expenses',
          importance: Importance.high,
          priority: Priority.high,
          playSound: settings['sound'] == true,
          enableVibration: settings['vibrate'] == true,
        ),
      ),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents:
      DateTimeComponents.dayOfWeekAndTime,
    );

    if (auth.currentUser != null) {
      await notificationCollection
          .doc('weekly_expense_reminder')
          .set({
        'title': 'Weekly Expense Reminder',
        'message': 'Time to review your weekly expenses in FinWise.',
        'details': 'Every Sunday at 8:00 PM',
        'type': 'reminder',
        'createdAt': FieldValue.serverTimestamp(),
        'scheduledAt': Timestamp.fromDate(nextSunday),
        'isRead': false,
      }, SetOptions(merge: true));
    }
  }


  Future<void> refreshReminderSchedule() async {
    final settings = await getSettings();

    if (settings['generalNotification'] != true ||
        settings['expenseReminder'] != true) {
      await cancelReminder(5001);
      return;
    }

    await scheduleDefaultWeeklyExpenseReminder();
  }
//bug noti
  Future<void> addBudgetNotification({
    required String title,
    required String message,
    required String details,
  }) async {
    if (!await isEnabled('budget')) return;

    await createNotification(
      title: title,
      message: message,
      details: details,
      type: 'budget',
    );

    await showNotification(
      id: 5003,
      title: title,
      body: message,
      type: 'budget',
      payload: 'budget',
    );
  }

  Future<void> cancelReminder(int id) async {
    await notifications.cancel(id: id);
  }
}
