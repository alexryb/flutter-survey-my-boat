import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/app_feed_view_model.dart';
import 'package:surveymyboatpro/model/app_feed_list.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

class AppFeedBloc {
  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;
  
  final appFeedsResultController = StreamController<AppFeedList>();
  
  Stream<AppFeedList> get appFeeds => appFeedsResultController.stream;
  
  Future<void> getAppFeeds(AppFeedViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getAppFeeds;

    await model.getAppFeeds();

    process.loading = false;
    process.response = model.apiCallResult;

    //for error dialog
    apiController.add(process);
    appFeedsResultController.add(model.appFeedListResult);
  }

  void dispose() {
    apiController.close();
    appFeedsResultController.close();
  }
}
