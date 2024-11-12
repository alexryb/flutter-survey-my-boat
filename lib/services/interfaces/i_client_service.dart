import 'dart:async';

import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class IClientService {
  Future<NetworkServiceResponse<ClientListResponse>> getClientListResponse(String surveyorGuid);
  Future<NetworkServiceResponse<ClientResponse>> getClientResponse(String clientGuid);
  Future<NetworkServiceResponse<ClientResponse>> createClientResponse(Client client);
  Future<NetworkServiceResponse<ClientResponse>> saveClientResponse(Client client);
  Future<NetworkServiceResponse<ClientResponse>> validateEmailAddressResponse(String emailAddress);
}
