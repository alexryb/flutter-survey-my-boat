import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/app_feed_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_app_feed_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class AppFeedViewModel extends BaseViewModel {

  late AppFeedList appFeedListResult;
  late NetworkServiceResponse apiCallResult;
  
  Future<Null> getAppFeeds() async {
    IAppFeedService appFeedService = await new Injector(await flavor).appFeedService;
    NetworkServiceResponse<AppFeedListResponse> result = await appFeedService.getAppFeedListResponse();
    apiCallResult = result;
    if(result.content != null) appFeedListResult = result.content!.data;
  }
}
