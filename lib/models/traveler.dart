class Traveler {
  const Traveler({
    required this.id,
    required this.fullName,
    required this.email,
  });

  final int id;
  final String fullName;
  final String email;

  factory Traveler.fromJson(Map<String, dynamic> json) => Traveler(
        id: json['id'] as int,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'full_name': fullName,
        'email': email,
      };
}
