import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/pages/about.dart';
import 'package:flutter_application_1/pages/browse.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:localization/localization.dart';
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

  List judul = ['Novelist', 'browse_bottom_nav'.i18n()];
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
                    title: Text('profile_setting'.i18n()),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(themeChange.darkTheme
                        ? Icons.nightlight
                        : Icons.light_mode),
                    title: Text(themeChange.darkTheme
                        ? 'dark_theme'.i18n()
                        : 'light_theme'.i18n()),
                    trailing: Switch(
                      value: themeChange.darkTheme,
                      onChanged: (bool value) {
                        themeChange.darkTheme = value;
                      },
                    ),
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
                        title: Text('feedback'.i18n()),
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
                        title: Text('about'.i18n()),
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("logout".i18n()),
                                    content: Text("logout_alert".i18n()),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('back'.i18n())),
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
                                          child: Text('logout'.i18n()))
                                    ],
                                  ));
                        },
                        leading: const Icon(Icons.logout),
                        title: Text('logout'.i18n()),
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
                      hintText: 'search'.i18n(), border: InputBorder.none),
                  onChanged: (query) {
                    setState(() {
                      prov.searchNovels(query);
                    });
                  },
                ),
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
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.download), label: 'download'.i18n()),
            BottomNavigationBarItem(
                icon: Icon(Icons.open_in_browser), label: 'browse'.i18n()),
          ]),
    );
  }
}