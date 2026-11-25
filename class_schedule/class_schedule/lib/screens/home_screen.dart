
import 'package:flutter/material.dart';

import '../models/class_session.dart';
import '../services/firebase_service.dart';
import '../widgets/class_card.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    List<String> dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const Text(
                'Weekly',
                style: TextStyle(
                  color: AppTheme.darkRed,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),

              const Text(
                'Schedule',
                style: TextStyle(
                  color: AppTheme.darkRed,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                '${dayNames[now.weekday - 1].toUpperCase()}  |  ${now.month}/${now.day}/${now.year}',
                style: const TextStyle(
                  color: AppTheme.mutedRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 25),

              StreamBuilder<List<ClassSession>>(
                stream: firebaseService.getClasses(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading schedules.',
                        style: TextStyle(
                          color: AppTheme.darkRed,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<ClassSession> allClasses = snapshot.data!;

                  List<ClassSession> todayClasses = allClasses
                      .where((item) => item.day == now.weekday)
                      .toList();

                  todayClasses.sort((a, b) {
                    int first =
                        a.startHour * 60 + a.startMinute;
                    int second =
                        b.startHour * 60 + b.startMinute;
                    return first.compareTo(second);
                  });

                  List<ClassSession> upcomingClasses =
                      todayClasses.where((item) {
                    DateTime classTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      item.startHour,
                      item.startMinute,
                    );

                    return classTime.isAfter(now);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.darkRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "TODAY'S NEXT CLASS",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              upcomingClasses.isNotEmpty
                                  ? upcomingClasses.first.subjectCode
                                  : 'No Upcoming Classes',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            if (upcomingClasses.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                upcomingClasses.first.subjectName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${upcomingClasses.first.scheduleTime}  |  ${upcomingClasses.first.room}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ] else
                              const Text(
                                'Enjoy your free time!',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "TODAY'S CLASSES",
                        style: TextStyle(
                          color: AppTheme.darkRed,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (todayClasses.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              'No classes scheduled today.',
                              style: TextStyle(
                                color: AppTheme.mutedRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ...todayClasses.map(
                        (item) => ClassCard(classItem: item),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.darkRed,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${allClasses.map((item) => item.subjectCode).toSet().length}',
                              style: const TextStyle(
                                fontSize: 35,
                                color: AppTheme.darkRed,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              'ENROLLED SUBJECTS',
                              style: TextStyle(
                                color: AppTheme.darkRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '21 TOTAL ACADEMIC UNITS',
                              style: TextStyle(
                                color: AppTheme.mutedRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
