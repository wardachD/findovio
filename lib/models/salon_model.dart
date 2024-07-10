class SalonModel {
  final int id;
  final String name;
  final String addressCity;
  final String addressPostalCode;
  final String addressStreet;
  final String addressNumber;
  final String location;
  final String about;
  final String avatar;
  final String phoneNumber;
  final String email;
  final num distanceFromQuery;
  final int errorCode;
  final String flutterCategory;
  final String flutterGender;
  final List<Categories> categories;
  final double review;
  final List<int> salonProperties;
  final List<String>? salonGallery;

  const SalonModel(
      {required this.id,
      required this.name,
      required this.addressCity,
      required this.addressPostalCode,
      required this.addressStreet,
      required this.addressNumber,
      required this.location,
      required this.about,
      required this.avatar,
      required this.phoneNumber,
      required this.email,
      required this.distanceFromQuery,
      required this.errorCode,
      required this.flutterCategory,
      required this.flutterGender,
      required this.categories,
      required this.review,
      required this.salonProperties,
      this.salonGallery});

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      addressCity: json['address_city'] as String,
      addressPostalCode: json['address_postal_code'] as String,
      addressStreet: json['address_street'] as String,
      addressNumber: json['address_number'] as String,
      location: json['location'] as String,
      about: json['about'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      distanceFromQuery: json['distance_from_query'] as num,
      errorCode: json['error_code'] as int,
      flutterCategory: json['flutter_category'] as String,
      flutterGender: json['flutter_gender_type'] as String,
      categories: List<Categories>.from((json['categories'] as List)
          .map((categories) => Categories.fromJson(categories))),
      review: json['review'] as double,
      salonProperties: (json['codes'] as List<dynamic>?)
              ?.map((code) => code as int)
              .toList() ??
          <int>[],
      salonGallery: (json['gallery'] as List<dynamic>?)
              ?.map((url) => url as String)
              .toList() ??
          <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address_city'] = addressCity;
    data['address_postal_code'] = addressPostalCode;
    data['address_street'] = addressStreet;
    data['address_number'] = addressNumber;
    data['location'] = location;
    data['about'] = about;
    data['avatar'] = avatar;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['distance_from_query'] = distanceFromQuery;
    data['error_code'] = errorCode;
    data['flutter_category'] = flutterCategory;
    data['flutter_gender_type'] = flutterGender;
    data['categories'] = categories.map((v) => v.toJson()).toList();
    data['review'] = review;
    data['codes'] = salonProperties;
    data['gallery'] = salonGallery;
    return data;
  }
}

class Categories {
  final int id;
  final int salon;
  final String name;
  final List<Services> services;
  final bool isAvailable;

  Categories(
      {required this.id,
      required this.salon,
      required this.name,
      required this.services,
      required this.isAvailable});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] as int,
      salon: json['salon'] as int,
      name: json['name'] as String,
      services: List<Services>.from((json['services'] as List)
          .map((service) => Services.fromJson(service))),
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon'] = salon;
    data['name'] = name;
    data['services'] = services.map((v) => v.toJson()).toList();
    if (isAvailable != null) data['is_available'] = isAvailable;
    return data;
  }
}

class Services {
  final int id;
  final int salon;
  final int category;
  final String title;
  final String description;
  final String price;
  final int durationMinutes;
  final bool? isAvailable;

  Services(
      {required this.id,
      required this.salon,
      required this.category,
      required this.title,
      required this.description,
      required this.price,
      required this.durationMinutes,
      this.isAvailable});

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'] as int,
      salon: json['salon'] as int,
      category: json['category'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      durationMinutes: json['duration_minutes'] as int,
      isAvailable: json['is_available'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon'] = salon;
    data['category'] = category;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['duration_minutes'] = durationMinutes;
    if (isAvailable != null) data['is_available'] = isAvailable;
    return data;
  }
}
