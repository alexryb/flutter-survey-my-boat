import 'dart:async';

import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/report_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/report.dart';
import 'package:rxdart/rxdart.dart';

class ReportBloc {

  final StorageBloc _storage = new StorageBloc();

  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;

  final reportResultController = StreamController<Report>();
  final downloadResultController = StreamController<Report>();
  
  Stream<Report> get report => reportResultController.stream;
  Stream<Report> get download => downloadResultController.stream;

  Future<void> previewReport(ReportViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.generateReport;

    await model.previewReport();

    process.loading = false;
    process.response = model.apiCallResult;

    //for error dialog
    apiController.add(process);

    Report report = model.reportResult!;
    reportResultController.add(report);

  }

  Future<void> downloadReport(ReportViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.downloadReport;

    await model.downloadReport();

    process.loading = false;
    process.response = model.apiCallResult;

    //for error dialog
    apiController.add(process);

    Report report = model.reportResult!;
    downloadResultController.add(report);

  }

  void dispose() {
    apiController.close();
    _storage.dispose();
    reportResultController.close();
    downloadResultController.close();
  }
}
