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
    this.surveyResult = survey;
    clone = survey.surveyGuid != null;
  }

  SurveyViewModel.save(Survey survey) {
    this.surveyResult = survey;
  }

  SurveyViewModel.archive(String surveyGuid) {
    this.surveyGuid = surveyGuid;
  }

  Future<Null> getSurveys() async {
    ISurveyService surveyService = await new Injector(await flavor).surveyService;
    NetworkServiceResponse<SurveyListResponse> result = await surveyService.findSurveyResponse(searchFilter!);
    this.apiCallResult = result;
    if(result.content != null) this.surveyListResult = result.content!.data;
  }

  Future<Null> fetchSurvey(String surveyGuid) async {
    ISurveyService _localSurveyService = await new Injector(await Flavor.LOCAL).surveyService;
    NetworkServiceResponse<SurveyResponse> result = await _localSurveyService.fetchSurveyResponse(surveyGuid);
    if(result.content!.data != null && !result.content!.data!.inSync) {
      print("Local survey is not synchronized with remote");
      result.validate = false;
    } else {
      ISurveyService surveyService = await new Injector(await flavor).surveyService;
      result = await surveyService.fetchSurveyResponse(surveyGuid);
    }
    this.apiCallResult = result;
    if(result.content != null) this.surveyResult = result.content!.data;
  }

  Future<Null> saveSurvey() async {
    ISurveyService surveyService = await new Injector(await flavor).surveyService;
    NetworkServiceResponse<SurveyResponse> result = await surveyService.saveSurveyResponse(surveyResult!);
    this.apiCallResult = result;
    if(result.content != null) this.surveyResult = result.content!.data;
  }

  Future<Null> createSurvey() async {
    ISurveyService surveyService = await new Injector(Flavor.REMOTE).surveyService;
    NetworkServiceResponse<SurveyResponse> _surveyResult = await surveyService.createSurveyResponse(surveyResult!, clone: clone!);
    this.apiCallResult = _surveyResult;
    if(_surveyResult.content != null) this.surveyResult = _surveyResult.content!.data;
  }

  Future<Null> archiveSurvey() async {
    ISurveyService surveyService = await new Injector(Flavor.REMOTE).surveyService;
    NetworkServiceResponse<SurveyResponse> _surveyResult = await surveyService.archiveSurveyResponse(surveyGuid!);
    this.apiCallResult = _surveyResult;
    if(_surveyResult.content != null) this.status = _surveyResult.content!.status;
  }
}
