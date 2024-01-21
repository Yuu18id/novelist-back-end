import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/prof_provider.dart';
import 'package:flutter_application_1/components/txtbox.dart';
import 'package:flutter_application_1/pages/button_imgpick.dart';
import 'package:localization/localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String name;
  String urlImg;

  ProfilePage(
      {super.key,
      required this.username,
      required this.name,
      required this.urlImg});

  final currentUserDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  // Upload the image file to Firebase Storage
  Future<String> uploadImage(Image image) async {
    if (urlImg.isNotEmpty) {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('profilePictures');
      final TaskSnapshot snapshot = await storageRef.putFile(File(urlImg));
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    print('uploaded!');
    return '';
  }

  // Update the current user's document with the profile picture field
  Future<void> updateProfilePicture(Image image) async {
    String imageUrl = await uploadImage(image);
    currentUserDocRef.update({
      'profilePicture': imageUrl,
    });
    print('updated!');
  }

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
                title: Text(
                  "edit".i18n() +" $field",
                ),
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "enter".i18n()+" $field",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel'.i18n())),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(newValue),
                    child: Text('save'.i18n()),
                  )
                ],
              ));

      if (newValue.trim().isNotEmpty) {
        await userData.doc(currentUser!.uid).update({field: newValue});
      }
    }

    final provPic = Provider.of<AccPictureProvider>(context);

    void camera() async {
      if (await Permission.camera.status.isGranted) {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ButtonImagePicker(
                    isGallery: false,
                    title: 'camera'.i18n(),
                    
                  ),
                  ButtonImagePicker(
                    isGallery: true,
                    title: 'open_gallery'.i18n(),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'cancel'.i18n(),
                      textAlign: TextAlign.center,
                    ),
                    textColor: Colors.red[700],
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        var status = await Permission.camera.request();
        print(status);
        if (status == PermissionStatus.granted) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    ButtonImagePicker(
                      isGallery: false,
                      title: 'camera'.i18n(),
                    ),
                    ButtonImagePicker(
                      isGallery: true,
                      title: 'open_gallery'.i18n(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'cancel'.i18n(),
                        textAlign: TextAlign.center,
                      ),
                      textColor: Colors.red[700],
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else if (status == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        }
      }
    }

    Future getProfPic() async {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(currentUser!.uid).get();
      Map<String, dynamic>? datauser =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (datauser != null) {
        String profImg = datauser['profilePicture'];
        urlImg = profImg;
        print('get? $urlImg');
      } else {
        print('UrlImg is null');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('profile_setting'.i18n()),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic> ?? {};
              getProfPic();
              provPic.isImageLoaded ? urlImg = provPic.img!.path : null;
              provPic.isImageLoaded
                  ? updateProfilePicture(Image.file(File(urlImg)))
                  : null;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  // profile picture
                  SizedBox(
                      child: GestureDetector(
                    child: urlImg.isNotEmpty && provPic.isImageLoaded == false
                        ? CircleAvatar(
                            radius: 72, backgroundImage: NetworkImage(urlImg))
                        : urlImg.isNotEmpty && provPic.isImageLoaded == true
                            ? CircleAvatar(
                                radius: 72,
                                backgroundImage: FileImage(File(urlImg)))
                            : Icon(Icons.person, size: 72),
                    onTap: () {
                      camera();
                      print(urlImg);
                    },
                  )),

                  // user email
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      currentUser.email.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
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
                    text: userData['username'] ?? 'a',
                    nameSection: 'username'.i18n(),
                    onPressed: () => editField('username'),
                  ),
                  //bio
                  TextBox(
                    text: userData['bio'] ?? 'a',
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
