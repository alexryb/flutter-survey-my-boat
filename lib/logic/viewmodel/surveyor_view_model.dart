import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/survey_search_filter.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/interfaces/i_surveyor_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class SurveyorViewModel extends BaseViewModel {
  String? surveyorGuid;

  Surveyor? surveyorResult;
  NetworkServiceResponse? apiCallResult;

  SurveySearchFilter? searchFilter;

  SurveyorViewModel.fetch(String surveyGuid) {
    surveyorGuid = surveyGuid;
  }

  SurveyorViewModel.save(Surveyor surveyor) {
    surveyorResult = surveyor;
  }

  Future<Null> fetchSurveyor(String surveyGuid) async {
    ISurveyorService surveyorService = await new Injector(await flavor).surveyorService;
    NetworkServiceResponse<SurveyorResponse> result = await surveyorService.fetchSurveyorResponse(surveyGuid);
    apiCallResult = result;
    if(result.content != null) surveyorResult = result.content!.data;
  }

  Future<Null> saveSurveyor() async {
    ISurveyorService surveyorService = await new Injector(await flavor).surveyorService;
    NetworkServiceResponse<SurveyorResponse> result = await surveyorService.saveSurveyorResponse(surveyorResult!);
    apiCallResult = result;
    if(result.content != null) surveyorResult = result.content!.data;
  }
}
