import 'dart:async';

import 'package:surveymyboatpro/model/app_feed_list.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class IAppFeedService {
  Future<NetworkServiceResponse<AppFeedListResponse>> getAppFeedListResponse();
}
