import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (r) {

      },
    );

    await _requestPermission();
  }

  Future<void> _requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// PUBLIC: schedule all meal reminders
  Future<void> scheduleDailyMeals({
    required Future<String> Function() breakfastText,
    required Future<String> Function() lunchText,
    required Future<String> Function() dinnerText,
  }) async {
    await _schedule(
      id: 1,
      hour: 8,
      title: "Breakfast 🍳",
      bodyBuilder: breakfastText,
    );

    await _schedule(
      id: 2,
      hour: 14,
      title: "Lunch 🍛",
      bodyBuilder: lunchText,
    );

    await _schedule(
      id: 3,
      hour: 20,
      title: "Dinner 🍲",
      bodyBuilder: dinnerText,
    );
  }

  Future<void> _schedule({
    required int id,
    required int hour,
    required String title,
    required Future<String> Function() bodyBuilder,
  }) async {
    final body = await bodyBuilder();

    final scheduledDate = _nextInstance(hour);

    const androidDetails = AndroidNotificationDetails(
      'meal_channel',
      'Meal Suggestions',
      channelDescription: 'Daily meal ideas',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstance(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}