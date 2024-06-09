class UserData {
  final String nik;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String nationality;
  final String gender;
  final String religion;

  UserData({
    required this.nik,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.nationality,
    required this.gender,
    required this.religion,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      nik: json['nik'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      city: json['city'],
      nationality: json['nationality'],
      gender: json['gender'],
      religion: json['religion'],
    );
  }
}

class FatherData {
  final String nik;
  final String name;
  final String address;
  final String city;
  final String nationality;
  final String gender;
  final String religion;

  FatherData({
    required this.nik,
    required this.name,
    required this.address,
    required this.city,
    required this.nationality,
    required this.gender,
    required this.religion,
  });

  factory FatherData.fromJson(Map<String, dynamic> json) {
    return FatherData(
      nik: json['nik'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      nationality: json['nationality'],
      gender: json['gender'],
      religion: json['religion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'name': name,
      'address': address,
      'city': city,
      'nationality': nationality,
      'gender': gender,
      'religion': religion,
    };
  }
}
