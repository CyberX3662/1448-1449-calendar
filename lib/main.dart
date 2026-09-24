import 'package:flutter/material.dart';

void main() {
  runApp(const AcademicCalendarApp());
}

enum HolidayType { longWeekend, midTerm, national, eid, yearEnd }

class Holiday {
  final String title;
  final String gregorianStart;
  final String hijriStart;
  final String gregorianReturn;
  final String hijriReturn;
  final String duration;
  final int daysRemaining;
  final HolidayType type;

  const Holiday({
    required this.title,
    required this.gregorianStart,
    required this.hijriStart,
    required this.gregorianReturn,
    required this.hijriReturn,
    required this.duration,
    required this.daysRemaining,
    required this.type,
  });

  Color get color {
    switch (type) {
      case HolidayType.longWeekend:
        return const Color(0xFF38BDF8); // أزرق سماوي عصري
      case HolidayType.midTerm:
        return const Color(0xFFFB923C); // برتقالي هادئ
      case HolidayType.national:
        return const Color(0xFF4ADE80); // أخضر زمردي
      case HolidayType.eid:
        return const Color(0xFFA855F7); // بنفسجي
      case HolidayType.yearEnd:
        return const Color(0xFFF43F5E); // وردي مميز
    }
  }

  String get typeName {
    switch (type) {
      case HolidayType.longWeekend:
        return 'عطلة مطولة';
      case HolidayType.midTerm:
        return 'إجازة فصلية';
      case HolidayType.national:
        return 'مناسبة وطنية';
      case HolidayType.eid:
        return 'إجازة عيد';
      case HolidayType.yearEnd:
        return 'نهاية العام';
    }
  }
}

class AcademicCalendarApp extends StatefulWidget {
  const AcademicCalendarApp({super.key});

  @override
  State<AcademicCalendarApp> createState() => _AcademicCalendarAppState();
}

class _AcademicCalendarAppState extends State<AcademicCalendarApp> {
  bool isHijri = false;

  final List<Holiday> holidays = const [
    Holiday(
      title: 'إجازة نهاية أسبوع مطولة',
      gregorianStart: '07-10-2026',
      hijriStart: '26-04-1448 هـ',
      gregorianReturn: '11-10-2026',
      hijriReturn: '30-04-1448 هـ',
      duration: 'يومان',
      daysRemaining: 13,
      type: HolidayType.longWeekend,
    ),
    Holiday(
      title: 'إجازة نهاية أسبوع مطولة',
      gregorianStart: '08-11-2026',
      hijriStart: '28-05-1448 هـ',
      gregorianReturn: '10-11-2026',
      hijriReturn: '01-06-1448 هـ',
      duration: 'يوم واحد',
      daysRemaining: 45,
      type: HolidayType.longWeekend,
    ),
    Holiday(
      title: 'إجازة منتصف الفصل الأول (الخريف)',
      gregorianStart: '19-11-2026',
      hijriStart: '10-06-1448 هـ',
      gregorianReturn: '29-11-2026',
      hijriReturn: '20-06-1448 هـ',
      duration: '10 أيام',
      daysRemaining: 56,
      type: HolidayType.midTerm,
    ),
    Holiday(
      title: 'إجازة منتصف العام الدراسي',
      gregorianStart: '07-01-2027',
      hijriStart: '29-07-1448 هـ',
      gregorianReturn: '17-01-2027',
      hijriReturn: '09-08-1448 هـ',
      duration: '10 أيام',
      daysRemaining: 105,
      type: HolidayType.midTerm,
    ),
    Holiday(
      title: 'إجازة نهاية أسبوع مطولة',
      gregorianStart: '07-02-2027',
      hijriStart: '01-09-1448 هـ',
      gregorianReturn: '10-02-2027',
      hijriReturn: '04-09-1448 هـ',
      duration: 'يومان',
      daysRemaining: 136,
      type: HolidayType.longWeekend,
    ),
    Holiday(
      title: 'إجازة يوم التأسيس',
      gregorianStart: '21-02-2027',
      hijriStart: '15-09-1448 هـ',
      gregorianReturn: '23-02-2027',
      hijriReturn: '17-09-1448 هـ',
      duration: 'يومان',
      daysRemaining: 150,
      type: HolidayType.national,
    ),
    Holiday(
      title: 'إجازة عيد الفطر المبارك',
      gregorianStart: '25-02-2027',
      hijriStart: '19-09-1448 هـ',
      gregorianReturn: '14-03-2027',
      hijriReturn: '06-10-1448 هـ',
      duration: '17 يوماً',
      daysRemaining: 154,
      type: HolidayType.eid,
    ),
    Holiday(
      title: 'إجازة نهاية أسبوع مطولة',
      gregorianStart: '15-04-2027',
      hijriStart: '09-11-1448 هـ',
      gregorianReturn: '18-04-2027',
      hijriReturn: '12-11-1448 هـ',
      duration: 'يوم واحد',
      daysRemaining: 203,
      type: HolidayType.longWeekend,
    ),
    Holiday(
      title: 'إجازة عيد الأضحى المبارك',
      gregorianStart: '06-05-2027',
      hijriStart: '30-11-1448 هـ',
      gregorianReturn: '23-05-2027',
      hijriReturn: '17-12-1448 هـ',
      duration: '17 يوماً',
      daysRemaining: 224,
      type: HolidayType.eid,
    ),
    Holiday(
      title: 'إجازة نهاية العام الدراسي 1448هـ',
      gregorianStart: '17-06-2027',
      hijriStart: '12-01-1449 هـ',
      gregorianReturn: 'بداية العام الجديد',
      hijriReturn: 'بداية العام الجديد',
      duration: 'إجازة نهاية العام',
      daysRemaining: 266,
      type: HolidayType.yearEnd,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final nextHoliday = holidays.first;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'التقويم الأكاديمي',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            elevation: 0,
            title: const Text(
              'التقويم الأكاديمي 1448 - 1449هـ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            actions: [
              // زر التحويل بين الهجري والميلادي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF334155),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.sync_alt, size: 16, color: Color(0xFF38BDF8)),
                  label: Text(
                    isHijri ? 'هجري' : 'ميلادي',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isHijri = !isHijri;
                    });
                  },
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // البطاقة العلوية التفاعلية
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4338CA).withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFF4338CA).withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'الإجازة القادمة',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nextHoliday.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'متبقي ${nextHoliday.daysRemaining} يوم',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFBBF24),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('البداية', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(
                                isHijri ? nextHoliday.hijriStart : nextHoliday.gregorianStart,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 26, color: Colors.white12),
                          Column(
                            children: [
                              const Text('العودة للدراسة', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(
                                isHijri ? nextHoliday.hijriReturn : nextHoliday.gregorianReturn,
                                style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'جدول الإجازات الرسمية',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),

              // بطاقات الإجازات مع الترميز اللوني
              ...holidays.map((h) => HolidayTile(holiday: h, isHijri: isHijri)),
            ],
          ),
        ),
      ),
    );
  }
}

class HolidayTile extends StatelessWidget {
  final Holiday holiday;
  final bool isHijri;

  const HolidayTile({super.key, required this.holiday, required this.isHijri});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: holiday.color, width: 4.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white38),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          holiday.title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: holiday.color.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          holiday.typeName,
                          style: TextStyle(
                            color: holiday.color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'البدء: ${isHijri ? holiday.hijriStart : holiday.gregorianStart}   •   المدة: ${holiday.duration}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, color: Color(0xFF34D399), size: 15),
                      const SizedBox(width: 5),
                      Text(
                        'العودة: ${isHijri ? holiday.hijriReturn : holiday.gregorianReturn}',
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'متبقي ${holiday.daysRemaining} يوم',
                    style: const TextStyle(
                      color: Color(0xFFFBBF24),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
