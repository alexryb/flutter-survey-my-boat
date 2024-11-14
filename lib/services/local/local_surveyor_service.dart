
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/interfaces/i_surveyor_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class LocalSurveyorService implements ISurveyorService {

  @override
  Future<NetworkServiceResponse<SurveyorResponse>> fetchSurveyorResponse(String surveyorGuid) async {
    Surveyor surveyor = await _fetchSurveyor(surveyorGuid);
    return Future.value(NetworkServiceResponse(
        success: true,
        content: SurveyorResponse(
            data: surveyor
        ),
    ));
  }

  @override
  Future<NetworkServiceResponse<SurveyorResponse>> saveSurveyorResponse(Surveyor surveyor) {
    _saveSurveyor(surveyor);
    return Future.value(NetworkServiceResponse(
        success: true,
        content: SurveyorResponse(
          data: surveyor
        ),
        message: UIData.success));
  }

}

StorageBloc _localStorageBloc = new StorageBloc();

_saveSurveyor(Surveyor surveyor) {
  _localStorageBloc.saveSurveyor(surveyor);
}

Future<Surveyor> _fetchSurveyor(String userGuid) async {
  bool isSurveyorExists = await _localStorageBloc.isSurveyorExists();
  Surveyor surveyor;
  if(isSurveyorExists) {
    surveyor = await _localStorageBloc.loadSurveyor();
  } else {
    String jsonString = await _loadSurveyorAsset();
    final jsonResponse = json.decode(jsonString);
    surveyor = new Surveyor.fromJson(jsonResponse);
    _localStorageBloc.saveSurveyor(jsonResponse);
  }
  return surveyor;
}

Future<String> _loadSurveyorAsset() async {
  return await rootBundle.loadString('assets/data/surveyor.json');
}