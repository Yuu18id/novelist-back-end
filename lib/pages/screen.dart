import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/auth_provider.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/favorites.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key, required this.username});
  final String username;

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
  List pages = [const HomePage(), const FavoritesBodyPage()];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    final prov1 = Provider.of<AuthProvider>(context);
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(color: Colors.lightBlue),
            child: prov1.currentUser == null //&& prov.username == ''
                ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      minRadius: 12,
                      maxRadius: 24,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                child: const Text('Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ])),
                  ])
                : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const CircleAvatar(
                      minRadius: 12,
                      maxRadius: 24,
                      child: Icon(Icons.person),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.username,
                                  style: const TextStyle(
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
          leading: const Icon(Icons.info),
          title: const Text('About'),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
        ),
        if (prov1.currentUser != null)
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Log Out"),
                        content: const Text("Apakah anda yakin ingin Log Out?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Kembali")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  prov1.logout();
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              child: const Text("Log Out"))
                        ],
                      ));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
          ),
        const Divider(),
      ])),
      appBar: AppBar(
        title: Text(judul[_currentIndex]),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.thumb_up), label: 'Favorites'),
          ]),
    );
  }
}
