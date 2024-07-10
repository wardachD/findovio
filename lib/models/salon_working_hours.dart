class SalonWorkingHours {
  final int id;
  final int dayOfWeek;
  final String openTime;
  final String closeTime;
  final int timeSlotLength;
  final int salon;

  SalonWorkingHours({
    required this.id,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    required this.timeSlotLength,
    required this.salon,
  });

  factory SalonWorkingHours.fromJson(Map<String, dynamic> json) {
    return SalonWorkingHours(
      id: json['id'],
      dayOfWeek: json['day_of_week'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      timeSlotLength: json['time_slot_length'],
      salon: json['salon'],
    );
  }
}
