import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
    final String username;
    final String name;
    final String urlImg;

  const ProfilePage({super.key, required this.username, required this.name, required this.urlImg});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text("Profile"),
        ),
        body:prov.isLogInWithGoogle? Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              color: Colors.blue,
              height: 188,
              child: Image.asset("assets/cover.jpg"),
            ),
          ),
          Positioned(
            top: 128,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(urlImg),
                  ),
                  SizedBox(height: 20),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ) : Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
                  color: Colors.blue,
                  height: 188,
                  child: Image.asset("assets/cover.jpg"),
                  ),
          ),Positioned(
            top: 128,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    child: Icon(Icons.person, size: 55,),
                  ),
                  SizedBox(height: 20),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
          
          
    );
  }
}