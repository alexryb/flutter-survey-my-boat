import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/client_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

class ClientBloc {
  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;
  
  final clientsResultController = StreamController<ClientList>();
  final clientResultController = StreamController<Client>();
  
  Stream<ClientList> get clients => clientsResultController.stream;
  Stream<Client> get client => clientResultController.stream;

  Future<void> getClient(ClientViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getClient;

    await model.getClient();

    process.loading = false;
    process.response = model.apiCallResult!;
    //for error dialog
    apiController.add(process);
    clientResultController.add(model.clientResult!);

  }

  Future<void> getClients(ClientViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getClients;

    await model.getClients();

    process.loading = false;
    process.response = model.apiCallResult!;

    //for error dialog
    apiController.add(process);
    clientsResultController.add(model.clientListResult!);

  }

  Future<void> saveClient(ClientViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.saveClient;

    await model.saveClient();

    process.loading = false;
    process.response = model.apiCallResult!;
    //for error dialog
    apiController.add(process);
    clientResultController.add(model.clientResult!);

  }

  Future<void> createClient(ClientViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.createClient;

    await model.createClient();

    process.loading = false;
    process.response = model.apiCallResult!;
    //for error dialog
    apiController.add(process);
    clientResultController.add(model.clientResult!);

  }

  void dispose() {
    apiController?.close();
    clientsResultController?.close();
    clientResultController?.close();
  }

  Future<Client> validateEmailAddress(String emailAddress) async {
    ClientViewModel _viewModel = ClientViewModel.validate(emailAddress: emailAddress);
    await _viewModel.validateEmailAddress();
    return _viewModel.clientResult!;
  }
}
