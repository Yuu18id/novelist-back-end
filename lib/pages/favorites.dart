import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

class FavoritesBodyPage extends StatefulWidget {
  const FavoritesBodyPage({super.key});

  @override
  State<FavoritesBodyPage> createState() => _FavoritesBodyPageState();
}

class _FavoritesBodyPageState extends State<FavoritesBodyPage> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    Map<String, dynamic>? user = prov.user["data"].firstWhere(
        (userData) => userData['username'] == prov.username,
        orElse: () => <String, Object>{});
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: prov.username == ''
            ? Center(
                child: Text(
                  'Silahkan Log In untuk menambahkan daftar favorit',
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(
                        user?['favorites'].length,
                        (index) {
                          return InkWell(
                            onTap: () {},
                            child: Stack(
                              children: [
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          user?["favorites"][index]['img']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      user?["favorites"][index]["name"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
