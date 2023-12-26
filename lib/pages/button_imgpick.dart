import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/prof_provider.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:provider/provider.dart';

class ButtonImagePicker extends StatelessWidget {
  final String title;
  final bool isGallery;
  const ButtonImagePicker({Key? key, required this.isGallery, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AccPictureProvider>(context);
    return ListTile(
      onTap: () async {
        await prov.pickImage(isGallery);
      }, 
      title: Text(title)
    );
  }
}