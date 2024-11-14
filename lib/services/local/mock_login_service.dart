
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/services/interfaces/i_login_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:uuid/uuid.dart';

class MockLoginService implements ILoginService {

  @override
  Future<NetworkServiceResponse<LoginResponse>> fetchLoginResponse(
      Login userLogin) async {
    //await Future.delayed(Duration(seconds: 2));
    String uuid = new Uuid().v4();
    LoginData loginData = LoginData();

    await _fetchSurveyor();

    LoginResponse response = new LoginResponse(
        data: loginData);

    return Future.value(NetworkServiceResponse(
        success: true,
        content: response,
        message: UIData.success));
  }

  @override
  Future<NetworkServiceResponse<LoginResponse>> changePasswordResponse(Login userLogin, String newPassword) {
    return fetchLoginResponse(userLogin);
  }

  @override
  Future<NetworkServiceResponse<LoginResponse>> recoverPasswordResponse(Login login) {
    // TODO: implement recoverPasswordResponse
    throw UnimplementedError();
  }
}

Future<Null> _fetchSurveyor() async {
  StorageBloc localStorageBloc = new StorageBloc();
  bool isSurveyorExists = await localStorageBloc.isSurveyorExists();
  if(!isSurveyorExists) {
    String jsonString = await _loadSurveyorAsset();
    final jsonResponse = json.decode(jsonString);
    localStorageBloc.saveSurveyor(jsonResponse);
    localStorageBloc.dispose();
  }
}

Future<String> _loadSurveyorAsset() async {
  return await rootBundle.loadString('assets/data/surveyor.json');
}