import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/novel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String novel;
  const DetailPage({super.key, required this.novel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isWrap = true;

  bool isNoRate = true;
  double currentRate = 0.0;

  TextEditingController reviewController = TextEditingController();

  List<Widget> reviewList = [];
  late AuthFirebase auth;

  late SharedPreferences prefs;
  DBHelper _dbHelper = DBHelper.instance;
  late Novel _novel;
  @override
  void initState() {
    super.initState();
    _loadNovel();
    auth = AuthFirebase();
  }

  Future<void> _loadNovel() async {
    final novel = await _dbHelper.getNovelByName(widget.novel);
    if (novel != null) {
      setState(() {
        _novel = novel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('detail'.i18n()),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  height: 300,
                  child: Image.network(_novel.img),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: /* prov1.currentUser == null
                      ? ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          horizontalTitleGap: 0,
                          leading: Text(
                            _novel.name,
                            style: const TextStyle(
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
                                      user['favorites'].contains(_novel.data);
                                  if (isNovelInFavorites) {
                                    user['favorites'].remove(_novel.data);
                                    setState(() {
                                      user['isFavorited'] == false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${_novel.name} dihapus dari favorit'),
                                    ));
                                  } else {
                                    user['favorites'].add(_novel.data);
                                    setState(() {
                                      user['isFavorited'] == true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${_novel.name} ditambahkan ke favorit'),
                                    ));
                                  }
                                }
                              },
                              icon: Icon(prov.user["data"]
                                          .firstWhere((userData) =>
                                              userData['username'] ==
                                              prov.username)['favorites']
                                          .contains(_novel.data) !=
                                      true
                                  ? Icons.favorite_border_outlined
                                  : Icons.favorite)),
                        )
                      :  */
                      ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    horizontalTitleGap: 0,
                    leading: Text(
                      _novel.name,
                      style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Text('title'.i18n())),
                            Expanded(flex: 3, child: Text(_novel.name))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                             Expanded(flex: 1, child: Text('author'.i18n())),
                            Expanded(flex: 3, child: Text(_novel.author))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                             Expanded(flex: 1, child: Text('genre'.i18n())),
                            Expanded(flex: 3, child: Text(_novel.genre))
                          ],
                        ),
                      ),
                      isWrap
                          ? Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                _novel.synopsis,
                                textAlign: TextAlign.justify,
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                              ))
                          : Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                _novel.synopsis,
                                textAlign: TextAlign.justify,
                              )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isWrap = !isWrap;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.blue[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            child: isWrap == false
                                ? Text(
                                    'see_less'.i18n(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    'see_more'.i18n(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('review'.i18n(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: MediaQuery.of(context).size.height / 28),
                      if (reviewList.isEmpty)
                        Center(
                          child: Text(
                            'no_review'.i18n(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: reviewList.length,
                            itemBuilder: (context, index) {
                              return reviewList[index];
                            },
                          ),
                        ),
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
