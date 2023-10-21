class Novel {
  String name;
  String author;
  String img;
  String genre;
  String synopsis;

  Novel({
    required this.name,
    required this.author,
    required this.img,
    required this.genre,
    required this.synopsis,
  });

  // Konversi objek Novel menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'author': author,
      'img': img,
      'genre': genre,
      'synopsis': synopsis,
    };
  }

  // Konversi Map menjadi objek Novel
  factory Novel.fromMap(Map<String, dynamic> map) {
    return Novel(
      name: map['name'],
      author: map['author'],
      img: map['img'],
      genre: map['genre'],
      synopsis: map['synopsis'],
    );
  }
}
