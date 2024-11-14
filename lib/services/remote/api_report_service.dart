import 'dart:async';

import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/model/report.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_report_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class ReportService extends NetworkService implements IReportService {
  static const _reportsUrl = "/reports";

  @override
  Future<NetworkServiceResponse<ReportResponse>> getPreviewPdfResponse(String surveyGuid, {required Survey survey}) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Report>(restApiBaseUrl.toString(), '$_reportsUrl/$surveyGuid/generate?version=${Injector.SETTINGS?.version}');
    if (result?.mappedResult != null) {
      return new NetworkServiceResponse(
        content: ReportResponse(
            data: Report.fromJson(result?.mappedResult)
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<ReportResponse>> getDownloadPdfResponse(String surveyGuid, {required Survey survey}) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Report>(restApiBaseUrl.toString(), '$_reportsUrl/$surveyGuid/download?version=${Injector.SETTINGS?.version}');
    if (result?.mappedResult != null) {
      return new NetworkServiceResponse(
        content: ReportResponse(
            data: Report.fromJson(result?.mappedResult)
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }
}
