import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/user_signup_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {

  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;

  final signUpResultController = BehaviorSubject<LoginData>();
  Stream<dynamic> get signUpResult => signUpResultController.stream;

  Future<void> signUpUserAccount(UserSignUpViewModel signUp) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.signUpUserAccount;
    await signUp.signUpUserAccount(signUp);

    process.loading = false;
    process.response = signUp.apiCallResult;
    //for error dialog
    apiController.add(process);
    signUpResultController.add(signUp.signUpResult!);

  }

  Future<void> signUpSurveyor(UserSignUpViewModel signUp) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.signUpSurveyor;
    await signUp.signUpSurveyor(signUp);

    process.loading = false;
    process.response = signUp.apiCallResult;
    //for error dialog
    apiController.add(process);
    signUpResultController.add(signUp.signUpResult!);

  }

  void dispose() {
    apiController.close();
    signUpResultController.close();
  }
}
