class UpdateProfileRequest {
  final String? name;
  final String? email;
  final String? phone;
  final String? dob;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;

  UpdateProfileRequest({
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.address,
    this.city,
    this.state,
    this.pincode,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (phone != null) 'phone': phone,
    if (dob != null) 'dob': dob,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (state != null) 'state': state,
    if (pincode != null) 'pincode': pincode,
  };
}

class BankAccount {
  final String id;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountType;
  final bool isPrimary;
  final bool isVerified;
  final String? branch;

  BankAccount({
    required this.id,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.accountType,
    required this.isPrimary,
    required this.isVerified,
    this.branch,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      accountHolderName: json['accountHolderName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      bankName: json['bankName'],
      accountType: json['accountType'] ?? 'SAVINGS',
      isPrimary: json['isPrimary'] ?? false,
      isVerified: json['isVerified'] ?? false,
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accountHolderName': accountHolderName,
    'accountNumber': accountNumber,
    'ifscCode': ifscCode,
    'bankName': bankName,
    'accountType': accountType,
    'isPrimary': isPrimary,
    'branch': branch,
  };
}

class Address {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String type;
  final bool isPrimary;

  Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.type,
    required this.isPrimary,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['label'],
      fullName: json['fullName'],
      phone: json['phone'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      type: json['type'] ?? 'home',
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'fullName': fullName,
    'phone': phone,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'state': state,
    'pincode': pincode,
    'type': type,
    'isPrimary': isPrimary,
  };
}

class UserSession {
  final String id;
  final String deviceName;
  final String deviceType;
  final String? location;
  final DateTime lastActivity;
  final bool isActive;

  UserSession({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    this.location,
    required this.lastActivity,
    required this.isActive,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'],
      deviceName: json['deviceName'],
      deviceType: json['deviceType'],
      location: json['location'],
      lastActivity: DateTime.parse(json['lastActivity']),
      isActive: json['isActive'] ?? false,
    );
  }
}

class SecuritySettings {
  final bool twoFactorEnabled;
  final bool dataSharing;
  final String profileVisibility;
  final bool readReceipts;

  SecuritySettings({
    required this.twoFactorEnabled,
    required this.dataSharing,
    required this.profileVisibility,
    required this.readReceipts,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      dataSharing: json['dataSharing'] ?? false,
      profileVisibility: json['profileVisibility'] ?? 'contacts',
      readReceipts: json['readReceipts'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'twoFactorEnabled': twoFactorEnabled,
    'dataSharing': dataSharing,
    'profileVisibility': profileVisibility,
    'readReceipts': readReceipts,
  };
}

class PasswordRequest {
  final String oldPassword;
  final String newPassword;

  PasswordRequest({required this.oldPassword, required this.newPassword});

  Map<String, dynamic> toJson() => {
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  };
}

class PaymentMethod {
  final String id;
  final String type; // 'CARD', 'NETBANKING', 'WALLET'
  final String? provider;
  final String? cardLast4;
  final String? cardNetwork;
  final int? expiryMonth;
  final int? expiryYear;
  final bool isPrimary;

  PaymentMethod({
    required this.id,
    required this.type,
    this.provider,
    this.cardLast4,
    this.cardNetwork,
    this.expiryMonth,
    this.expiryYear,
    required this.isPrimary,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      provider: json['provider'],
      cardLast4: json['cardLast4'],
      cardNetwork: json['cardNetwork'],
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'provider': provider,
    'cardLast4': cardLast4,
    'cardNetwork': cardNetwork,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'isPrimary': isPrimary,
  };
}
