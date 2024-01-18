import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/components/ad_mobs_manager.dart';
import 'package:flutter_application_1/components/firestore.dart';
import 'package:flutter_application_1/pages/browse_detail.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Browsepage extends StatefulWidget {
  const Browsepage({super.key});

  @override
  State<Browsepage> createState() => BrowsepageState();
}

class BrowsepageState extends State<Browsepage> {
  late BannerAd bannerAd;
  bool isBannerVisible = true;
  late InterstitialAd interstitialAd;
  bool isInterstitialAdReady = false;
  List<NovelModel> details = [];
  Future readData() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = await FirebaseFirestore.instance;
    var data = await db.collection('novels').get();
    setState(() {
      details =
          data.docs.map((doc) => NovelModel.fromDocSnapshot(doc)).toList();
    });
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AddMobManage.interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            print("Close Ad");
          });
          setState(() {
            isInterstitialAdReady = true;
            interstitialAd = ad;
          });
        }, onAdFailedToLoad: (err) {
          isInterstitialAdReady = false;
          interstitialAd.dispose();
        }));
  }

  @override
  void initState() {
    readData();
    super.initState();
    if (isBannerVisible) {
      bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AddMobManage.bannerAdID,
        listener: const BannerAdListener(),
        request: const AdRequest(),
      );
      bannerAd.load();
    } else {
      setState(() {
        isBannerVisible = false;
      });
    }
    loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
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
                      loadInterstitialAd();
                      if (isInterstitialAdReady) {
                        interstitialAd.show();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrowseDetailPage(
                            novel: details[index].name,
                          ),
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
            Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: isBannerVisible,
                  child: SizedBox(
                    width: bannerAd.size.width.toDouble(),
                    height: bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  ),
                )),
          ],
        ),
      ),
    ));
    
  }
  @override
  void dispose() {
    if (isBannerVisible) {
      bannerAd.dispose();
    }
    super.dispose();
  }
}
