class Users {
  final String userId;
  final String username;
  final String email;
  final String bio;
  // final String pass;

  Users(
      {required this.userId,
      required this.username,
      required this.email,
      required this.bio
      // required this.pass,
      });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
        userId: map['userId'],
        email: map['email'],
        username: map['username'],
        bio: map['bio']
        // pass: map['pass']
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}
