import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_comman.dart';
import 'ads_comman_method_channel.dart';

class AppOpenAdManager {
  final Duration maxCacheDuration = Duration(hours: 4);
  DateTime? _appOpenLoadTime;
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  String adUnitId = '';
  AppOpenAdManager({required String appOpenAdsId}) {
    adUnitId = appOpenAdsId;
  }

  void loadAd() {
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    (interstitialAdRunning == false)
        ? appOpenAdRunning == true
            ? null
            : getDifferenceAppOpenTime()
                ? _appOpenAd!.show().then((value) {
                    box.write(ArgumentConstant.isAppOpenStartTime,
                        DateTime.now().millisecondsSinceEpoch.toString());
                  })
                : null
        : null;
  }
}

bool getDifferenceAppOpenTime() {
  if (box.read(ArgumentConstant.isAppOpenStartTime) != null) {
    String startTime = box.read(ArgumentConstant.isAppOpenStartTime).toString();
    String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    int difference = int.parse(currentTime) - int.parse(startTime);
    print("Difference := $difference");
    print("StartTime := $startTime");
    print("currentDate := $currentTime");
    int differenceTime = difference ~/ 1000;
    if (differenceTime > appOpenShowTime) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
