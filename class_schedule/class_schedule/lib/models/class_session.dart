
class ClassSession {
  final String id;
  final String subjectCode;
  final String subjectName;
  final int day;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String room;

  ClassSession({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.day,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.room,
  });

  String formatTime(int hour, int minute) {
    int displayHour = hour % 12;

    if (displayHour == 0) {
      displayHour = 12;
    }

    String period = hour < 12 ? 'AM' : 'PM';
    String minutes = minute.toString().padLeft(2, '0');

    return '$displayHour:$minutes $period';
  }

  String get startTime => formatTime(startHour, startMinute);

  String get endTime => formatTime(endHour, endMinute);

  String get scheduleTime => '$startTime - $endTime';


  factory ClassSession.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return ClassSession(
      id: id,
      subjectCode: data['subjectCode'] ?? '',
      subjectName: data['subjectName'] ?? '',
      day: data['day'] ?? 1,
      startHour: data['startHour'] ?? 8,
      startMinute: data['startMinute'] ?? 0,
      endHour: data['endHour'] ?? 9,
      endMinute: data['endMinute'] ?? 0,
      room: data['room'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'day': day,
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'room': room,
    };
  }
}
