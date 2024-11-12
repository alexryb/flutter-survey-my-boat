import 'dart:async';

import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_surveyor_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class SurveyorService extends NetworkService implements ISurveyorService {
  static const _surveyorsUrl = "/surveyors";
  
  @override
  Future<NetworkServiceResponse<SurveyorResponse>> fetchSurveyorResponse(String surveyorGuid) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Surveyor>(restApiBaseUrl.toString(), "$_surveyorsUrl/$surveyorGuid");
    if (result?.mappedResult != null) {
      Surveyor surveyor = Surveyor.fromJson(result?.mappedResult);
      surveyor.inSync = true;
      return new NetworkServiceResponse(
        content: SurveyorResponse(
            data: surveyor
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<SurveyorResponse>> saveSurveyorResponse(Surveyor surveyor) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.putRequest<Surveyor>(restApiBaseUrl.toString(), "$_surveyorsUrl/${surveyor.surveyorGuid}", surveyor);
    if (result?.mappedResult != null) {
      Surveyor surveyor0 = Surveyor.fromJson(result?.mappedResult);
      surveyor0.inSync = true;
      return new NetworkServiceResponse(
        content: SurveyorResponse(
            data: surveyor0
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }
}
