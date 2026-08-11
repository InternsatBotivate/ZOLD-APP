import '../../core/constants/api_constants.dart';

enum KycStatus { pending, approved, rejected, incomplete }

class Kyc {
  final String id;
  final KycStatus status;
  final String? panNumber;
  final String? aadhaarNumber;
  final DateTime? verifiedAt;
  final String? rejectionReason;

  Kyc({
    required this.id,
    required this.status,
    this.panNumber,
    this.aadhaarNumber,
    this.verifiedAt,
    this.rejectionReason,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      id: json['id']?.toString() ?? '',
      status: _parseStatus(json['status']?.toString()),
      panNumber: json['panNumber']?.toString(),
      aadhaarNumber: json['aadhaarNumber']?.toString(),
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.tryParse(json['verifiedAt'].toString())
          : null,
      rejectionReason: json['rejectionReason']?.toString(),
    );
  }

  static KycStatus _parseStatus(String? status) {
    switch (status) {
      case 'APPROVED':
        return KycStatus.approved;
      case 'REJECTED':
        return KycStatus.rejected;
      case 'PENDING':
        return KycStatus.pending;
      default:
        return KycStatus.incomplete;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name.toUpperCase(),
      'panNumber': panNumber,
      'aadhaarNumber': aadhaarNumber,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }
}

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String role;
  final String? adminRole;
  final String? profilePicture;
  final String? dob;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final bool? isVerified;
  final String? referralCode;
  final Kyc? kyc;
  final UserInventory? inventory;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    required this.role,
    this.adminRole,
    this.profilePicture,
    this.dob,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.isVerified,
    this.referralCode,
    this.kyc,
    this.inventory,
    this.createdAt,
  });

  String? get profilePictureUrl {
    if (profilePicture == null || profilePicture!.isEmpty) return null;
    if (profilePicture!.startsWith('http')) return profilePicture;

    // Fallback for relative paths - get host from ApiConstants
    final String baseHost = ApiConstants.baseUrl.replaceAll('/api', '');
    return '$baseHost${profilePicture!.startsWith('/') ? '' : '/'}$profilePicture';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'USER',
      adminRole: json['adminRole']?.toString(),
      profilePicture: (json['profilePicture'] ?? json['profile_picture'])
          ?.toString(),
      dob: json['dob']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      pincode: json['pincode']?.toString(),
      isVerified: json['isVerified'] is bool
          ? json['isVerified']
          : (json['isVerified'] == 1 || json['isVerified'] == 'true'),
      referralCode: json['referralCode']?.toString(),
      kyc: json['kyc'] != null && json['kyc'] is Map<String, dynamic>
          ? Kyc.fromJson(json['kyc'])
          : null,
      inventory:
          json['inventory'] != null && json['inventory'] is Map<String, dynamic>
          ? UserInventory.fromJson(json['inventory'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'adminRole': adminRole,
      'profilePicture': profilePicture,
      'dob': dob,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isVerified': isVerified,
      'referralCode': referralCode,
      'kyc': kyc?.toJson(),
      'inventory': inventory?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class UserInventory {
  final double goldBalance;
  final double silverBalance;

  UserInventory({required this.goldBalance, required this.silverBalance});

  factory UserInventory.fromJson(Map<String, dynamic> json) {
    return UserInventory(
      goldBalance:
          double.tryParse(json['goldBalance']?.toString() ?? '0') ?? 0.0,
      silverBalance:
          double.tryParse(json['silverBalance']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'goldBalance': goldBalance, 'silverBalance': silverBalance};
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class SignupRequest {
  final String name;
  final String email;
  final String username;
  final String password;
  final String? phone;
  final String? city;
  final String? referralCode;

  SignupRequest({
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.phone,
    this.city,
    this.referralCode,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'username': username,
    'password': password,
    'phone': phone,
    'city': city,
    'referralCode': referralCode,
  };
}

class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String enteredOtp;
  final String newPassword;

  ResetPasswordRequest({required this.enteredOtp, required this.newPassword});

  Map<String, dynamic> toJson() => {
    'enteredOtp': enteredOtp,
    'newPassword': newPassword,
  };
}
