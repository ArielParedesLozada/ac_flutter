import 'package:acl_flutter/domain/models/topic_note.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    tz.initializeTimeZones();
    final deviceTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(deviceTimeZone.identifier));

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  static Future<void> requestNotificationsPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> cancelNotificationsForNote(TopicNote note) async {
    if (note.id == null) return;
    await flutterLocalNotificationsPlugin.cancel(id: note.id!);
    await flutterLocalNotificationsPlugin.cancel(id: note.id! + 100000);
  }

  static Future<void> updateNotificationForNote(TopicNote note) async {
    await cancelNotificationsForNote(note);
    await scheduleNotificationForTopicNote(note);
  }

  static Future<void> scheduleNotificationForTopicNote(TopicNote note) async {
    if (note.endDate == null || note.id == null) return;

    final androidDetails = AndroidNotificationDetails(
      'topic_notes_channel',
      'Topic Notes',
      importance: Importance.max,
      priority: Priority.high,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);

    final dayBefore = tz.TZDateTime.from(
      note.endDate!.subtract(const Duration(days: 1)),
      tz.local,
    );
    final onTheDay = tz.TZDateTime.from(note.endDate!, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: note.id!,
      title: '${note.topicName} vence mañana',
      body: '${note.content} finaliza mañana.',
      scheduledDate: dayBefore,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: note.id! + 100000,
      title: '${note.topicName} vence hoy',
      body: '${note.content} finaliza hoy.',
      scheduledDate: onTheDay,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
