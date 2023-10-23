class PersonalInfo {
  final String? name;
  final String? image;
  final String? lname;
  final String? created_at;

  PersonalInfo({
    required this.name,
    required this.image,
    required this.lname,
    required this.created_at,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['first_name'],
      image: json['profile_image'],
      lname: json['last_name'],
      created_at: json['created_at'],
    );
  }
}
