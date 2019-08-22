import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTimeHelper {
  static String formatTime(DateTime dateTime) {
    final dateFormat = new DateFormat('HH:mm');

    return dateFormat.format(dateTime);
  }

  static String formatSimpleDate(DateTime dateTime) {
    final dateFormat = DateFormat('EEE d');

    return dateFormat.format(dateTime);
  }

  static String formatTalkDateTimeStart(DateTime dateTime) {
    final dateFormat = new  DateFormat('EEE, HH:mm');
    return dateFormat.format(dateTime);
  }

  static String formatTalkTimeEnd(DateTime dateTime) {
    final dateFormat = new  DateFormat('HH:mm');
    return dateFormat.format(dateTime);
  }

  static String formatToHumanReadableDifference(DateTime dateTime) {
    return timeago.format(dateTime);
  }
}