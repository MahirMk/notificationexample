import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notificationexample/resources/Advertisement.dart';

class GoogleAdvertisementPractice extends StatefulWidget {

  @override
  State<GoogleAdvertisementPractice> createState() => _GoogleAdvertisementPracticeState();
}

class _GoogleAdvertisementPracticeState extends State<GoogleAdvertisementPractice> {

  BannerAd _topBannerAd;
  bool istopload=false;

  loadtopbanner()
  {
    _topBannerAd = BannerAd(
      adUnitId: Advertisement.TOP_BANNER,
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            istopload = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _topBannerAd.load();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadtopbanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            (istopload)?
            Container(
              height: _topBannerAd.size.height.toDouble(),
              width: _topBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _topBannerAd),
            ):SizedBox(height: 0,),
          ],
        ),
      ),
    );
  }
}
