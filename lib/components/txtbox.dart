import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String nameSection;
  final void Function()? onPressed;
  const TextBox(
      {super.key,
      required this.text,
      required this.nameSection,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nameSection,
            style: TextStyle(color: Colors.grey[500]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.drive_file_rename_outline,
                    color: Colors.grey[400],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
