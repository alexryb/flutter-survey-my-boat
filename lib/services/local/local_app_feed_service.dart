import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/model/app_feed.dart';
import 'package:surveymyboatpro/model/app_feed_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_app_feed_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class LocalAppFeedService implements IAppFeedService {

  @override
  Future<NetworkServiceResponse<AppFeedListResponse>> getAppFeedListResponse() async {
    AppFeedList appFeeds = await _getAll();
    return new NetworkServiceResponse(
      content: new AppFeedListResponse(data: appFeeds),
      success: true,
    );
  }
}

Future<String> _loadAppFeedsAsset() async {
  return await rootBundle.loadString('assets/data/appFeeds.json');
}

Future<AppFeedList> _getAll() async {
  List<AppFeed>? result = await _loadAssetAppFeeds();
  return new AppFeedList(elements: result);
}

Future<List<AppFeed>?> _loadAssetAppFeeds() async {
  String jsonString = await _loadAppFeedsAsset();
  final jsonResponse = json.decode(jsonString);
  return new AppFeedList.fromJson(jsonResponse).elements;
}




