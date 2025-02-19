class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isMale;
  final String image; // Can be a URL or local path

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isMale,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isMale': isMale ? 1 : 0, // store as integer: 1 for true, 0 for false
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      isMale: map['isMale'] == 1,
      image: map['image'] as String,
    );
  }
}
