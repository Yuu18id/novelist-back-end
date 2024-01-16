import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/components/firestore.dart';
import 'package:flutter_application_1/pages/browse_detail.dart';

class Browsepage extends StatefulWidget {
  const Browsepage({super.key});

  @override
  State<Browsepage> createState() => BrowsepageState();
}

class BrowsepageState extends State<Browsepage> {
  List<NovelModel> details = [];
  Future readData() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = await FirebaseFirestore.instance;
    var data = await db.collection('novels').get();
    setState(() {
      details = data.docs.map((doc) => NovelModel.fromDocSnapshot(doc)).toList();
    });
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        
        child:  Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final novel = details[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrowseDetailPage(novel: details[index].name,),
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
                              image: NetworkImage(details[index].img),
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
      ),
    )
    );

  }
}
