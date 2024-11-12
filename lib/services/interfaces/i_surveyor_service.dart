import 'dart:async';

import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class ISurveyorService {
  Future<NetworkServiceResponse<SurveyorResponse>> fetchSurveyorResponse(String surveyorGuid);
  Future<NetworkServiceResponse<SurveyorResponse>> saveSurveyorResponse(Surveyor surveyor);
}
