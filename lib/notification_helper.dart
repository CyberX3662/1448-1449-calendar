import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // تهيئة المنطقة الزمنية لضمان عمل الإشعارات المجدولة بدقة
    tz.initializeTimeZones();
    
    // إعداد أيقونة الإشعار لنظام أندرويد
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
        
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleHolidayNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? soundFile, // متغير اختياري لتحديد ملف الصوت
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'academic_calendar_channel', // معرف القناة
      'إشعارات التقويم الأكاديمي', // اسم القناة
      channelDescription: 'تنبيهات بمواعيد الإجازات والمحاضرات',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // إذا تم تمرير اسم ملف صوتي، سيتم استخدامه، وإلا سيستخدم صوت النظام الافتراضي
      sound: soundFile != null ? RawResourceAndroidNotificationSound(soundFile) : null,
    );

    NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // دالة لإيقاف إشعار محدد
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // دالة لإيقاف جميع الإشعارات دفعة واحدة
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}

