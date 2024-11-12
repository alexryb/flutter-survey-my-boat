import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_client_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:uuid/uuid.dart';

class LocalClientService implements IClientService {
  @override
  Future<NetworkServiceResponse<ClientListResponse>> getClientListResponse(String surveyorGuid) async {
    ClientList clients = await _getAll();
    return new NetworkServiceResponse(
      content: new ClientListResponse(data: clients),
      success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> getClientResponse(String clientGuid) async {
    Client? client = await _fetchClient(clientGuid);
    return new NetworkServiceResponse(
      content: new ClientResponse(data: client),
      success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> createClientResponse(Client client) async {
    client.clientGuid = Uuid().v4().replaceAll("-", "").toUpperCase();
    await _createClient(client);
    return new NetworkServiceResponse(
      content: new ClientResponse(data: client),
      success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> saveClientResponse(Client client) async {
    await _saveClient(client);
    return new NetworkServiceResponse(
      content: new ClientResponse(data: client),
      success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<ClientResponse>> validateEmailAddressResponse(String emailAddress)  async {
    // TODO: implement validateEmailAddressResponse
    throw UnimplementedError();
  }
}

StorageBloc _localStorageBloc = new StorageBloc();

Future<String> _loadClientsAsset() async {
  return await rootBundle.loadString('assets/data/clients.json');
}

Future<Client?> _fetchClient(String clientGuid) async {
  Client? result;
  bool clientExists = await _localStorageBloc.isClientExists(clientGuid);
  if (!clientExists) {
    List<Client> clients = await _loadAssetClients();
    for (Client c in clients) {
      if (c.clientGuid == clientGuid) {
        result = c;
      }
    }
    result ??= clients.first;
  } else {
    result = await _localStorageBloc.loadClient(clientGuid);
  }
  return result;
}

Future<ClientList> _getAll() async {
  List<Client> result = await _localStorageBloc.getAllClients();
  if (result.isEmpty) {
    result = await _loadAssetClients();
  }
  return new ClientList(elements: result);
}

Future<Client?> _createClient(Client client) async {
  Client? result;
  bool clientExists = await _localStorageBloc.isClientExists(client.clientGuid!);
  if (!clientExists) {
    _localStorageBloc.saveClient(client.clientGuid!, client);
  } else {
    result = await _localStorageBloc.loadClient(client.clientGuid!);
  }
  return result;
}

Future<Client?> _saveClient(Client client) async {
  Client? result;
  bool clientExists = await _localStorageBloc.isClientExists(client.clientGuid!);
  if (clientExists) {
    _localStorageBloc.saveClient(client.clientGuid!, client);
  }
  return result;
}

Future<List<Client>> _loadAssetClients() async {
  String jsonString = await _loadClientsAsset();
  final jsonResponse = json.decode(jsonString);
  return new ClientList.fromJson(jsonResponse).elements;
}
