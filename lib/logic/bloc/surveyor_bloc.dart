import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/surveyor_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:rxdart/rxdart.dart';

class SurveyorBloc {
  
  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;
  
  final surveyorResultController = StreamController<Surveyor>();
  Stream<Surveyor> get surveyor => surveyorResultController.stream;

  Future<void> getSurveyor(SurveyorViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getSurveyor;

    await model.fetchSurveyor(model.surveyorGuid);

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveyorResultController.add(model.surveyorResult);
    model = null;
  }

  Future<void> saveSurveyor(SurveyorViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.saveSurveyor;

    await model.saveSurveyor();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveyorResultController.add(model.surveyorResult);
    model = null;
  }

  void dispose() {
    apiController?.close();
    surveyorResultController?.close();
  }
}
