import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/sign_up.dart';
import 'package:surveymyboatpro/services/interfaces/i_signup_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:uuid/uuid.dart';

class MockSignUpService implements ISignUpService {

  @override
  Future<NetworkServiceResponse<SignUpResponse>> signUpSurveyorResponse(
      SignUp userLogin) async {
    //await Future.delayed(Duration(seconds: 2));
    String uuid = new Uuid().v4();
    LoginData loginData = LoginData();

    await _fetchSurveyor();

    SignUpResponse response = new SignUpResponse(
        data: loginData);

    return Future.value(NetworkServiceResponse(
        success: true,
        content: response,
        message: UIData.success));
  }

  @override
  Future<NetworkServiceResponse<SignUpResponse>> signUpUserAccountResponse(SignUp signUp) {
    return Future.value(NetworkServiceResponse(
        success: false,
        content: null,
        message: UIData.error));
  }
}

StorageBloc _localStorageBloc = new StorageBloc();

Future<Null> _fetchSurveyor() async {
  bool isSurveyorExists = await _localStorageBloc.isSurveyorExists();
  if(!isSurveyorExists) {
    String jsonString = await _loadSurveyorAsset();
    final jsonResponse = json.decode(jsonString);
    _localStorageBloc.saveSurveyor(jsonResponse);
  }
}

Future<String> _loadSurveyorAsset() async {
  return await rootBundle.loadString('assets/data/surveyor.json');
}



