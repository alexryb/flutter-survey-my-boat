import 'dart:async';

import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/survey_search_filter.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_survey_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class SurveyService extends NetworkService implements ISurveyService {
  static const _surveysUrl = "/surveys";
  static const _surveysCloneUrl = "/surveys/clone";
  static const _clientsUrl = "/clients";

  @override
  Future<NetworkServiceResponse<SurveyResponse>> fetchSurveyResponse(String surveyGuid) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Survey>(restApiBaseUrl.toString(), "$_surveysUrl/$surveyGuid");
    if (result?.mappedResult != null) {
      Survey survey = Survey.fromJson(result?.mappedResult);
      survey.inSync = true;
      return new NetworkServiceResponse(
        content: SurveyResponse(
            data: survey
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<SurveyResponse>> archiveSurveyResponse(String surveyGuid) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Survey>(restApiBaseUrl.toString(), "$_surveysUrl/$surveyGuid/archive");
    if (result?.mappedResult != null) {
      SurveyStatus status = SurveyStatus.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: SurveyResponse(
            status: status
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<SurveyListResponse>> findSurveyResponse(SurveySearchFilter filter) async {
    SecureRestClient? restClient = await oauthRestClient;
    String endPointUrl = _surveysUrl + filter.toString();
    var result = await restClient?.getRequest<SurveyList>(restApiBaseUrl.toString(), endPointUrl);
    if (result?.mappedResult != null) {
      return new NetworkServiceResponse(
        content: SurveyListResponse(
            data: SurveyList.fromJson(result?.mappedResult)
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<SurveyResponse>> saveSurveyResponse(Survey survey) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.putRequest<Survey>(restApiBaseUrl.toString(), "$_surveysUrl/${survey.surveyGuid!}", survey);
    if (result?.mappedResult != null) {
      Survey survey0 = Survey.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: SurveyResponse(
            data: survey0
        ),
        success: result?.networkServiceResponse.success,
        validate: true,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<SurveyResponse>> createSurveyResponse(Survey survey, {required bool clone}) async {
    SecureRestClient? restClient = await oauthRestClient;

    if(survey.client?.clientGuid == null) {
      var clientExistsResult = await restClient?.getRequest<Client>(
          restApiBaseUrl.toString(),
          "$_clientsUrl/checkEmail?emailAddress=${survey.client?.emailAddress}");
      if (clientExistsResult?.mappedResult != null) {
        Client client = Client.fromJson(clientExistsResult?.mappedResult);
        survey.client = client;
        return new NetworkServiceResponse(
            content: SurveyResponse(
                data: survey
            ),
            success: true,
            validate: false,
            message: "Client already exists. Please use another email or accept that client");
      }
    }

    var result = await restClient?.postRequest<Survey>(restApiBaseUrl.toString(), clone ? _surveysCloneUrl : _surveysUrl, survey);
    if (result?.mappedResult != null) {
      Survey survey0 = Survey.fromJson(result?.mappedResult);
      survey0.client?.inSync = true;
      survey0.inSync = true;
      return new NetworkServiceResponse(
        content: SurveyResponse(
            data: survey0
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }
}
