// lib/models/user_model.dart
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final double walletBalance;
  String? profilePicture;
  DateTime? emailVerifiedAt;
  DateTime? phoneVerifiedAt;
  bool isTwoFactorEnabled;
  Map<String, dynamic>? preferences;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.walletBalance,
    this.profilePicture,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.isTwoFactorEnabled = false,
    this.preferences,
  });

  String get fullName => '$firstName $lastName';

  bool get isEmailVerified => emailVerifiedAt != null;
  bool get isPhoneVerified => phoneVerifiedAt != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    'walletBalance': walletBalance,
    'profilePicture': profilePicture,
    'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
    'phoneVerifiedAt': phoneVerifiedAt?.toIso8601String(),
    'isTwoFactorEnabled': isTwoFactorEnabled,
    'preferences': preferences,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    walletBalance: json['walletBalance']?.toDouble() ?? 0.0,
    profilePicture: json['profilePicture'],
    emailVerifiedAt: json['emailVerifiedAt'] != null 
        ? DateTime.parse(json['emailVerifiedAt'])
        : null,
    phoneVerifiedAt: json['phoneVerifiedAt'] != null
        ? DateTime.parse(json['phoneVerifiedAt'])
        : null,
    isTwoFactorEnabled: json['isTwoFactorEnabled'] ?? false,
    preferences: json['preferences'],
  );
}