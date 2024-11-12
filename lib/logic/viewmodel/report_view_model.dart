import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/report.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/services/interfaces/i_report_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class ReportViewModel extends BaseViewModel {

  Survey? survey;
  Report? reportResult;
  NetworkServiceResponse? apiCallResult;

  ReportViewModel.Survey({this.survey});

  Future<Null> previewReport() async {
    IReportService service = await new Injector(Flavor.LOCAL).reportService;
    NetworkServiceResponse<ReportResponse> result = await service.getPreviewPdfResponse(survey!.surveyGuid!, survey: survey!);
    apiCallResult = result;
    if(result.content != null) {
      reportResult = result.content?.data;
    }
  }

  Future<Null> downloadReport() async {
    IReportService service = await new Injector(Flavor.LOCAL).reportService;
    NetworkServiceResponse<ReportResponse> result = await service.getDownloadPdfResponse(survey!.surveyGuid!, survey: survey!);
    apiCallResult = result;
    if(result.content != null) {
      reportResult = result.content?.data;
    }
  }
}
