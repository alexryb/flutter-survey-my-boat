
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AnalyticsState<T> extends State {

  static FirebaseAnalytics? analytics;
  static FirebaseAnalyticsObserver? observer;

  void initializeAnalytics() {
    analytics ??= FirebaseAnalytics.instance;
    observer ??= FirebaseAnalyticsObserver(analytics: analytics!);
  }

  @override
  initState() {
    super.initState();
    initializeAnalytics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> sendAnalyticsEvent(String eventName, Map<String, Object> params) async {
    analytics!.logEvent(
      name: eventName,
      parameters: params,
    );
  }

}
