import 'package:cloud_firestore/cloud_firestore.dart';
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

class BrowseDetailPage extends StatefulWidget {
  final String novel;
  const BrowseDetailPage({super.key, required this.novel});

  @override
  State<BrowseDetailPage> createState() => _TestDBrowselPageState();
}

class _TestDBrowselPageState extends State<BrowseDetailPage> {
  bool isWrap = true;

  bool isNoRate = true;
  double currentRate = 0.0;

  TextEditingController reviewController = TextEditingController();

  List<Widget> reviewList = [];
  late AuthFirebase auth;

  late SharedPreferences prefs;
  DBHelper _dbHelper = DBHelper.instance;
  Map<String, dynamic> novel = {};

  Future<DocumentSnapshot<Map<String, dynamic>>> getNovelByName(
      String name) async {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('novels');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collection.where('name', isEqualTo: name).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return Future.error('Dokumen tidak ditemukan');
    }
  }

  Future<Map<String, dynamic>?> getNovel() async {
    DocumentSnapshot<Map<String, dynamic>> document =
        await getNovelByName(widget.novel);

    if (document.exists) {
      setState(() {
        novel = document.data()!;
      });
    } else {
      print('Dokumen tidak ada');
    }
  }

  bool isDownloaded = false;
    Future isNovelDownloaded() async {
      var status = await DBHelper.instance.novelExists(widget.novel);
      print(status);
      if (status) {
        setState(() {
          isDownloaded = true;
        });
      } else {
        setState(() {
          isDownloaded = false;
        });
      }
    }

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
    getNovel();
    isNovelDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    

/*     print(isDownloaded); */
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: novel['synopsis'] == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: Image.network(novel['img']),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          horizontalTitleGap: 0,
                          leading: Text(
                            novel['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          trailing: isDownloaded? IconButton(onPressed: () {}, icon: Icon(Icons.download_done)) : IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () {},
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
                                  Expanded(flex: 3, child: Text(novel['name']))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Penulis')),
                                  Expanded(
                                      flex: 3, child: Text(novel['author']))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text('Kategori')),
                                  Expanded(flex: 3, child: Text(novel['genre']))
                                ],
                              ),
                            ),
                            isWrap
                                ? Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      novel['synopsis'],
                                      textAlign: TextAlign.justify,
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                    ))
                                : Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      novel['synopsis'],
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
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  child: isWrap == false
                                      ? const Text(
                                          'Lihat lebih sedikit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          'Lihat Semua',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 28),
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
                                            color: Colors.red, fontSize: 12),
                                      ))
                                  : const Text(''),
                              Text('aRating:'),
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
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: const EdgeInsets.all(8.0)),
                                controller: reviewController,
                                maxLines: 8,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  prefs = await SharedPreferences.getInstance();
                                  String? nameUser = prefs.getString("name");
                                  setState(() {
                                    if (currentRate != 0.0) {
                                      reviewList.add(Ink(
                                        color: Colors.blue[50],
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 50.0,
                                            child: Text(
                                                /* prov1
                                                    .currentUser!.username
                                                    .toString()[0] */
                                                "Guest"),
                                          ),
                                          title: Text(
                                              /* '${prov1.currentUser!.username.toString()} | $currentRate' */ "Guest"),
                                          subtitle:
                                              reviewController.text.isNotEmpty
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
