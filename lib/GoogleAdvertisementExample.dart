import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notificationexample/resources/Advertisement.dart';

class GoogleAdvertisementExample extends StatefulWidget {

  @override
  State<GoogleAdvertisementExample> createState() => _GoogleAdvertisementExampleState();
}
//ca-app-pub-9514997845941727~9036763407
//ca-app-pub-9514997845941727/4571453525
//ca-app-pub-9514997845941727/6814473486
class _GoogleAdvertisementExampleState extends State<GoogleAdvertisementExample> {

  BannerAd _topBannerAd;
  BannerAd _bottomBannerad;

  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;
  bool istopload=false;
  bool isbottomload=false;
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
  loadbottombanner()
  {
    _bottomBannerad = BannerAd(
      adUnitId: Advertisement.TOP_BANNER,
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isbottomload = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerad.load();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadtopbanner();
    loadbottombanner();
    _createInterstitialAd();
    _createRewardedAd();
  }
  void _createRewardedAd() async{
    RewardedAd.load(
      adUnitId: Advertisement.REWARDED_BANNER,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _createRewardedAd();
          }),);
  }
  void _showRewardedAd()async {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    ////////////////////////////////

    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd .show();
    _rewardedAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Advertisement.INTERSTITIAL_BANNER,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
          },
        ));
  }
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async
    {
      _showInterstitialAd();
      final difference = DateTime.now().difference(timeBackPressed);
      final isExitWarning = difference >= Duration(seconds: 2);

      timeBackPressed = DateTime.now();

      if(_showInterstitialAd==isExitWarning){

        final message = "Press Back agin to exit";

        print(message);

        return false;
      }
      else{
        return true;
      }
    },
      child: Scaffold(
      appBar: AppBar(
        title: Text("Advertisement"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                (istopload)?
                Container(
                  height: _topBannerAd.size.height.toDouble(),
                  width: _topBannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _topBannerAd),
                ):SizedBox(height: 0,),
              ],
            ),
            SizedBox(height: 200,),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red.shade900,
                  width: 3.0,
                ),
              ),
              child: GestureDetector(
                onTap: () async{
                  _showInterstitialAd();
                },
                child: Center(child: Text("InterstitialAd",style: TextStyle(fontSize: 20),)),
              ),
            ),
            SizedBox(height: 40,),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 3.0,
                ),
              ),
              child: GestureDetector(
                onTap: () async{
                  _showRewardedAd();
                },
                child: Center(child: Text("RewardedAd",style: TextStyle(fontSize: 20),)),
              ),
            ),
            SizedBox(height: 260),
            Column(
              children: [
                (istopload)?
                Container(
                  height: _bottomBannerad.size.height.toDouble(),
                  width: _bottomBannerad.size.width.toDouble(),
                  child: AdWidget(ad: _bottomBannerad),
                ):SizedBox(height: 0,),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
