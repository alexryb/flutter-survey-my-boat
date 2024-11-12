import 'dart:async';

import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_client_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class ClientService extends NetworkService implements IClientService {
  static const _clientsUrl = "/clients";

  @override
  Future<NetworkServiceResponse<ClientListResponse>> getClientListResponse(String surveyorGuid) async {
    SecureRestClient? _restClient = await oauthRestClient;
    String endPointUrl = _clientsUrl + "?surveyorGuid=$surveyorGuid";
    var result = await _restClient!.getRequest<ClientList>(restApiBaseUrl.toString(), endPointUrl);
    if (result.mappedResult != null) {
      return new NetworkServiceResponse(
        content: ClientListResponse(
            data: ClientList.fromJson(result.mappedResult)
        ),
        success: result.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result.networkServiceResponse.success,
        message: result.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> getClientResponse(String clientGuid) async {
    SecureRestClient? _restClient = await oauthRestClient;
    var result = await _restClient?.getRequest<Client>(restApiBaseUrl.toString(), _clientsUrl + "/" + clientGuid);
    if (result?.mappedResult != null) {
      Client _client = Client.fromJson(result?.mappedResult);
      _client.inSync = true;
      return new NetworkServiceResponse(
        content: ClientResponse(
            data: _client
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> createClientResponse(Client client) async {
    SecureRestClient? _restClient = await oauthRestClient;
    var result = await _restClient?.postRequest<Client>(restApiBaseUrl.toString(), _clientsUrl, client);
    if (result?.mappedResult != null) {
      Client _client = Client.fromJson(result?.mappedResult);
      _client.inSync = true;
      return new NetworkServiceResponse(
        content: ClientResponse(
            data: _client
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> saveClientResponse(Client client) async {
    SecureRestClient? _restClient = await oauthRestClient;
    var result = await _restClient?.putRequest<Client>(restApiBaseUrl.toString(), _clientsUrl + "/" + client.clientGuid!, client);
    if (result?.mappedResult != null) {
      Client _client = Client.fromJson(result?.mappedResult);
      _client.inSync = true;
      return new NetworkServiceResponse(
        content: ClientResponse(
            data: _client
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> validateEmailAddressResponse(String emailAddress) async {
    SecureRestClient? _restClient = await oauthRestClient;
    var _clientExistsResult = await _restClient?.getRequest<Client>(
        restApiBaseUrl.toString(),
        _clientsUrl +
            "/checkEmail?emailAddress=${emailAddress}");
    if (_clientExistsResult?.mappedResult != null) {
      Client _client = Client.fromJson(_clientExistsResult?.mappedResult);
      return new NetworkServiceResponse(
          content: ClientResponse(
              data: _client
          ),
          success: true,
          validate: true,
          message: "Client already exists. Please use another email or accept that client");
    }
    return new NetworkServiceResponse(
        content: null,
        success: true,
        validate: true);
  }
}
