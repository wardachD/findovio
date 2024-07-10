class FirebasePyRegisterModel {
  final String? firebaseName;
  final String? firebaseEmail;
  final String? firebaseUid;

  FirebasePyRegisterModel({
    required this.firebaseName,
    required this.firebaseEmail,
    required this.firebaseUid,
  });

  factory FirebasePyRegisterModel.fromJson(Map<String, dynamic> json) {
    return FirebasePyRegisterModel(
      firebaseName: json['firebase_name'] as String,
      firebaseEmail: json['firebase_email'] as String,
      firebaseUid: json['firebase_uid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebase_name': firebaseName,
      'firebase_email': firebaseEmail,
      'firebase_uid': firebaseUid,
    };
  }
}
