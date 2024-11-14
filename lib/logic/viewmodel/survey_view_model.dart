import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/survey_search_filter.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/services/interfaces/i_survey_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class SurveyViewModel extends BaseViewModel {
  String? surveyGuid;
  bool? clone = false;
  SurveyStatus? status;
  Survey? surveyResult;
  SurveyList? surveyListResult;
  NetworkServiceResponse? apiCallResult;

  SurveySearchFilter? searchFilter;

  SurveyViewModel.search(SurveySearchFilter searchFilter) {
    this.searchFilter = searchFilter;
  }

  SurveyViewModel.fetch(String surveyGuid) {
    this.surveyGuid = surveyGuid;
  }

  SurveyViewModel.create(Survey survey) {
    surveyResult = survey;
    clone = survey.surveyGuid != null;
  }

  SurveyViewModel.save(Survey survey) {
    surveyResult = survey;
  }

  SurveyViewModel.archive(String surveyGuid) {
    this.surveyGuid = surveyGuid;
  }

  Future<Null> getSurveys() async {
    ISurveyService surveyService = await new Injector(await flavor).surveyService;
    NetworkServiceResponse<SurveyListResponse> result = await surveyService.findSurveyResponse(searchFilter!);
    apiCallResult = result;
    if(result.content != null) surveyListResult = result.content!.data;
  }

  Future<Null> fetchSurvey(String surveyGuid) async {
    ISurveyService localSurveyService = await new Injector(Flavor.LOCAL).surveyService;
    NetworkServiceResponse<SurveyResponse> result = await localSurveyService.fetchSurveyResponse(surveyGuid);
    if(result.content!.data != null && !result.content!.data!.inSync) {
      print("Local survey is not synchronized with remote");
      result.validate = false;
    } else {
      ISurveyService surveyService = await new Injector(await flavor).surveyService;
      result = await surveyService.fetchSurveyResponse(surveyGuid);
    }
    apiCallResult = result;
    if(result.content != null) surveyResult = result.content!.data;
  }

  Future<Null> saveSurvey() async {
    ISurveyService surveyService = await new Injector(await flavor).surveyService;
    NetworkServiceResponse<SurveyResponse> result = await surveyService.saveSurveyResponse(surveyResult!);
    apiCallResult = result;
    if(result.content != null) surveyResult = result.content!.data;
  }

  Future<Null> createSurvey() async {
    ISurveyService surveyService = await new Injector(Flavor.REMOTE).surveyService;
    NetworkServiceResponse<SurveyResponse> surveyResult = await surveyService.createSurveyResponse(surveyResult, clone: clone!);
    apiCallResult = surveyResult;
    if(surveyResult.content != null) surveyResult = surveyResult.content!.data;
  }

  Future<Null> archiveSurvey() async {
    ISurveyService surveyService = await new Injector(Flavor.REMOTE).surveyService;
    NetworkServiceResponse<SurveyResponse> surveyResult = await surveyService.archiveSurveyResponse(surveyGuid!);
    apiCallResult = surveyResult;
    if(surveyResult.content != null) status = surveyResult.content!.status;
  }
}
