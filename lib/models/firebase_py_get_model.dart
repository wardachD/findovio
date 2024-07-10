class FirebasePyGetModel {
  final int id;
  String firebaseName;
  final String firebaseEmail;
  final String firebaseUid;
  final DateTime timestamp;
  final String? avatar;
  String? userCity;
  String? userStreet;
  String? userGender;
  String? userPhoneNumber;

  FirebasePyGetModel(
      {required this.id,
      required this.firebaseName,
      required this.firebaseEmail,
      required this.firebaseUid,
      required this.timestamp,
      this.avatar,
      this.userCity,
      this.userGender,
      this.userPhoneNumber,
      this.userStreet});

  factory FirebasePyGetModel.fromJson(Map<String, dynamic> json) {
    return FirebasePyGetModel(
      id: json['id'] as int,
      firebaseName: json['firebase_name'] as String,
      firebaseEmail: json['firebase_email'] as String,
      firebaseUid: json['firebase_uid'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_name': firebaseName,
      'firebase_email': firebaseEmail,
      'firebase_uid': firebaseUid,
      'timestamp': timestamp.toIso8601String(),
      'avatar': avatar,
    };
  }

  void setFireBaseName(String fireBaseName) {
    firebaseName = fireBaseName;
  }

  void setUserCity(String city) {
    userCity = city;
  }

  void setUserStreet(String street) {
    userStreet = street;
  }

  void setUserGender(String gender) {
    userGender = gender;
  }

  void setUserPhoneNumber(String phoneNumber) {
    userPhoneNumber = phoneNumber;
  }
}
