import 'package:flutter/src/widgets/framework.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ads_comman_method_channel.dart';

abstract class AdsCommanPlatform extends PlatformInterface {
  /// Constructs a AdsCommanPlatform.
  AdsCommanPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdsCommanPlatform _instance = MethodChannelAdsComman();

  /// The default instance of [AdsCommanPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdsComman].
  static AdsCommanPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdsCommanPlatform] when
  /// they register themselves.
  static set instance(AdsCommanPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future changeAdvertisementId({required String advertisementId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Widget getBannerAds(
      {required BuildContext context,
      required String bannerAdID,
      required Function onBannerAdLoaded}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void showInterstitialAd(
      {required String interstitialID, VoidCallback? onAdClosed}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void loadInterstitialAd({required String interstitialID}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void getDifferenceTime(
      {required String interstitialID, VoidCallback? onAdClosed}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
