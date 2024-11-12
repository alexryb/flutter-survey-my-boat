import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/user_login_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;

  final loginResultController = BehaviorSubject<LoginData>();
  Stream<dynamic> get loginResult => loginResultController.stream;

  Future<void> login(UserLoginViewModel userLogin) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.performLogin;
    await userLogin.performLogin(userLogin);

    process.loading = false;
    process.response = userLogin.apiCallResult;
    //for error dialog
    apiController.add(process);
    loginResultController.add(userLogin.loginResult!);

  }

  Future<void> changePassword(UserLoginViewModel userLogin) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.changePassword;
    await userLogin.changePassword(userLogin);

    process.loading = false;
    process.response = userLogin.apiCallResult;
    //for error dialog
    apiController.add(process);
    loginResultController.add(userLogin.loginResult!);

  }

  void dispose() {
    apiController.close();
    loginResultController.close();
  }

  Future<void> recoverPassword(UserLoginViewModel userLogin) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.recoverPassword;
    await userLogin.recoverPassword(userLogin);

    process.loading = false;
    process.response = userLogin.apiCallResult;
    //for error dialog
    apiController.add(process);
    loginResultController.add(userLogin.loginResult!);

  }
}
