import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/browse.dart';
import 'package:flutter_application_1/pages/favorites.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/test.dart';
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
  late AuthFirebase auth;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  List judul = ['Novelist', 'Browse'];
  List pages = [HomePage(), Browsepage()];
  final TextEditingController searchController = TextEditingController();

  String username = "";
  String name = "";
  String urlImg = "";

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final prov = Provider.of<ScreenPageProvider>(context);
    auth.getUser().then((value) {
      username = value!.email!;
      name = value.displayName ?? "";
      urlImg = value.photoURL ?? "";
    });
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          padding: const EdgeInsets.all(16.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(13, 71, 161, 1)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    username: username,
                    name: name,
                    urlImg: urlImg,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                prov.isLogInWithGoogle
                    ? CircleAvatar(
                        minRadius: 12,
                        maxRadius: 24,
                        backgroundImage: NetworkImage(urlImg),
                      )
                    : CircleAvatar(
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
                      Text(
                        widget.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Pengaturan Profil'),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(themeChange.darkTheme
                        ? Icons.nightlight
                        : Icons.light_mode),
                    title: Text(
                        themeChange.darkTheme ? 'Dark Theme' : 'Light Theme'),
                    trailing: Switch(
                      value: themeChange.darkTheme,
                      onChanged: (bool value) {
                        themeChange.darkTheme = value;
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.book),
                    title: const Text('List Novel'),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Testpage()));
                    },
                    leading: const Icon(Icons.book),
                    title: const Text('test'),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 160),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 10,
                      ),
                      ListTile(
                        onTap: (() {}),
                        leading: const Icon(Icons.chat),
                        trailing:
                            const Icon(Icons.keyboard_arrow_right_outlined),
                        title: const Text('Feedback'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutPage()));
                        },
                        leading: const Icon(Icons.info),
                        trailing:
                            const Icon(Icons.keyboard_arrow_right_outlined),
                        title: const Text('About'),
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Log Out"),
                                    content: const Text(
                                        "Apakah anda yakin ingin Log Out?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Kembali")),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              auth.signOut();
                                              auth.signOutFromGoogle();
                                            });
                                            Navigator.pushReplacement(
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(),
      ])),
      appBar: prov.isSearching
          ? PreferredSize(
              child: AppBar(
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      if (prov.isSearching) {
                        prov.isSearching = false;
                        searchController.clear();
                        prov.searchResults.clear();
                        prov.clearNovels();
                        // Setelah kembali dari mode pencarian, reset searchResults
                      }
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                title: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: 'Cari',
                        border: InputBorder.none),
                    onChanged: (query) {
                      setState(() {
                        prov.searchNovels(query);
                      });
                    },),
              ),
              preferredSize: Size.fromHeight(kToolbarHeight))
          : AppBar(
              title: Text(judul[_currentIndex]),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      prov.isSearching = true;
                    });
                  },
                ),
              ],
            ) /* AppBar(
        title: Text(judul[_currentIndex]),
        actions:[IconButton(onPressed: () {
            setState(() {
              prov.isSearching = true;
            });
        }, icon: Icon(Icons.search))] 
      ), */
      ,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Download'),
            BottomNavigationBarItem(
                icon: Icon(Icons.open_in_browser), label: 'Browse'),
          ]),
    );
  }
}
