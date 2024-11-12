import 'dart:async';

import 'package:surveymyboatpro/model/report.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/services/interfaces/i_report_service.dart';
import 'package:surveymyboatpro/services/local/local_report_pdf_builder.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class LocalReportService implements IReportService {

  Future<Report> createPdfReport(Survey survey) async {
    LocalReportPdfBuilder builder = new LocalReportPdfBuilder(survey);
    return await builder.createPdfReport();
  }

  @override
  Future<NetworkServiceResponse<ReportResponse>> getPreviewPdfResponse(String surveyGuid, {required Survey survey}) async {
    Report result = await createPdfReport(survey);
    return new NetworkServiceResponse(
        content: ReportResponse(
            data: result
        ),
        success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<ReportResponse>> getDownloadPdfResponse(String surveyGuid, {required Survey survey}) async {
    Report result = await createPdfReport(survey);
    return new NetworkServiceResponse(
      content: ReportResponse(
          data: result
      ),
      success: true,
    );
  }

}
