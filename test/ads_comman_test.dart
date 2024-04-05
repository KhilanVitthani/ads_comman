import 'package:flutter_test/flutter_test.dart';
import 'package:ads_comman/ads_comman.dart';
import 'package:ads_comman/ads_comman_platform_interface.dart';
import 'package:ads_comman/ads_comman_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdsCommanPlatform
    with MockPlatformInterfaceMixin
    implements AdsCommanPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdsCommanPlatform initialPlatform = AdsCommanPlatform.instance;

  test('$MethodChannelAdsComman is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdsComman>());
  });

  test('getPlatformVersion', () async {
    AdsComman adsCommanPlugin = AdsComman();
    MockAdsCommanPlatform fakePlatform = MockAdsCommanPlatform();
    AdsCommanPlatform.instance = fakePlatform;

    expect(await adsCommanPlugin.getPlatformVersion(), '42');
  });
}
