import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/novel.dart';
import 'package:flutter_application_1/pages/detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Novel> listNovel = [];
  final TextEditingController searchController = TextEditingController();

  Future initNovel() async {
    final prov = Provider.of<ScreenPageProvider>(context);
    List<Novel> novels = await DBHelper.instance.getNovels();
    setState(() {
      listNovel = novels;
      prov.novels = novels;
    });
  }

  Future<String> getImagePath(String imageName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String directoryPath = '${appDocumentsDirectory.path}/img_assets/';
    return '$directoryPath$imageName';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initNovel();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    
    return Scaffold(
        body: Center(
      child: FutureBuilder(
          future: DBHelper.instance.getNovels(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('Tidak ada data');
            } else {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: prov.isSearching
                            ? prov.searchResults.length 
                            : listNovel.length,
                        itemBuilder: (context, index) {
                          final novel = prov.isSearching
                              ? prov.searchResults[index]
                              : listNovel[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(novel: novel.name),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(novel.img),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      novel.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              // Menampilkan pesan jika tidak ada data.
            }
          }),
    ));
  }
}
