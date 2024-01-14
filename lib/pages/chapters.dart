import 'package:flutter/material.dart';

class ChaptersPage extends StatelessWidget {
  final String title;
  final String chapter;

  const ChaptersPage({super.key, required this.title, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Text(chapter.replaceAll('\\n','\n'), textAlign: TextAlign.justify,),
        ),
      ),
    );
  }
}
