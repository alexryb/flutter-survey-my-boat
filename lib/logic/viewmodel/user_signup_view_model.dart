import 'dart:async';

import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/sign_up.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/interfaces/i_signup_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class UserSignUpViewModel extends BaseViewModel {
  String? username;
  String? password;
  Surveyor? surveyor;

  LoginData? signUpResult;
  NetworkServiceResponse? apiCallResult;

  UserSignUpViewModel.validate({required this.username, required this.password});

  //for signup
  UserSignUpViewModel.signUp({required this.username, required this.password, required this.surveyor}) {
    surveyor!.emailAddress = surveyor!.organization?.emailAddress;
    surveyor!.phoneNumber = surveyor!.organization?.phoneNumber;
    surveyor!.addressLine = surveyor!.organization?.addressLine;
    }

  Future<Null> signUpUserAccount(UserSignUpViewModel signUp) async {
    ISignUpService signUpService = await new Injector(Flavor.REMOTE).signUpService;
    NetworkServiceResponse<SignUpResponse> result = await signUpService.signUpUserAccountResponse(
        SignUp(username: signUp.username!, password: signUp.password!));
    apiCallResult = result;
    if(result.content != null) signUpResult = result.content!.data;
  }

  Future<Null> signUpSurveyor(UserSignUpViewModel signUp) async {
    ISignUpService signUpService = await new Injector(Flavor.REMOTE).signUpService;
    NetworkServiceResponse<SignUpResponse> result = await signUpService.signUpSurveyorResponse(
            SignUp(username: signUp.username!, password: signUp.password!, surveyor: signUp.surveyor!));
    apiCallResult = result;
    if(result.content != null) signUpResult = result.content!.data;
  }
}
