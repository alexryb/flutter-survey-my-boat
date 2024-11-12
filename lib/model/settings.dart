import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsResponse {
  Settings? data;

  SettingsResponse({this.data});

  SettingsResponse.fromJson(Map<String, dynamic> json)
      : data = Settings.fromJson(json['data']);

}

class Settings {

  bool? firstUse = true;
  bool? onlineMode = true;
  bool? logout = false;
  bool? isWeb = false;
  bool? syncOnDataNetwork = false;
  Size? deviceSize = Size.zero;
  int? cameraWidth = 240;
  int? cameraHeigth = 320;
  //String unlockPassword;
  String? mobAdAppId = 'ca-app-pub-9886049869484176~5003247143';
  String? mobAdBannerUnitId = 'ca-app-pub-9886049869484176/5134274933';
  String? mobAdInterstitialUnitId = 'ca-app-pub-9886049869484176/1064002134';
  String? version = "PRO";
  String? localeName = kIsWeb ? "en_US" : Platform.localeName;
  String? buildType = "(Prod)";

  var hostname;
  var apiBaseUrl;
  var oauthBaseUrl;

  String? paymentProvider;

  Settings.local() {
    firstUse = false;
    onlineMode = true;
    isWeb = false;
    logout = false;
    hostname = "imb.realico.ca";
    apiBaseUrl = "https://${hostname}/imb-api";
    oauthBaseUrl = "https://${hostname}/oauth";
    syncOnDataNetwork = false;
    cameraWidth = 480;
    cameraHeigth = 640;
    mobAdBannerUnitId = "";
    mobAdInterstitialUnitId = "";
    paymentProvider = "BRAINTREE";
    buildType = "(Local)";
  }

  Settings.dev() {
    firstUse = false;
    onlineMode = true;
    isWeb = false;
    logout = false;
    hostname = "imb.realico.ca";
    apiBaseUrl = "https://${hostname}/imb-api";
    oauthBaseUrl = "https://${hostname}/oauth";
    syncOnDataNetwork = false;
    cameraWidth = 480;
    cameraHeigth = 640;
    mobAdBannerUnitId = "";
    mobAdInterstitialUnitId = "";
    paymentProvider = "BRAINTREE";
    buildType = "(Dev)";
  }

  Settings.prod() {
    firstUse = false;
    onlineMode = true;
    isWeb = false;
    logout = false;
    hostname = "imb.realico.ca";
    apiBaseUrl = "https://${hostname}/imb-api";
    oauthBaseUrl = "https://${hostname}/oauth";
    syncOnDataNetwork = false;
    cameraWidth = 480;
    cameraHeigth = 640;
    //unlockPassword = "1mbAdm1n2020";
    paymentProvider = "BRAINTREE";
  }

  Settings.web() {
    firstUse = false;
    onlineMode = true;
    isWeb = true;
    logout = false;
    // hostname = "localhost";
    // apiBaseUrl = "http://${hostname}:8080/imb-api/v1";
    // oauthBaseUrl = "http://${hostname}:9090/oauth";
    hostname = "imb.realico.ca";
    apiBaseUrl = "https://${hostname}/imb-api";
    oauthBaseUrl = "https://${hostname}/oauth";
    syncOnDataNetwork = false;
    cameraWidth = 480;
    cameraHeigth = 640;
    //unlockPassword = "1mbAdm1n2020";
    paymentProvider = "BRAINTREE";
    buildType = "(Web)";
  }

  Settings.fromJson(Map<String, dynamic> json) {
    Settings s = environmentSettings;
    firstUse = json['firstUse'];
    onlineMode = json['onlineMode'];
    logout = json['logout'];
    hostname = s.hostname;
    apiBaseUrl = s.apiBaseUrl;
    oauthBaseUrl = s.oauthBaseUrl;
    syncOnDataNetwork = json['syncOnDataNetwork'];
    cameraWidth = json['cameraWidth'];
    cameraHeigth = json['cameraHeigth'];
    //unlockPassword = json['unlockPassword'];
    paymentProvider = json['paymentProvider'];
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['firstUse'] = this.firstUse;
    data['onlineMode'] = this.onlineMode;
    data['logout'] = this.logout;
    // data['hostname'] = this.hostname;
    // data['apiBaseUrl'] = this.apiBaseUrl;
    // data['oauthBaseUrl'] = this.oauthBaseUrl;
    data['syncOnDataNetwork'] = this.syncOnDataNetwork;
    data['cameraWidth'] = this.cameraWidth;
    data['cameraHeigth'] = this.cameraHeigth;
    //data['unlockPassword'] = this.unlockPassword;
    data['paymentProvider'] = this.paymentProvider;
    return data;
  }

  static Settings get environmentSettings {
    Settings? _s;
    if (kDebugMode) _s = Settings.local();
    else if (kProfileMode) _s = Settings.dev();
    else if (kReleaseMode) _s = Settings.prod();
    else if (kIsWeb) _s = Settings.web();
    if(_s != null) {
      assert(_s.mobAdAppId != null);
      assert(_s.mobAdBannerUnitId != null);
      assert(_s.mobAdInterstitialUnitId != null);
      return _s;
    }
    throw ArgumentError('No mode detected');
  }

}