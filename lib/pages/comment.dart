// class Comment {
//   final String text;
//   final DateTime timestamp;

//   Comment(this.text, this.timestamp);
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? username;
  String? reviewText;
  double? rating;
  String? bookName;

  ReviewModel(
    {
      this.username,
      this.rating,
      this.reviewText,
      this.bookName
    }
  );

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'rating': rating,
      'review': reviewText,
      'novel_title': bookName
    };
  }

  ReviewModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  : username = doc.data()?['username'],
    rating = doc.data()?['rating'],
    reviewText = doc.data()?['review'],
    bookName = doc.data()?['novel_title'];
}