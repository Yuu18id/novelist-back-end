import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/components/auth_provider.dart';

class DetailPage extends StatefulWidget {
  final Map data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    final prov1 = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: Image.asset(widget.data["img"]),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: prov1.currentUser == null
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        horizontalTitleGap: 0,
                        leading: Text(
                          widget.data["name"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Map<String, dynamic>? user = prov.user["data"]
                                  .firstWhere((userData) =>
                                      userData['username'] == prov.username);

                              if (user != null) {
                                bool isNovelInFavorites =
                                    user['favorites'].contains(widget.data);
                                if (isNovelInFavorites) {
                                  user['favorites'].remove(widget.data);
                                  setState(() {
                                    user['isFavorited'] == false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        '${widget.data["name"]} dihapus dari favorit'),
                                  ));
                                } else {
                                  user['favorites'].add(widget.data);
                                  setState(() {
                                    user['isFavorited'] == true;
                                  });
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${widget.data["name"]} ditambahkan ke favorit'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(prov.user["data"]
                                        .firstWhere((userData) =>
                                            userData['username'] ==
                                            prov.username)['favorites']
                                        .contains(widget.data) !=
                                    true
                                ? Icons.favorite_border_outlined
                                : Icons.favorite)),
                      )
                    : ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        horizontalTitleGap: 0,
                        leading: Text(
                          widget.data["name"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text('Judul')),
                          Expanded(flex: 3, child: Text(widget.data["name"]))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text('Penulis')),
                          Expanded(flex: 3, child: Text(widget.data["author"]))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text('Kategori')),
                          Expanded(flex: 3, child: Text(widget.data["genre"]))
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          widget.data["synopsis"],
                          textAlign: TextAlign.justify,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
