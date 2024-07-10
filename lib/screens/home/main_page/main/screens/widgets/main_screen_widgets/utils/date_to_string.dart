DateTime parseDateTimeString(String dateTimeString) {
  return DateTime.parse(dateTimeString);
}

int getDay(String dateTimeString) {
  DateTime dateTime = parseDateTimeString(dateTimeString);
  return dateTime.day;
}

int getMonth(String dateTimeString) {
  DateTime dateTime = parseDateTimeString(dateTimeString);
  return dateTime.month;
}

int getYear(String dateTimeString) {
  DateTime dateTime = parseDateTimeString(dateTimeString);
  return dateTime.year;
}
