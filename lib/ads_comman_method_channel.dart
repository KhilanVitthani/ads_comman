import 'dart:ui';

import 'package:ads_comman/ads_comman.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_comman_platform_interface.dart';

bool interstitialAdRunning = false;
bool appOpenAdRunning = false;

class MethodChannelAdsComman extends AdsCommanPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('ads_comman');

  @override
  Future changeAdvertisementId({required String advertisementId}) async {
    final version = await methodChannel.invokeMethod('changeAdvertisementId', {
      'advertisementId': advertisementId,
    });
    return version;
  }

  BannerAd? bannerAd;
  bool isBannerLoaded = false;
  InterstitialAd? interstitialAds;
  AnchoredAdaptiveBannerAdSize? size;

  // BannerAds
  initBannerAds(
      {required BuildContext context,
      required String bannerID,
      required Function onBannerAdLoaded}) async {
    size = await anchoredAdaptiveBannerAdSize(context: context);
    bannerAd = BannerAd(
        size: size ?? AdSize.banner,
        adUnitId: bannerID.toString().trim(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print("BannerAd Loaded");
            isBannerLoaded = true;
            onBannerAdLoaded();
          },
          onAdFailedToLoad: (ad, error) {
            print(
                'Ad load failed (code=${error.code} message=${error.message})');
            ad.dispose();
            initBannerAds(
                context: context,
                bannerID: bannerID,
                onBannerAdLoaded: onBannerAdLoaded);
          },
        ),
        request: AdRequest())
      ..load();
  }

  Widget getBannerAds(
      {required BuildContext context,
      required String bannerAdID,
      required Function onBannerAdLoaded}) {
    initBannerAds(
        context: context,
        bannerID: bannerAdID,
        onBannerAdLoaded: onBannerAdLoaded);
    return (bannerAd == null)
        ? const SizedBox()
        : SizedBox(
            width: bannerAd!.size.width.toDouble(),
            height: bannerAd!.size.height.toDouble(),
            child:
                bannerAd != null ? AdWidget(ad: bannerAd!) : const SizedBox(),
          );
  }

  showInterstitialAd(
      {required String interstitialID, VoidCallback? onAdClosed}) {
    loadInterstitialAd(interstitialID: interstitialID);
    interstitialAdRunning = true;
    if (interstitialAdRunning) {
      interstitialAds?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) =>
            print('Ad showed fullscreen content.'),
        onAdDismissedFullScreenContent: (ad) {
          interstitialAds?.dispose();
          loadInterstitialAd(interstitialID: interstitialID);
          interstitialAdRunning = false;
          print('Ad dismissed fullscreen content.');
          if (onAdClosed != null) {
            onAdClosed();
          }
          box.write(ArgumentConstant.isStartTime,
              DateTime.now().millisecondsSinceEpoch.toString());
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          interstitialAdRunning = false;
          if (onAdClosed != null) {
            onAdClosed();
          }
          print('Ad failed to show fullscreen content: $error');
        },
      );
      interstitialAds?.show();
    } else {
      print('Interstitial ad is not loaded yet.');
      loadInterstitialAd(
          interstitialID:
              interstitialID); // Load a new ad if not already loaded
    }
  }

  loadInterstitialAd({required String interstitialID}) {
    InterstitialAd.load(
      adUnitId: interstitialID.toString().trim(),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAds = ad;
        },
        onAdFailedToLoad: (error) {
          // interstitialAdRunning.value = false;
          print('InterstitialAd failed to load: $error');
          print("InterstitialID:-  " + interstitialID.toString().trim());
        },
      ),
    );
  }

  getDifferenceTime(
      {required String interstitialID, VoidCallback? onAdClosed}) {
    if (box.read(ArgumentConstant.isStartTime) != null) {
      String startTime = box.read(ArgumentConstant.isStartTime).toString();
      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      int difference = int.parse(currentTime) - int.parse(startTime);
      print("Difference := $difference");
      print("StartTime := $startTime");
      print("currentDate := $currentTime");
      int differenceTime = difference ~/ 1000;
      if (differenceTime > interShowTime) {
        showInterstitialAd(
            interstitialID: interstitialID, onAdClosed: onAdClosed);
      }
    }
  }

  Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize(
      {required BuildContext context}) async {
    return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.toInt());
  }
}
