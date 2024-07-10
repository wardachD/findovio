class ServiceSearchModel {
  final String title;

  ServiceSearchModel({required this.title});

  factory ServiceSearchModel.fromJson(Map<String, dynamic> json) {
    return ServiceSearchModel(
      title: json['title'] ?? json['name'] ?? '',
    );
  }
}

class SalonSearchModel {
  final String name;
  final String addressCity;
  final String addressStreet;
  final String addressNumber;
  final String avatar;

  SalonSearchModel({
    required this.name,
    required this.addressCity,
    required this.addressStreet,
    required this.addressNumber,
    required this.avatar,
  });

  factory SalonSearchModel.fromJson(Map<String, dynamic> json) {
    return SalonSearchModel(
      name: json['name'] ?? '',
      addressCity: json['address_city'] ?? '',
      addressStreet: json['address_street'] ?? '',
      addressNumber: json['address_number'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

class SearchResults {
  final List<ServiceSearchModel> services;
  final List<SalonSearchModel> places;

  SearchResults({required this.services, required this.places});

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      services: (json['services'] as List<dynamic>? ?? [])
          .map((item) => ServiceSearchModel.fromJson(item))
          .toList(),
      places: (json['places'] as List<dynamic>? ?? [])
          .map((item) => SalonSearchModel.fromJson(item))
          .toList(),
    );
  }
}
