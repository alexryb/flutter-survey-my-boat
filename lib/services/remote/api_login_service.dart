import 'dart:async';

import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_login_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/oauth/oauth_exceptions.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class LoginService extends NetworkService implements ILoginService {
  static const _userLoginUri = "/users/login";
  static const _userUri = "/users";

  @override
  Future<NetworkServiceResponse<LoginResponse>> fetchLoginResponse(Login userLogin) async {
    SecureRestClient oauthRestClient = new SecureRestClient(userLogin);

    MappedNetworkServiceResponse result;

    try {
      result = await oauthRestClient.getRequest<OauthUserResource>(oauthApiBaseUrl.toString(), _userLoginUri);
    } on AuthorizationException catch (e) {
      result = exceptionResponse(e, "Please ensure username/password entered correctly");
    }

    if (result.mappedResult == null) {
      return errorResponse<LoginResponse>(result).networkServiceResponse;
    }

    var loginResponse = LoginResponse();
    loginResponse.data = LoginData.fromJson(result.mappedResult);
    loginResponse.data?.login = userLogin;
    //loginResponse.data.authToken = "Bearer " + _oauthRestClient.oauthClient.credentials.accessToken;

    if(result.mappedResult["userGuid"] == null) {
      return new NetworkServiceResponse(
        content: loginResponse,
        success: true,
        validate: false,
      );
    }

    loginResponse.data?.surveyorGuid = result.mappedResult["userGuid"];

    var surveyorResult = await oauthRestClient.getRequest<Surveyor>(restApiBaseUrl.toString(), "/surveyors/${loginResponse.data!.surveyorGuid}");

    if(surveyorResult.mappedResult == null) {
      return new NetworkServiceResponse(
        content: loginResponse,
        success: true,
        validate: false,
      );
    }

    Surveyor surveyor = Surveyor.fromJson(surveyorResult.mappedResult);
    surveyor.inSync = true;
    localStorageBloc.saveSurveyor(surveyor);

    return new NetworkServiceResponse(
      content: loginResponse,
      success: result.networkServiceResponse.success,
    );
  }

  @override
  Future<NetworkServiceResponse<LoginResponse>> changePasswordResponse(Login userLogin, String newPassword) async {
    SecureRestClient? restClient = await oauthRestClient;

    MappedNetworkServiceResponse? loginResult;

    try {
      loginResult = await restClient?.getRequest<OauthUserResource>(oauthApiBaseUrl.toString(), _userLoginUri);
    } on AuthorizationException catch (e) {
      loginResult = exceptionResponse(e, "Please ensure username/password entered correctly");
    }

    if (loginResult!.mappedResult == null) {
      return errorResponse<LoginResponse>(loginResult).networkServiceResponse;
    }

    OauthUserResource userResource =
      OauthUserResource.fromJson(loginResult.mappedResult);
    userResource.password = newPassword;

    var changePasswordResult = await restClient?.putRequest<OauthUserResource>(oauthApiBaseUrl.toString(), '$_userUri/password', userResource);

    if(changePasswordResult?.mappedResult == null) {
      return errorResponse<LoginResponse>(changePasswordResult).networkServiceResponse;
    }

    userResource = OauthUserResource.fromJson(changePasswordResult?.mappedResult);
    userLogin.password = userResource.password;

    var loginResponse = LoginResponse();
    loginResponse.data = LoginData.fromJson(changePasswordResult?.mappedResult);
    loginResponse.data?.login = userLogin;

    return new NetworkServiceResponse(
      content: loginResponse,
      success: changePasswordResult?.networkServiceResponse.success,
    );
  }

  @override
  Future<NetworkServiceResponse<LoginResponse>> recoverPasswordResponse(Login login) async {
    ApiRestClient restClient = new ApiRestClient();
    var loginResult = await restClient.getRequest<OauthUserResource>(
        oauthApiBaseUrl.toString(),
        "$_userUri?checkuser=${login.username}");
    if (loginResult.mappedResult != null) {
      OauthUserResource userResource = OauthUserResource.fromJson(loginResult.mappedResult);
      var resetPasswordResult = await restClient.postRequest<OauthUserResource>(oauthApiBaseUrl.toString(), '$_userUri/password', userResource);
      if(resetPasswordResult.mappedResult == null) {
        return errorResponse<LoginResponse>(resetPasswordResult).networkServiceResponse;
      }

      userResource = OauthUserResource.fromJson(resetPasswordResult.mappedResult);
      login.password = userResource.password;
      var loginResponse = LoginResponse();
      loginResponse.data = LoginData.fromJson(resetPasswordResult.mappedResult);
      loginResponse.data?.login = login;

      return new NetworkServiceResponse(
        content: loginResponse,
        success: resetPasswordResult.networkServiceResponse.success,
      );

    }
    return new NetworkServiceResponse(
        content: null,
        success: false,
        message: "User not exists. Please use another username or sign up");
  }

}
