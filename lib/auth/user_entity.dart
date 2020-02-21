class User {
  final String id;
  final String emailAddress;
  final String phoneNumber;
  final String countryCode;
  final String fullName;
  final String profileImageID;

  User(
      {this.id,
      this.emailAddress,
      this.phoneNumber,
      this.countryCode,
      this.fullName,
      this.profileImageID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      emailAddress: json['email_address'],
      phoneNumber: json['phone_number'],
      countryCode: json['country_code'],
      fullName: json['full_name'],
      profileImageID: json['profile_image_id'],
    );
  }
}
