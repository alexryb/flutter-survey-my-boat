import 'dart:async';

import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/client_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/surveyor_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/client_view_model.dart';
import 'package:surveymyboatpro/logic/viewmodel/survey_view_model.dart';
import 'package:surveymyboatpro/logic/viewmodel/surveyor_view_model.dart';
import 'package:surveymyboatpro/logic/viewmodel/sync_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:rxdart/rxdart.dart';

class SyncBloc {
  bool _syncSurveyor = false;
  bool _syncClient = false;
  bool _syncSurvey = false;

  final StorageBloc _localStorageBloc = new StorageBloc();
  final SurveyorBloc _surveyorBloc = new SurveyorBloc();
  final SurveyBloc _surveyBloc = new SurveyBloc();
  final ClientBloc _clientBloc = new ClientBloc();

  final apiController = BehaviorSubject<FetchProcess>();

  Stream<FetchProcess> get apiResult => apiController.stream;

  final syncResultController = StreamController<bool>();

  Stream<bool> get syncResult => syncResultController.stream;

  Future<void> sync(SyncViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.syncDataRemote;

    _syncSurveyor = await syncSurveyor();
    _syncClient = await syncClients();
    _syncSurvey = await syncSurveys();

    process.loading = false;
    process.response = NetworkServiceResponse<String>(
      content: "SUCCESS",
      success: true,
    );
    //for error dialog
    apiController.add(process);
    syncResultController.add(_syncSurveyor & _syncClient & _syncSurvey);
  }

  Future<void> syncQuiet(SyncViewModel model) async {
    Flavor _f = await model.flavor;
    if(_f.toString() == Flavor.REMOTE.toString()) {
      _syncSurvey = await syncSurveys();
      _syncSurveyor = await syncSurveyor();
      _syncClient = await syncClients();
    }
  }

  Future<bool> syncSurveyor() async {
    Surveyor _surveyor = await _localStorageBloc.loadSurveyor();
    if(_surveyor != null) {
      if(!_surveyor.inSync) {
        await _surveyorBloc.saveSurveyor(SurveyorViewModel.save(_surveyor));
      }
    }
    return true;
  }

  Future<bool> syncSurveys() async {
    List<Survey> surveys = await _localStorageBloc.getAllSurveys();
    if(surveys != null) {
      int count = surveys.length;
      for (Survey survey in surveys) {
        if((!survey.inSync)) {
          await _surveyBloc.saveSurvey(SurveyViewModel.save(survey), apiType: ApiType.createSurvey);
        }
      }
    }
    return true;
  }

  Future<bool> syncClients() async {
    List<Client> clients = await _localStorageBloc.getAllClients();
    if(clients != null) {
      for (Client client in clients) {
        if(!client.inSync) {
          await _clientBloc.saveClient(ClientViewModel.create(client));
        }
      }
    }
    return true;
  }

  void dispose() {
    apiController?.close();
    syncResultController?.close();
    _localStorageBloc.dispose();
    _surveyorBloc.dispose();
    _clientBloc.dispose();
    _surveyBloc.dispose();
  }
}
