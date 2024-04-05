# ads_comman

ads_comman is flutter package for add google advertise to you ap

## Installation

run this command to your flutter project terminal

```bash
flutter pub add ads_comman
```

## Usage

## Initilize Ads
```dart
final _adsCommanPlugin = AdsComman();
 @override
  void initState() {
    super.initState();
       // Initilize to Advertisment in you project
       await _adsCommanPlugin
          .changeAdvertisementId(
        advertisementId: "YOUR_GOOGLE_ADS_APPLICATIONID", // you google Ad mobe Application id
        testDeviceIds: [""], // your device test id
        interstitialAdsTime: 40, // give time in second for display an Interstitial ad after 10 seconds of any event
        appOpenTimer: 40,//give time in second for display app open ad after 10 seconds of any event
      )
          .then((value) {
        _adsCommanPlugin.loadInterstitialAd(
            interstitialID: "INTERSTITAL_ADS_ID");  //Load Interstitial for first time
      });
  }
```
## Display Banner Ad
```dart
  _adsCommanPlugin.getBannerAds(
    context: context,
    bannerAdID: "BANNER ADS_ID",
    onBannerAdLoaded: () {
         // TODO: after banner Loaded
      }
    },
  ),
```

## Display Interstitial Ad
```dart
ElevatedButton(
  onPressed: () {
    _adsCommanPlugin.showInterstitialAd(
        interstitialID: "INTERSTITAL_ADS_ID"); // it will display full screen Video Ad
  },
  child: const Text("Show Interstitial Ad"),
),
```
## Display Interstitial Ad after delay which is given in init
```dart
ElevatedButton(
  onPressed: () {
    _adsCommanPlugin.getDelayedInterAd(
        interstitialID: "INTERSTITAL_ADS_ID); //It will show ads after dilay
  },
  child: const Text("Show Interstitial Ad After Some Time"),
),
```

## Display App open Ads
```dart
// Add this line when app is Start it will show app open ad after 40 seconds user can change this time at Initilize time 
_adsCommanPlugin.initAppOpenAd(
    appOpenAdsId: "APPOPEN_ADS_ID");
```


## License

[MIT](https://github.com/KhilanVitthani/ads_comman/blob/main/LICENSE)