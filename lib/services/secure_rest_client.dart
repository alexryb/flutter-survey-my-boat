import 'dart:async';

import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/oauth/client_credentials_grant.dart';
import 'package:surveymyboatpro/services/oauth/credentials.dart';
import 'package:surveymyboatpro/services/remote/oauth_exceptions.dart';
import 'package:surveymyboatpro/services/oauth/resource_owner_password_grant.dart';

final _identifier = "imb-security-oauth2-read-write-client";
final _secret = "spring-security-oauth2-read-write-client-password1234";
final _scope = "read write";
final oauthApiBaseUrl = Injector.SETTINGS?.oauthBaseUrl;

class SecureRestClient extends ApiRestClient {

  Login? _login;
  String? badCredentialsMessage;
  Credentials? _credentials;

  SecureRestClient(Login login) {
    _login = login;
    badCredentialsMessage = "Bad credentials for ${_login?.username}.\nPlease try to log in again or reset your password.";
  }

  Future<MappedNetworkServiceResponse<T>> getRequest<T>(String baseUrl, String resourcePath) async {
    try {
      if (_credentials == null || _credentials!.isExpired) await _authenticate(_login?.username, _login?.password);
    } on FormatException catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authentication Service is not available. Please report the error to support group."));
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: badCredentialsMessage));
    }
    try {
      return await super.getRequest(baseUrl, resourcePath);
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authorization of ${_login?.username} expired.\nPlease save your changes in offline mode, close the application and start again.\nThis is the known bug and we are working on it"));
    }
  }

  Future<MappedNetworkServiceResponse<T>> postRequest<T>(String baseUrl, String resourcePath, dynamic data) async {
    try {
      if (_credentials == null || _credentials!.isExpired) await _authenticate(_login?.username, _login?.password);
    } on FormatException catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authentication Service is not available. Please report the error to support group."));
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: badCredentialsMessage));
    }
    try {
      return await super.postRequest(baseUrl, resourcePath, data);
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authorization of ${_login?.username} expired.\nPlease save your changes in offline mode, close the application and start again.\nThis is the known bug and we are working on it"));
    }
  }

  Future<MappedNetworkServiceResponse<T>> putRequest<T>(String baseUrl, String resourcePath, dynamic data) async {
    try {
      if (_credentials == null || _credentials!.isExpired) await _authenticate(_login?.username, _login?.password);
    } on FormatException catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authentication Service is not available. Please report the error to support group."));
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: badCredentialsMessage));
    }
    try {
      return await super.putRequest(baseUrl, resourcePath, data);
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authorization of ${_login!.username} expired.\nPlease save your changes in offline mode, close the application and start again.\nThis is the known bug and we are working on it"));
    }
  }

  @override
  Future<MappedNetworkServiceResponse<T>> deleteRequest<T>(String baseUrl, String resourcePath) async {
    try {
      if (_credentials == null || _credentials!.isExpired) await _authenticate(_login!.username, _login!.password);
    } on FormatException catch (e) {
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authentication Service is not available. Please report the error to support group."));
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: badCredentialsMessage));
    }
    try {
      return await super.deleteRequest(baseUrl, resourcePath);
    } on AuthorizationException catch (e) {
      //await _getOwnerPasswordClient(_login.username, _login.password);
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "Authorization of ${_login!.username} expired.\nPlease save your changes in offline mode, close the application and start again.\nThis is the known bug and we are working on it"));
    }
  }

  Future<Null> _getOwnerPasswordClient(final username, final password) async {
    Uri uri = Uri.parse(oauthApiBaseUrl + "/token");
    _credentials = await resourceOwnerPasswordGrant(
        uri,
        username,
        password,
        identifier: _identifier,
        secret: _secret,
        scopes: _scope.split(" ").map((e) => (e.trim())).toList()
    );
    headers.putIfAbsent(
        "Authorization", () => ("Bearer " + _credentials!.accessToken));

  }

  Future<Null> _getClientCredentialsClient() async {
    Uri uri = Uri.parse(oauthApiBaseUrl + "/token");
    _credentials = await clientCredentialsGrant(
        uri,
        _identifier,
        _secret,
        scopes: _scope.split(" ").map((e) => (e.trim())).toList()
    );
    headers.putIfAbsent(
        "Authorization", () => ("Bearer " + _credentials!.accessToken));
  }

  Future<Null> _authenticate(final username, final password) async {
    await _getOwnerPasswordClient(username, password);
  }

}