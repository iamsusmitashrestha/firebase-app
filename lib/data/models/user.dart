class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String imageUrl;

  UserModel(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  UserModel copyWith(
      {String? id, String? email, String? fullName, String? imageUrl}) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
