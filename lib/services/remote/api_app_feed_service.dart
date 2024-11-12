import 'dart:async';

import 'package:surveymyboatpro/model/app_feed_list.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_app_feed_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class AppFeedService extends NetworkService implements IAppFeedService {
  static const _appFeedsUrl = "/appfeeds";

  @override
  Future<NetworkServiceResponse<AppFeedListResponse>> getAppFeedListResponse() async {
    SecureRestClient? _restClient = await oauthRestClient;
    var result = await _restClient!.getRequest<AppFeedList>(restApiBaseUrl.toString(), _appFeedsUrl);
    if (result.mappedResult != null) {
      return new NetworkServiceResponse(
        content: AppFeedListResponse(
            data: AppFeedList.fromJson(result.mappedResult)
        ),
        success: result.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result.networkServiceResponse.success,
        message: result.networkServiceResponse.message);
  }
}
