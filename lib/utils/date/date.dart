import 'package:intl/intl.dart';

class DateUtil {
  static const DATE_FORMAT = 'dd/MM/yyyy';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }

  String getFormattedDate(DateTime dateTime) {
    List months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    String date = "";
    date = dateTime.day.toString() +
        " " +
        months[dateTime.month - 1].toString() +
        " " +
        dateTime.year.toString();
    return date;
  }
}

/*
String date(DateTime tm) {
      DateTime today = new DateTime.now();
      Duration oneDay = new Duration(days: 1);
      Duration twoDay = new Duration(days: 2);
      Duration oneWeek = new Duration(days: 7);
      String month;
      switch (tm.month) {
        case 1:
          month = "january";
          break;
        case 2:
          month = "february";
          break;
        case 3:
          month = "march";
          break;
        case 4:
          month = "april";
          break;
        case 5:
          month = "may";
          break;
        case 6:
          month = "june";
          break;
        case 7:
          month = "july";
          break;
        case 8:
          month = "august";
          break;
        case 9:
          month = "september";
          break;
        case 10:
          month = "october";
          break;
        case 11:
          month = "november";
          break;
        case 12:
          month = "december";
          break;
      }
    
      Duration difference = today.difference(tm);
    
      if (difference.compareTo(oneDay) < 1) {
        return "today";
      } else if (difference.compareTo(twoDay) < 1) {
        return "yesterday";
      } else if (difference.compareTo(oneWeek) < 1) {
        switch (tm.weekday) {
          case 1:
            return "monday";
          case 2:
            return "tuesday";
          case 3:
            return "wednesday";
          case 4:
            return "thursday";
          case 5:
            return "friday";
          case 6:
            return "saturday";
          case 7:
            return "sunday";
        }
      } else if (tm.year == today.year) {
        return '${tm.day} $month';
      } else {
        return '${tm.day} $month ${tm.year}';
      }
    } */
