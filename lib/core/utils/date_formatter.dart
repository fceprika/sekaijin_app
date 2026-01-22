import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, {String locale = 'fr_FR'}) {
    return DateFormat.yMMMMd(locale).format(date);
  }

  static String formatShortDate(DateTime date, {String locale = 'fr_FR'}) {
    return DateFormat.yMd(locale).format(date);
  }

  static String formatTime(DateTime date, {String locale = 'fr_FR'}) {
    return DateFormat.Hm(locale).format(date);
  }

  static String formatDateTime(DateTime date, {String locale = 'fr_FR'}) {
    return DateFormat.yMMMMd(locale).add_Hm().format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'il y a $years an${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'il y a $months mois';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return 'il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return 'il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'à l\'instant';
    }
  }

  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }
}
