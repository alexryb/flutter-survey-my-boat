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

    Login login = Login(username: signUp.username, password: signUp.password);
    SecureRestClient? _oauthRestClient = await oauthRestClient;

    var loginResult = await _oauthRestClient?.getRequest<OauthUserResource>(
        oauthApiBaseUrl.toString(), _userLoginUri);

    if (loginResult?.mappedResult == null) {
      return errorResponse<SignUpResponse>(loginResult).networkServiceResponse;
    }

    LoginData userData = LoginData.fromJson(loginResult?.mappedResult);
    userData.login = login;

    OauthUserResource userResource =
        OauthUserResource.fromJson(loginResult?.mappedResult);

    var surveyorExistsResult =
        await _oauthRestClient!.getRequest<Surveyor>(
            restApiBaseUrl.toString(),
            "$_surveyorUri/checkEmail?emailAddress=${signUp.surveyor?.emailAddress}");
    if (surveyorExistsResult?.mappedResult == null) {
      var surveyorResult = await _oauthRestClient.postRequest<Surveyor>(
          restApiBaseUrl.toString(), _surveyorUri, signUp.surveyor);

      if (surveyorResult.mappedResult == null) {
        return errorResponse<SignUpResponse>(surveyorResult)
            .networkServiceResponse;
      }

      Surveyor surveyor = new Surveyor.fromJson(surveyorResult.mappedResult);
      userResource.userGuid = surveyor.surveyorGuid;
      userData.surveyorGuid = surveyor.surveyorGuid;
      await _oauthRestClient.putRequest<OauthUserResource>(
          oauthApiBaseUrl.toString(), _userSignUpUrl, userResource);

      surveyor.inSync = true;
      localStorageBloc.saveSurveyor(surveyor);

      var res = SignUpResponse(data: userData);

      return new NetworkServiceResponse(
        content: res,
        success: loginResult?.networkServiceResponse.success,
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

    Login login = Login(username: signUp.username, password: signUp.password);
    OauthUserResource userResource = new OauthUserResource(
        username: login.username, password: login.password);

    ApiRestClient restClient = new ApiRestClient();
    MappedNetworkServiceResponse<OauthUserResource>? loginResult = await restClient.getRequest<OauthUserResource>(
        oauthApiBaseUrl.toString(),
        "$_userSignUpUrl?checkuser=${signUp.username}");

    if (loginResult.mappedResult == null) {
      
      var signUpResult = await restClient.postRequest<OauthUserResource>(
          oauthApiBaseUrl.toString(), _userSignUpUrl, userResource);
      if (signUpResult.mappedResult == null) {
        return errorResponse<SignUpResponse>(signUpResult)
            .networkServiceResponse;
      }

      await localStorageBloc.saveCredentials(LoginData.login(login));

      SecureRestClient? _oauthRestClient = await oauthRestClient;
      loginResult = await _oauthRestClient?.getRequest<OauthUserResource>(
          oauthApiBaseUrl.toString(), _userLoginUri);
      if (loginResult?.mappedResult == null) {
        return errorResponse<SignUpResponse>(loginResult)
            .networkServiceResponse;
      }

      userResource = OauthUserResource.fromJson(loginResult?.mappedResult);
      LoginData userData = LoginData.fromJson(loginResult?.mappedResult);

      userData.login = login;
      userResource.password = login.password;

      return new NetworkServiceResponse(
        content: SignUpResponse(data: userData, user: userResource),
        success: loginResult?.networkServiceResponse.success,
      );
    }

    return new NetworkServiceResponse(
        content: null,
        success: false,
        message: "User already exists. Please use another username or sign in");
  }
}
