import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/ui/page/generic/admob_page_state.dart';
import 'package:surveymyboatpro/ui/page/generic/admob_target_info.dart';

abstract class AdMobBannerPageState<T> extends AdMobPageState<T> {

  BannerAd? _bannerAd;
  bool isShown = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _setBannerAd();
  }

  @override
  void dispose() {
    hideBannerAd();
    super.dispose();
  }

  @override
  void deactivate() {
    hideBannerAd();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _setBannerAd() {
    if (!kIsWeb && _bannerAd == null) {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Injector.SETTINGS!.mobAdBannerUnitId!,
        request: adRequestInfo,
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) {
            print('Banner Ad loaded.');
            isShown = true;
            isLoaded = true;
            this.sendAnalyticsEvent("load_banner_ad", <String, Object>{
              "ad_unit": ad.adUnitId,
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('Banner Ad failed to load: $error');
            isShown = false;
            isLoaded = false;
            this.sendAnalyticsEvent("failed_load_banner_ad", <String, Object>{
              "ad_unit": ad.adUnitId,
              "reason": "$error",
            });
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) {
            print('Banner Ad opened.');
            this.sendAnalyticsEvent("open_banner_ad", <String, Object>{
              "ad_unit": ad.adUnitId,
            });
          },
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) {
            print('Banner Ad closed.');
            isShown = false;
            isLoaded = false;
            this.sendAnalyticsEvent("close_banner_ad", <String, Object>{
              "ad_unit": ad.adUnitId,
            });
          },
        ),
      )..load();
    }
  }

  Widget bannerAdWidget() {
    if (!kIsWeb && _bannerAd != null) {
      return Container(
        width: _bannerAd?.size.width.toDouble(),
        height: _bannerAd?.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
        color: Colors.blueGrey,
      );
    } else {
      return Container(
        width: AdSize.banner.width.toDouble(),
        height: AdSize.banner.height.toDouble(),
        child: SizedBox.shrink(),
        color: Colors.blueGrey,
      );
    }
  }

  void hideBannerAd() {
    if (!kIsWeb && _bannerAd != null) {
      _bannerAd?.dispose();
      isShown = false;
      _bannerAd = null;
    }
  }
}