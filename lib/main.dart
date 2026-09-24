import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const AcademicCalendarApp());
}

class AcademicCalendarApp extends StatelessWidget {
  const AcademicCalendarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'التقويم الأكاديمي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020617),
        cardColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF6366F1), secondary: Color(0xFFF59E0B)),
      ),
      home: const Directionality(textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }
}

class HolidayEvent {
  final int id;
  final String name;
  final DateTime startDate;
  final String duration;
  HolidayEvent({required this.id, required this.name, required this.startDate, required this.duration});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<HolidayEvent> events = [
    HolidayEvent(id: 1, name: "إجازة نهاية أسبوع مطولة", startDate: DateTime(2026, 10, 7), duration: "يومان"),
    HolidayEvent(id: 2, name: "إجازة نهاية أسبوع مطولة", startDate: DateTime(2026, 11, 8), duration: "يوم واحد"),
    HolidayEvent(id: 3, name: "إجازة منتصف الفصل الأول (الخريف)", startDate: DateTime(2026, 11, 19), duration: "10 أيام"),
    HolidayEvent(id: 4, name: "إجازة منتصف العام الدراسي", startDate: DateTime(2027, 1, 7), duration: "10 أيام"),
    HolidayEvent(id: 5, name: "إجازة نهاية أسبوع مطولة", startDate: DateTime(2027, 2, 7), duration: "يومان"),
    HolidayEvent(id: 6, name: "إجازة يوم التأسيس", startDate: DateTime(2027, 2, 21), duration: "يومان"),
    HolidayEvent(id: 7, name: "إجازة عيد الفطر المبارك", startDate: DateTime(2027, 2, 25), duration: "17 يوماً"),
    HolidayEvent(id: 8, name: "إجازة نهاية أسبوع مطولة", startDate: DateTime(2027, 4, 15), duration: "يوم واحد"),
    HolidayEvent(id: 9, name: "إجازة عيد الأضحى المبارك", startDate: DateTime(2027, 5, 6), duration: "17 يوماً"),
    HolidayEvent(id: 10, name: "إجازة نهاية العام الدراسي 1448هـ", startDate: DateTime(2027, 6, 17), duration: "إجازة نهاية العام"),
  ];

  List<int> subscribedIds = [];

  @override
  void initState() {
    super.initState();
    _initPermissionsAndPrefs();
  }

  Future<void> _initPermissionsAndPrefs() async {
    final android = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      subscribedIds = prefs.getStringList('sub_ids')?.map((e) => int.parse(e)).toList() ?? [];
    });
  }

  Future<void> _toggleAlert(HolidayEvent event) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (subscribedIds.contains(event.id)) {
        subscribedIds.remove(event.id);
        flutterLocalNotificationsPlugin.cancel(event.id);
      } else {
        subscribedIds.add(event.id);
        _scheduleAlert(event);
      }
    });
    await prefs.setStringList('sub_ids', subscribedIds.map((e) => e.toString()).toList());
  }

  Future<void> _scheduleAlert(HolidayEvent event) async {
    final scheduledDate = tz.TZDateTime.local(event.startDate.year, event.startDate.month, event.startDate.day, 8, 0);
    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.id,
        'تذكير بالإجازة 🌴',
        'اليوم تبدأ ${event.name} ومدتها ${event.duration}. إجازة سعيدة!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('academic_channel', 'إشعارات التقويم الأكاديمي', importance: Importance.max, priority: Priority.high),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    HolidayEvent? nextEvent;
    int minDays = 9999;
    for (var ev in events) {
      final diff = ev.startDate.difference(today).inDays;
      if (diff >= 0 && diff < minDays) {
        minDays = diff;
        nextEvent = ev;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        centerTitle: true,
        title: const Text('التقويم الأكاديمي 1448 - 1449هـ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (nextEvent != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1B4B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: const Text('الإجازة القادمة', style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 12)),
                  ),
                  const SizedBox(height: 8),
                  Text(nextEvent.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(minDays == 0 ? 'اليوم!' : 'متبقي $minDays يوم', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B))),
                  const SizedBox(height: 10),
                  Text('المدة: ${nextEvent.duration}  •  البداية: ${nextEvent.startDate.toString().split(' ')[0]}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          const SizedBox(height: 18),
          const Text('جدول الإجازات الرسمية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...events.map((ev) {
            final isSubbed = subscribedIds.contains(ev.id);
            final diffDays = ev.startDate.difference(today).inDays;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSubbed ? const Color(0xFF818CF8) : const Color(0xFF1E293B), width: isSubbed ? 2 : 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ev.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('التاريخ: ${ev.startDate.toString().split(' ')[0]}  •  المدة: ${ev.duration}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          diffDays > 0 ? 'متبقي $diffDays يوم' : (diffDays == 0 ? 'تبدأ اليوم' : 'انتهت'),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: diffDays >= 0 ? const Color(0xFFF59E0B) : Colors.white38),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(isSubbed ? Icons.notifications_active : Icons.notifications_none, color: isSubbed ? const Color(0xFFF59E0B) : Colors.white54),
                    onPressed: () => _toggleAlert(ev),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
