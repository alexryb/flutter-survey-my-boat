import 'dart:async';

import 'package:flutter/material.dart';

import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/services/interfaces/i_login_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class UserLoginViewModel extends BaseViewModel {
  String? username, password, newPassword;

  LoginData? loginResult;
  NetworkServiceResponse? apiCallResult;

  //for login
  UserLoginViewModel.withLogin({@required this.username, @required this.password, this.newPassword});

  Future<Null> performLogin(UserLoginViewModel userLogin) async {
    ILoginService loginService = await new Injector(Flavor.REMOTE).loginService;
    NetworkServiceResponse<LoginResponse> result = await loginService.fetchLoginResponse(
            Login(username: userLogin.username!, password: userLogin.password)
    );
    apiCallResult = result;
    if(result.content != null) loginResult = result.content!.data;
  }

  Future<Null> changePassword(UserLoginViewModel userLogin) async {
    ILoginService loginService = await new Injector(Flavor.REMOTE).loginService;
    NetworkServiceResponse<LoginResponse> result = await loginService.changePasswordResponse(
        Login(username: userLogin.username!, password: userLogin.password), newPassword!
    );
    apiCallResult = result;
    if(result.content != null) loginResult = result.content!.data;
  }

  Future<Null> recoverPassword(UserLoginViewModel userLogin) async {
    ILoginService loginService = await new Injector(Flavor.REMOTE).loginService;
    NetworkServiceResponse<LoginResponse> result = await loginService.recoverPasswordResponse(
        Login(username: userLogin.username!,)
    );
    apiCallResult = result;
    if(result.content != null) loginResult = result.content!.data;
  }
}
