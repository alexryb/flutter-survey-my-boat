import 'dart:async';

import 'package:surveymyboatpro/model/report.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class IReportService {
  Future<NetworkServiceResponse<ReportResponse>> getPreviewPdfResponse(String surveyGuid, {required Survey survey});
  Future<NetworkServiceResponse<ReportResponse>> getDownloadPdfResponse(String surveyGuid, {required Survey survey});
}
