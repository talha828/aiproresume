class ContactUs {
  final String title;
  final String email;
  final String conatct;
  final String detail;

  ContactUs({
    required this.title,
    required this.email,
    required this.conatct,
    required this.detail,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) {
    return ContactUs(
      title: json['title'],
      email: json['email'],
      conatct: json['contact'],
      detail: json['detail'],
    );
  }
}
