class DateTimeUtils {
  static int minutesInADay = 1440;

  static DateTime endOfDay(DateTime day) {
    return DateTime(day.year, day.month, day.day, 23, 59, 59, 999);
  }

  static DateTime startOfDay(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  static DateTime areOverlapping(DateTime leftDate, DateTime rightDate) {}
}
