class User {
  final int? id;
  final String username;
  final String pass;

  User({this.id, required this.username, required this.pass});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'pass': pass,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      pass: map['pass'],
    );
  }
}
