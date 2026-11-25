
import 'package:flutter/material.dart';

import '../models/class_session.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static const List<String> days = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
  ];

  static const int startHour = 8;
  static const int endHour = 17;

  static const double hourHeight = 70;
  static const double dayWidth = 105;
  static const double timeWidth = 75;

  static final FirebaseService firebaseService = FirebaseService();

  Color getClassColor(String code) {
    switch (code) {
      case 'CSIT212':
        return AppTheme.roseRed;
      case 'CSIT226':
        return AppTheme.mutedRed;
      case 'CSIT228':
        return AppTheme.darkRed;
      case 'CSIT238':
        return AppTheme.deepRed;
      case 'CSIT284':
        return AppTheme.accentRed;
      case 'GE-CCS2':
        return AppTheme.mutedRed;
      case 'IT228':
        return AppTheme.roseRed;
      case 'PE206':
        return AppTheme.darkRed;
      default:
        return AppTheme.deepRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),

              const Text(
                'Weekly',
                style: TextStyle(
                  color: AppTheme.darkRed,
                  fontSize: 54,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),

              const Text(
                'Schedule',
                style: TextStyle(
                  color: AppTheme.darkRed,
                  fontSize: 54,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.darkRed,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'THIRD YEAR - SECOND SEMESTER',
                  style: TextStyle(
                    color: AppTheme.darkRed,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),

              const SizedBox(height: 45),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: timeWidth,
                          child: const Center(
                            child: HeaderPill(text: 'TIME'),
                          ),
                        ),

                        ...days.map(
                          (day) => SizedBox(
                            width: dayWidth,
                            child: Center(
                              child: HeaderPill(text: day),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    StreamBuilder<List<ClassSession>>(
                      stream: firebaseService.getClasses(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return SizedBox(
                            width: timeWidth + (dayWidth * 5),
                            height: 300,
                            child: Center(
                              child: Text(
                                'Error loading schedules:\n${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppTheme.darkRed,
                                ),
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
                          return const SizedBox(
                            width: 400,
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final allClasses = snapshot.data ?? [];

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: timeWidth,
                              height:
                                  (endHour - startHour) * hourHeight,
                              child: Column(
                                children: List.generate(
                                  endHour - startHour,
                                  (index) {
                                    int hour = startHour + index;

                                    return SizedBox(
                                      height: hourHeight,
                                      child: Center(
                                        child: Text(
                                          '${hour > 12 ? hour - 12 : hour}:00 - ${hour + 1 > 12 ? hour + 1 - 12 : hour + 1}:00',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppTheme.darkRed,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            Container(
                              width: 1,
                              height: (endHour - startHour) * hourHeight,
                              color: AppTheme.darkRed,
                            ),

                            ...List.generate(5, (index) {
                              int dayNumber = index + 1;

                              List<ClassSession> classes = allClasses
                                  .where(
                                    (item) => item.day == dayNumber,
                                  )
                                  .toList();

                              return SizedBox(
                                width: dayWidth,
                                height:
                                    (endHour - startHour) * hourHeight,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        endHour - startHour,
                                        (index) {
                                          return Container(
                                            height: hourHeight,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: AppTheme.darkRed
                                                      .withValues(
                                                    alpha: 0.15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    ...classes.map((item) {
                                      double top = (
                                        (item.startHour - startHour) +
                                        item.startMinute / 60
                                      ) * hourHeight;

                                      double height = (
                                        (item.endHour - item.startHour) +
                                        (item.endMinute -
                                                item.startMinute) /
                                            60
                                      ) * hourHeight;

                                      return Positioned(
                                        top: top + 2,
                                        left: 4,
                                        right: 4,
                                        height: height - 4,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: getClassColor(
                                              item.subjectCode,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: AppTheme.darkRed,
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item.subjectCode,
                                                  textAlign:
                                                      TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900,
                                                    fontSize: 11,
                                                  ),
                                                ),

                                                const SizedBox(height: 5),

                                                Text(
                                                  item.subjectName,
                                                  textAlign:
                                                      TextAlign.center,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 4),

                                                Text(
                                                  item.room,
                                                  textAlign:
                                                      TextAlign.center,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 8,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkRed,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'ROOM ASSIGNMENTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  children: [
                    RoomLegend(
                      color: AppTheme.roseRed,
                      text: 'ROOM 201',
                    ),
                    RoomLegend(
                      color: AppTheme.mutedRed,
                      text: 'ROOM 202',
                    ),
                    RoomLegend(
                      color: AppTheme.darkRed,
                      text: 'ROOM 203',
                    ),
                    RoomLegend(
                      color: AppTheme.deepRed,
                      text: 'ROOM 204',
                    ),
                    RoomLegend(
                      color: AppTheme.accentRed,
                      text: 'LAB 1',
                    ),
                    RoomLegend(
                      color: AppTheme.roseRed,
                      text: 'LAB 2',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderPill extends StatelessWidget {
  final String text;

  const HeaderPill({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.darkRed,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class RoomLegend extends StatelessWidget {
  final Color color;
  final String text;

  const RoomLegend({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135,
      child: Row(
        children: [
          Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.darkRed,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
