package com.example.ads_comman;


import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** AdsCommanPlugin */
public class AdsCommanPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;


  public AdsCommanPlugin() {

  }

  public AdsCommanPlugin(MethodChannel channel, Context context) {
    this.channel = channel;
    this.context = context;
  }


  public static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.example.ads_comman/changeAdvertisementId");
    channel.setMethodCallHandler(new AdsCommanPlugin(channel, registrar.context()));
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ads_comman");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
     if (call.method.equals("changeAdvertisementId")) {
      PackageManager pm = context.getPackageManager();
      ApplicationInfo appInfo = null;
      try {
        appInfo = pm.getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
      } catch (PackageManager.NameNotFoundException e) {
        throw new RuntimeException(e);
      }
      String advertisementId = call.argument("advertisementId");
      appInfo.metaData.putString("com.google.android.gms.ads.APPLICATION_ID", advertisementId);
      result.success("Advertisement Id Changed");
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
