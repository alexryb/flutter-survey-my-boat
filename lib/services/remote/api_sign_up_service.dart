import 'dart:async';

import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/sign_up.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_signup_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class SignUpService extends NetworkService implements ISignUpService {
  static const _userSignUpUrl = "/users";
  static const _userLoginUri = "/users/login";
  static const _surveyorUri = "/surveyors";

  @override
  Future<NetworkServiceResponse<SignUpResponse>> signUpSurveyorResponse(SignUp signUp) async {

    Login _login = Login(username: signUp.username, password: signUp.password);
    SecureRestClient? _oauthRestClient = await oauthRestClient;

    var _loginResult = await _oauthRestClient?.getRequest<OauthUserResource>(
        oauthApiBaseUrl.toString(), _userLoginUri);

    if (_loginResult?.mappedResult == null) {
      return errorResponse<SignUpResponse>(_loginResult).networkServiceResponse;
    }

    LoginData _userData = LoginData.fromJson(_loginResult?.mappedResult);
    _userData.login = _login;

    OauthUserResource _userResource =
        OauthUserResource.fromJson(_loginResult?.mappedResult);

    var _surveyorExistsResult =
        await _oauthRestClient?.getRequest<Surveyor>(
            restApiBaseUrl.toString(),
            _surveyorUri +
                "/checkEmail?emailAddress=${signUp.surveyor?.emailAddress}");
    if (_surveyorExistsResult?.mappedResult == null) {
      var _surveyorResult = await _oauthRestClient?.postRequest<Surveyor>(
          restApiBaseUrl.toString(), _surveyorUri, signUp.surveyor);

      if (_surveyorResult?.mappedResult == null) {
        return errorResponse<SignUpResponse>(_surveyorResult)
            .networkServiceResponse;
      }

      Surveyor _surveyor = new Surveyor.fromJson(_surveyorResult?.mappedResult);
      _userResource.userGuid = _surveyor.surveyorGuid;
      _userData.surveyorGuid = _surveyor.surveyorGuid;
      await _oauthRestClient?.putRequest<OauthUserResource>(
          oauthApiBaseUrl.toString(), _userSignUpUrl, _userResource);

      _surveyor.inSync = true;
      localStorageBloc.saveSurveyor(_surveyor);

      var res = SignUpResponse(data: _userData);

      return new NetworkServiceResponse(
        content: res,
        success: _loginResult?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        content: null,
        success: false,
        message: "Email already exists. Please use another email or sign in");
  }

  @override
  Future<NetworkServiceResponse<SignUpResponse>> signUpUserAccountResponse(
      SignUp signUp) async {

    Login _login = Login(username: signUp.username, password: signUp.password);
    OauthUserResource _userResource = new OauthUserResource(
        username: _login.username, password: _login.password);

    ApiRestClient _restClient = new ApiRestClient();
    MappedNetworkServiceResponse<OauthUserResource>? _loginResult = await _restClient.getRequest<OauthUserResource>(
        oauthApiBaseUrl.toString(),
        _userSignUpUrl + "?checkuser=${signUp.username}");

    if (_loginResult.mappedResult == null) {
      
      var _signUpResult = await _restClient.postRequest<OauthUserResource>(
          oauthApiBaseUrl.toString(), _userSignUpUrl, _userResource);
      if (_signUpResult.mappedResult == null) {
        return errorResponse<SignUpResponse>(_signUpResult)
            .networkServiceResponse;
      }

      await localStorageBloc.saveCredentials(LoginData.login(_login));

      SecureRestClient? _oauthRestClient = await oauthRestClient;
      _loginResult = await _oauthRestClient?.getRequest<OauthUserResource>(
          oauthApiBaseUrl.toString(), _userLoginUri);
      if (_loginResult?.mappedResult == null) {
        return errorResponse<SignUpResponse>(_loginResult)
            .networkServiceResponse;
      }

      _userResource = OauthUserResource.fromJson(_loginResult?.mappedResult);
      LoginData _userData = LoginData.fromJson(_loginResult?.mappedResult);

      _userData.login = _login;
      _userResource.password = _login.password;

      return new NetworkServiceResponse(
        content: SignUpResponse(data: _userData, user: _userResource),
        success: _loginResult?.networkServiceResponse.success,
      );
    }

    return new NetworkServiceResponse(
        content: null,
        success: false,
        message: "User already exists. Please use another username or sign in");
  }
}
