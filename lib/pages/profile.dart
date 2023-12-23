import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/txtbox.dart';
import 'package:localization/localization.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String name;
  final String urlImg;

  const ProfilePage(
      {super.key,
      required this.username,
      required this.name,
      required this.urlImg});

  @override
  Widget build(BuildContext context) {
    //user
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = FirebaseFirestore.instance.collection('users');

    //edit field
    Future<void> editField(String field) async {
      String newValue = "";
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.grey[900],
                title: Text(
                  "Edit $field",
                  style: const TextStyle(color: Colors.white),
                ),
                content: TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(newValue),
                    child: const Text('Save'),
                  )
                ],
              ));

      if (newValue.trim().isNotEmpty) {
        await userData.doc(currentUser!.uid).update({field: newValue});
      }
    }

    return Scaffold(
        appBar: AppBar(
          title:  Text('profile_setting'.i18n()),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  // profile picture
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // user email
                  Text(
                    currentUser.email.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  //user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'my_detail'.i18n(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  //username
                  TextBox(
                    text: userData['username'],
                    nameSection: 'username'.i18n(),
                    onPressed: () => editField('username'),
                  ),
                  //bio
                  TextBox(
                    text: userData['bio'],
                    nameSection: 'Bio',
                    onPressed: () => editField('bio'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
