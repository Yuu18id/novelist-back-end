import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/novel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/provider.dart';
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
          title: const Text('Detail'),
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
                            const Expanded(flex: 1, child: Text('Judul')),
                            Expanded(flex: 3, child: Text(_novel.name))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            const Expanded(flex: 1, child: Text('Penulis')),
                            Expanded(flex: 3, child: Text(_novel.author))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            const Expanded(flex: 1, child: Text('Kategori')),
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
                                ? const Text(
                                    'Lihat lebih sedikit',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Lihat Semua',
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
                      const Text('Reviews',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: MediaQuery.of(context).size.height / 28),
                      if (reviewList.isEmpty)
                        Center(
                          child: Text(
                            'Belum ada ulasan. \nJadilah yang pertama menuliskan penilaian Anda.',
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Tulis Ulasan Anda',
                          style: TextStyle(fontSize: 20),
                        ),
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(children: [
                                  isNoRate
                                      ? const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '  *required',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
                                          ))
                                      : const Text(''),
                                  Text('${_novel.name} Rating:'),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    unratedColor: Colors.grey[400],
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        currentRate = rating;
                                        isNoRate = false;
                                      });
                                      print(rating);
                                      print(isNoRate);
                                    },
                                  ),
                                ]),
                                SizedBox(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Review...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(8.0)),
                                    controller: reviewController,
                                    maxLines: 8,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      prefs =
                                          await SharedPreferences.getInstance();
                                      String? nameUser =
                                          prefs.getString("name");
                                      setState(() {
                                        if (currentRate != 0.0) {
                                          reviewList.add(Ink(
                                            color: Colors.blue[50],
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 50.0,
                                                child: Text(/* prov1
                                                    .currentUser!.username
                                                    .toString()[0] */"Guest"),
                                              ),
                                              title: Text(
                                                  /* '${prov1.currentUser!.username.toString()} | $currentRate' */"Guest"),
                                              subtitle: reviewController
                                                      .text.isNotEmpty
                                                  ? Text(reviewController.text)
                                                  : null,
                                            ),
                                          ));
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 20.0),
                                      child: Text('Kirim'),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    });

          },
          tooltip: 'Menulis Review',
          child: const Icon(Icons.comment),
        ));
  }
}
