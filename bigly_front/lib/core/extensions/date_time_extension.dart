
import 'package:intl/intl.dart';

extension DateTimeExtension on dynamic {
  String get getTimeFromTimeStamp {
    int timeStamp = int.parse(this) * 1000;
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);

    int differenceInHour = now.difference(dateTime).inHours;
    int differenceInDay = now.difference(dateTime).inDays;

    if (differenceInHour >= 24 && differenceInHour < 48) {
      return 'yesterday';
    } else
      if (differenceInHour >= 48 && differenceInHour < 72) {
      return '2 days ago';
    } else
      if (differenceInHour >= 72 && differenceInHour < 96) {
      return '3 days ago';
    } else

    if (differenceInDay > 3 && differenceInDay < 7) {
      switch (dateTime.weekday) {
        case 1:
          return 'Sunday';
        case 2:
          return 'Monday';
        case 3:
          return 'Tuesday';
        case 4:
          return 'Wednesday';
        case 5:
          return 'Thursday';
        case 6:
          return 'Friday';
        case 7:
          return 'Saturday';
      }
      return 'Monday';
    }

    if (differenceInDay >= 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }


    String formattedDate = DateFormat('HH:mm a').format(dateTime);
    return formattedDate;
  }
}