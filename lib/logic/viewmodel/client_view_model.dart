import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/client_search_filter.dart';
import 'package:surveymyboatpro/services/interfaces/i_client_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class ClientViewModel extends BaseViewModel {
  String? clientGuid;
  String? emailAddress;

  Client? clientResult;
  ClientList? clientListResult;
  NetworkServiceResponse? apiCallResult;

  ClientSearchFilter? searchFilter;

  ClientViewModel.search({this.searchFilter});

  ClientViewModel.fetch({this.clientGuid});

  ClientViewModel.validate({this.emailAddress});

  ClientViewModel.create(Client client) {
    this.clientResult = client;
  }

  Future<Null> getClients() async {
    IClientService clientService = await new Injector(await flavor).clientService;
    NetworkServiceResponse<ClientListResponse> result = await clientService.getClientListResponse(searchFilter!.surveyorGuid!);
    this.apiCallResult = result;
    if(result.content != null) this.clientListResult = result.content?.data;
  }

  Future<Null> getClient() async {
    IClientService clientService = await new Injector(await flavor).clientService;
    NetworkServiceResponse<ClientResponse> result = await clientService.getClientResponse(clientGuid!);
    this.apiCallResult = result;
    if(result.content != null) this.clientResult = result.content?.data;
  }

  Future<Null> createClient() async {
    IClientService clientService = await new Injector(Flavor.REMOTE).clientService;
    NetworkServiceResponse<ClientResponse> result = await clientService.createClientResponse(clientResult!);
    this.apiCallResult = result;
    if(result.content != null) this.clientResult = result.content?.data;
  }

  Future<Null> saveClient() async {
    IClientService clientService = await new Injector(await flavor).clientService;
    NetworkServiceResponse<ClientResponse> result = await clientService.saveClientResponse(clientResult!);
    this.apiCallResult = result;
    if(result.content != null) this.clientResult = result.content?.data;
  }

  Future<Null> validateEmailAddress() async {
    IClientService clientService = await new Injector(Flavor.REMOTE).clientService;
    NetworkServiceResponse<ClientResponse> _clientResult = await clientService.validateEmailAddressResponse(emailAddress!);
    this.apiCallResult = _clientResult;
    if(_clientResult.content != null) this.clientResult = _clientResult.content?.data;
  }

}