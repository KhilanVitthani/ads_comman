import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_comman_platform_interface.dart';
import 'app_lifecycle_reactor.dart';
import 'app_open_ad_manager.dart';

GetStorage box = GetStorage();
int appOpenShowTime = 0;
int interShowTime = 0;

class AdsComman {
  Future<bool> changeAdvertisementId({
    required String advertisementId,
    List<String>? testDeviceIds,
    int appOpenTimer = 40,
    int interstitialAdsTime = 40,
  }) async {
    await AdsCommanPlatform.instance
        .changeAdvertisementId(advertisementId: advertisementId)
        .then((value) async {
      if (value == "Advertisement Id Changed") {
        MobileAds.instance.initialize();
        MobileAds.instance.updateRequestConfiguration(
            RequestConfiguration(testDeviceIds: testDeviceIds));
        await GetStorage.init();
        if (isNullEmptyOrFalse(box.read(ArgumentConstant.isStartTime))) {
          box.write(ArgumentConstant.isStartTime, 0);
        }
        if (isNullEmptyOrFalse(box.read(ArgumentConstant.isAppOpenStartTime))) {
          ;
          box.write(ArgumentConstant.isAppOpenStartTime, 0);
        }
        appOpenShowTime = appOpenTimer;
        interShowTime = interstitialAdsTime;
      }
    });
    return true;
  }

  Widget getBannerAds(
      {required BuildContext context,
      required String bannerAdID,
      required Function onBannerAdLoaded}) {
    return AdsCommanPlatform.instance.getBannerAds(
        context: context,
        bannerAdID: bannerAdID,
        onBannerAdLoaded: onBannerAdLoaded);
  }

  initAppOpenAd({required String appOpenAdsId}) {
    AppLifecycleReactor? appLifecycleReactor;
    AppOpenAdManager appOpenAdManager =
        AppOpenAdManager(appOpenAdsId: appOpenAdsId)..loadAd();
    appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    if (appLifecycleReactor != null) {
      appLifecycleReactor!.listenToAppStateChanges();
    }
  }

  void showInterstitialAd(
      {required String interstitialID, VoidCallback? onAdClosed}) {
    AdsCommanPlatform.instance.showInterstitialAd(
        interstitialID: interstitialID, onAdClosed: onAdClosed);
  }

  void getDelayedInterAd(
      {required String interstitialID, VoidCallback? onAdClosed}) {
    AdsCommanPlatform.instance.getDifferenceTime(
      interstitialID: interstitialID,
      onAdClosed: onAdClosed,
    );
  }

  void loadInterstitialAd({required String interstitialID}) {
    AdsCommanPlatform.instance
        .loadInterstitialAd(interstitialID: interstitialID);
  }
}

class ArgumentConstant {
  static const isStartTime = "isStartTime";
  static const isAppOpenStartTime = "isAppOpenStartTime";
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}
