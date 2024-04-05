import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ads_comman/ads_comman.dart';

void main() {
  runApp(MaterialApp(
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _adsCommanPlugin = AdsComman();
  bool isAdsLoaded = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      var metadata = await _adsCommanPlugin
          .changeAdvertisementId(
        advertisementId: "ca-app-pub-3940256099942544~3347511713",
        testDeviceIds: ["91F62E7D958C626FF944ADD04A06CA0C"],
        interstitialAdsTime: 10,
        appOpenTimer: 10,
      )
          .then((value) {
        _adsCommanPlugin.loadInterstitialAd(
            interstitialID: "ca-app-pub-3940256099942544/1033173712");
      });
      print("Data: $metadata");
      if (metadata == true) {
        _adsCommanPlugin.loadInterstitialAd(
            interstitialID: "ca-app-pub-3940256099942544/1033173712");
        _adsCommanPlugin.initAppOpenAd(
            appOpenAdsId: "ca-app-pub-3940256099942544/9257395921");
      }
    } on PlatformException {
      throw 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            _adsCommanPlugin.getBannerAds(
              context: context,
              bannerAdID: "ca-app-pub-3940256099942544/6300978111",
              onBannerAdLoaded: () {
                if (!isAdsLoaded) {
                  setState(() {
                    isAdsLoaded = true;
                  });
                }
                // setState(() {});
              },
            ),
            ElevatedButton(
              onPressed: () {
                _adsCommanPlugin.showInterstitialAd(
                    interstitialID: "ca-app-pub-3940256099942544/1033173712");
              },
              child: const Text("Show Interstitial Ad"),
            ),
            ElevatedButton(
              onPressed: () {
                _adsCommanPlugin.getDelayedInterAd(
                    interstitialID: "ca-app-pub-3940256099942544/1033173712");
              },
              child: const Text("Show Interstitial Ad After Some Time"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondWidget()),
                );
              },
              child: const Text("Second Page"),
            ),
          ],
        ));
  }
}

class SecondWidget extends StatefulWidget {
  const SecondWidget({super.key});

  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  bool isAdsLoaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Widget'),
      ),
      body: AdsComman().getBannerAds(
          context: context,
          bannerAdID: "ca-app-pub-3940256099942544/6300978111",
          onBannerAdLoaded: () {
            if (!isAdsLoaded) {
              setState(() {
                isAdsLoaded = true;
              });
            }
            // setState(() {});
          }),
    );
  }
}
