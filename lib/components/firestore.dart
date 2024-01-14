import 'package:cloud_firestore/cloud_firestore.dart';

class NovelModel {
  String? id;
  String name;
  String author;
  String img;
  String genre;
  String synopsis;
  List chapters;

  NovelModel(
      {this.id,
      required this.name,
      required this.author,
      required this.img,
      required this.genre,
      required this.synopsis,
      required this.chapters});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'author': author,
      'img': img,
      'genre': genre,
      'synopsis': synopsis,
      'chapters': chapters
    };
  }

  NovelModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()?['name'],
        author = doc.data()?['author'],
        img = doc.data()?['img'],
        genre = doc.data()?['genre'],
        synopsis = doc.data()?['synopsis'],
        chapters = doc.data()?['chapters'];
}
