class UserInfoDetails {
  UserInfoDetails(this.uid, this.email, this.providerData);

  /// The provider’s user ID for the user.
  final String uid;

  /// The user’s email address.
  final String email;

  //Provider Data
  final List<ProviderDetails> providerData;
}

class ProviderDetails {
  final String uid;

  final String email;

  ProviderDetails(this.uid, this.email);
}
