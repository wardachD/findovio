import 'package:intl/intl.dart';

class Advertisement {
  final int id;
  final int bannerStyle;
  final int promotionLevel;
  final int salon;
  final String titleLine1;
  final String titleLine2;
  final String textLine1;
  final String textLine2;
  final String specialText;
  final String dateOfOrder;
  final String dateStart;
  final String dateEnd;
  final double promotionPrice;
  final String image;

  Advertisement({
    required this.id,
    required this.bannerStyle,
    required this.promotionLevel,
    required this.salon,
    required this.titleLine1,
    required this.titleLine2,
    required this.textLine1,
    required this.textLine2,
    required this.specialText,
    required this.dateOfOrder,
    required this.dateStart,
    required this.dateEnd,
    required this.promotionPrice,
    required this.image,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      bannerStyle: json['banner_style'],
      promotionLevel: json['promotion_level'],
      salon: json['salon'],
      titleLine1: json['Title_line_1'],
      titleLine2: json['Title_line_2'],
      textLine1: json['Text_line_1'],
      textLine2: json['Text_line_2'],
      specialText: json['Special_text'],
      dateOfOrder: json['Date_of_order'],
      dateStart: json['Date_start'],
      dateEnd: json['Date_end'],
      promotionPrice: json['promotion_price'].toDouble(),
      image: json['image'],
    );
  }

  String getFormattedDateOfOrder() {
    // Parse the date string to a DateTime object
    DateTime date = DateTime.parse(dateOfOrder);

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    return formattedDate;
  }

  List<Advertisement> parseAdvertisementsList(List<dynamic> jsonList) {
    return jsonList.map((json) => Advertisement.fromJson(json)).toList();
  }
}
