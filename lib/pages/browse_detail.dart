import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/components/notification.dart';
import 'package:flutter_application_1/pages/chapters.dart';
import 'package:flutter_application_1/pages/comment.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/novel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localization/localization.dart';
import 'package:path_provider/path_provider.dart';
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

  List<ReviewModel> reviewList = [];
  List<ReviewModel> chapterList = [];
  late AuthFirebase auth;

  final Noti noti = Noti();

  Future<void> getComments() async {
    await Firebase.initializeApp();
    final collection = FirebaseFirestore.instance.collection('comments');
    final querySnapshot = await collection.get();
    final docs = querySnapshot.docs;
    setState(() {
      reviewList = docs
          .map((doc) => ReviewModel.fromDocSnapshot(doc))
          .where((rev) => rev.bookName == widget.novel)
          .toList();
    });
  }

  Future<void> getChapters() async {
    await Firebase.initializeApp();
    final collection = FirebaseFirestore.instance.collection('chapters');
    final querySnapshot = await collection.get();
    final docs = querySnapshot.docs;
    setState(() {
      reviewList = docs
          .map((doc) => ReviewModel.fromDocSnapshot(doc))
          .where((rev) => rev.bookName == widget.novel)
          .toList();
    });
  }

  bool isDeleted = false;

  late SharedPreferences prefs;
  //DBHelper _dbHelper = DBHelper.instance;
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
      return Future.error('document_not_found'.i18n());
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
    return null;
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

  downloadNovel() {
    final novel_data = Novel(
      name: novel['name'],
      author: novel['author'],
      img: novel['img'],
      genre: novel['genre'],
      synopsis: novel['synopsis'],
    );
    DBHelper.instance.insertNovel(novel_data);
  }

  Future<void> downloadAndSaveImage(String imageUrl, String imageName) async {
    var response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String directoryPath = '${appDocumentsDirectory.path}/img_assets/';
      String filePath = '$directoryPath$imageName';

      // Buat direktori jika belum ada
      Directory(directoryPath).createSync(recursive: true);

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      // Handle error jika unduhan gambar gagal
      throw Exception('Failed to download image');
    }
  }

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
    getNovel();
    isNovelDownloaded();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
/*     print(isDownloaded); */
    return Scaffold(
        appBar: AppBar(
          title: Text('detail'.i18n()),
        ),
        body: novel['synopsis'] == null
            ? const CircularProgressIndicator()
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
                          trailing: isDownloaded
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.download_done))
                              : IconButton(
                                  icon: const Icon(Icons.download),
                                  onPressed: () async {
                                    var connectivityResult =
                                        await Connectivity()
                                            .checkConnectivity();

                                    if (connectivityResult ==
                                        ConnectivityResult.none) {
                                      // Tidak ada koneksi internet
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('no_internet'.i18n()),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      noti.showLocalNoti(
                                        'download'.i18n(), 'download_success'.i18n());
                                      downloadNovel();
                                      downloadAndSaveImage(
                                          novel["img"], novel["name"]);
                                      setState(() {
                                        isDownloaded = true;
                                      });
                                    }
                                  },
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
                                  Expanded(
                                      flex: 1, child: Text('title'.i18n())),
                                  Expanded(flex: 3, child: Text(novel['name']))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text('author'.i18n())),
                                  Expanded(
                                      flex: 3, child: Text(novel['author']))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text('genre'.i18n())),
                                  Expanded(flex: 3, child: Text(novel['genre']))
                                ],
                              ),
                            ),
                            isWrap
                                ? Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      novel['synopsis'].replaceAll('\\n', '\n'),
                                      textAlign: TextAlign.justify,
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                    ))
                                : Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      novel['synopsis'].replaceAll('\\n', '\n'),
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
                                      ? Text(
                                          'see_less'.i18n(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          'see_more'.i18n(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'chapter'.i18n(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 170,
                              child: ListView.builder(
                                  itemCount: novel['chapters'].length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      shape: const Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 0.5)),
                                      contentPadding: const EdgeInsets
                                          .symmetric(
                                          horizontal:
                                              -10.0), // Sesuaikan padding dengan kebutuhan Anda
                                      leading: Text(
                                          'chapter'.i18n() + ' ${index + 1}',
                                          style: const TextStyle(fontSize: 13)),
                                      trailing: const Icon(Icons.arrow_right),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChaptersPage(
                                                        title:
                                                            'chapter'.i18n() +
                                                                ' ${index + 1}',
                                                        chapter:
                                                            novel['chapters']
                                                                [index])));
                                      },
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        //decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('review'.i18n(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 28),
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
                                    return Visibility(
                                        visible: !isDeleted,
                                        child: Card(
                                            elevation: 2,
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 41, 98, 255),
                                                child: Text(
                                                  reviewList[index]
                                                      .username![0],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                              title: Text(
                                                  '${reviewList[index].username!} | ${reviewList[index].rating}'),
                                              subtitle: (reviewList[index]
                                                      .reviewText!
                                                      .isEmpty)
                                                  ? null
                                                  : Text(reviewList[index]
                                                      .reviewText!),
                                              trailing:
                                                  (reviewList[index].username ==
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email
                                                              ?.split('@')[0]
                                                              .toString())
                                                      ? SizedBox(
                                                          height: 24,
                                                          width: 40,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              size: 22,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      132,
                                                                      34,
                                                                      34),
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      AlertDialog(
                                                                        title: Text(
                                                                            'del_review'.i18n()),
                                                                        content:
                                                                            Text('del_review_alert'.i18n()),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                              child: Text('cancel'.i18n())),
                                                                          ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.red,
                                                                              ),
                                                                              onPressed: () async {
                                                                                var connectivityResult = await Connectivity().checkConnectivity();

                                                                                if (connectivityResult == ConnectivityResult.none) {
                                                                                  // Tidak ada koneksi internet
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    SnackBar(
                                                                                      content: Text('no_internet'.i18n()),
                                                                                      backgroundColor: Colors.red,
                                                                                      duration: Duration(seconds: 2),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  Navigator.of(context).pop();
                                                                                FirebaseFirestore db = await FirebaseFirestore.instance;
                                                                                QuerySnapshot querySnapshot = await db.collection('comments').get();
                                                                                List ListComm = querySnapshot.docs.map((rev) => rev.data()).toList();
                                                                                Map currentDoc = reviewList[index].toMap();
                                                                                int idx = 0;
                                                                                for (var map in ListComm) {
                                                                                  if (map.keys.length == currentDoc.keys.length && map.keys.every((key) => map[key] == currentDoc[key])) {
                                                                                    idx = ListComm.indexOf(map);
                                                                                    String documentId = querySnapshot.docs[idx].id;
                                                                                    await db.collection('comments').doc(documentId).delete();
                                                                                    setState(() {
                                                                                      isDeleted = !isDeleted;
                                                                                    });
                                                                                    final snackBar = SnackBar(
                                                                                      content: Text('deleted_review'.i18n()),
                                                                                      backgroundColor: (Colors.red),
                                                                                      action: SnackBarAction(
                                                                                        label: 'dismiss',
                                                                                        onPressed: () {
                                                                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                                        },
                                                                                      ),
                                                                                    );
                                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                    break;
                                                                                  }
                                                                                }
                                                                                }
                                                                                
                                                                              },
                                                                              child: Text(
                                                                                'del_review'.i18n(),
                                                                              ))
                                                                        ],
                                                                      ));
                                                            },
                                                          ),
                                                        )
                                                      : null,
                                            )));
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
          onPressed: () async {
            FirebaseFirestore db = await FirebaseFirestore.instance;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'write_review'.i18n(),
                      style: const TextStyle(fontSize: 20),
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
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '  ' + 'required'.i18n(),
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12),
                                      ))
                                  : const Text(''),
                              Text('rating'.i18n()),
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
                                    hintText: 'review'.i18n() + '...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: const EdgeInsets.all(8.0)),
                                controller: reviewController,
                                maxLines: 8,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 132, 34, 34),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 20.0),
                                      child: Text(
                                        'cancel'.i18n(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    )),
                                ElevatedButton(
                                    onPressed: () async {
                                      var connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();

                                      if (connectivityResult ==
                                          ConnectivityResult.none) {
                                        // Tidak ada koneksi internet
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('no_internet'.i18n()),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        if (currentRate != 0.0) {
                                          ReviewModel InsertData = ReviewModel(
                                              username: FirebaseAuth
                                                  .instance.currentUser!.email
                                                  ?.split('@')[0]
                                                  .toString(),
                                              // username: (snapshot.data() as Map<String, dynamic>)['username'],
                                              rating: currentRate,
                                              reviewText: reviewController.text,
                                              bookName: novel['name']);
                                          await db
                                              .collection('comments')
                                              .add(InsertData.toMap());
                                          setState(() {
                                            reviewList.add(InsertData);
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 20.0),
                                      child: Text('send'.i18n()),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          tooltip: 'write_a_review'.i18n(),
          child: const Icon(Icons.comment),
        ));
  }
}
