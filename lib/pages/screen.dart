import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/favorites.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key, required this.username, required this.email});
  final String username;
  final String email;

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List judul = ['Novelist', 'Favorites', 'Profile'];
  List pages = [HomePage(), FavoritesBodyPage()];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.lightBlue),
            child: prov.isLogin == false //&& prov.username == ''
                ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      minRadius: 12,
                      maxRadius: 24,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text('Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ])),
                  ])
                : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    CircleAvatar(
                      child: Icon(Icons.person),
                      minRadius: 12,
                      maxRadius: 24,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.username,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(widget.email,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ])),
                  ])),
        ListTile(
          onTap: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
          },
          leading: Icon(Icons.info),
          title: Text('About'),
          trailing: Icon(Icons.keyboard_arrow_right_outlined),
        ),
        if (prov.isLogin == true)
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Log Out"),
                        content: Text("Apakah anda yakin ingin Log Out?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Kembali")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  prov.login = false;
                                  prov.setUsername = '';
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text("Log Out"))
                        ],
                      ));
            },
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
          ),
        Divider(),
      ])),
      appBar: AppBar(
        title: Text(judul[_currentIndex]),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.thumb_up), label: 'Favorites'),
          ]),
    );
  }
}
