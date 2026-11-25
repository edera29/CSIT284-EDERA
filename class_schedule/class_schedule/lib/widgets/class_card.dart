
import 'package:flutter/material.dart';

import '../models/class_session.dart';
import '../theme/app_theme.dart';

class ClassCard extends StatelessWidget {
  final ClassSession classItem;

  const ClassCard({
    super.key,
    required this.classItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.background,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: AppTheme.darkRed,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 65,
              decoration: BoxDecoration(
                color: AppTheme.roseRed,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classItem.subjectCode,
                    style: const TextStyle(
                      color: AppTheme.darkRed,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    classItem.subjectName,
                    style: const TextStyle(
                      color: AppTheme.darkRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${classItem.scheduleTime}  |  ${classItem.room}',
                    style: const TextStyle(
                      color: AppTheme.mutedRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
