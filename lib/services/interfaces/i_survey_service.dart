import 'dart:async';

import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/survey_search_filter.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class ISurveyService {
  Future<NetworkServiceResponse<SurveyListResponse>> findSurveyResponse(SurveySearchFilter filter);
  Future<NetworkServiceResponse<SurveyResponse>> fetchSurveyResponse(String surveyGuid);
  Future<NetworkServiceResponse<SurveyResponse>> saveSurveyResponse(Survey survey);
  Future<NetworkServiceResponse<SurveyResponse>> createSurveyResponse(Survey survey, {required bool clone});
  Future<NetworkServiceResponse<SurveyResponse>> archiveSurveyResponse(String surveyGuid);
}
