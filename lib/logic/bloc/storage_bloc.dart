import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/storage_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/surveyor.dart';

const String randomKey = "XmI43Xa3Y0HYLM3s7gE9zBlyc2MVxqjd";

class StorageBloc {

  Future<LoginData?> loadCredentials() async {
    StorageViewModel model = new StorageViewModel();
    return await model.loadCredentials();
  }

  Future<void> saveCredentials(LoginData userData) async {
    StorageViewModel model = new StorageViewModel();
    await model.saveCredentials(userData);
  }

  Future<void> deleteCredentials() async {
    StorageViewModel model = new StorageViewModel();
    await model.deleteCredentials();
  }

  Future<Settings?> loadSettings() async {
    StorageViewModel model = new StorageViewModel();
    return await model.loadSettings();
  }

  Future<void> saveSettings(Settings settings) async {
    StorageViewModel model = new StorageViewModel();
    await model.saveSettings(settings);
  }

  Future<void> deleteSettings() async {
    StorageViewModel model = new StorageViewModel();
    await model.deleteSettings();
  }

  Future<Map<String, dynamic>?> loadCodes() async {
    StorageViewModel model = new StorageViewModel();
    return await model.loadCodes();
  }

  Future<void> saveCodes(Map<String, CodeList> codes) async {
    StorageViewModel model = new StorageViewModel();
    model.saveCodes(codes);
  }

  Future<void> deleteCodes() async {
    StorageViewModel model = new StorageViewModel();
    await model.deleteCodes();
  }

  Future<void> deleteSurveys() async {
    StorageViewModel model = new StorageViewModel();
    await model.deleteSurveys();
  }

  Future<void> deleteClients() async {
    StorageViewModel model = new StorageViewModel();
    await model.deleteClients();
  }

  Future<List<Survey>> getAllSurveys() async {
    StorageViewModel model = new StorageViewModel();
    return await model.getAllSurveys();
  }

  Future<List<Client>> getAllClients() async {
    StorageViewModel model = new StorageViewModel();
    return await model.getAllClients();
  }

  Future<Client?> loadClient(String clientGuid) async {
    StorageViewModel model = new StorageViewModel();
    return await model.loadClient(clientGuid);
  }

  Future<void> saveClient(String clientGuid, Client client) async {
    StorageViewModel model = new StorageViewModel();
    await model.saveClient(clientGuid, client);
  }

  Future<bool> isClientExists(String clientGuid) async {
    StorageViewModel model = new StorageViewModel();
    return await model.isClientExists(clientGuid);
  }

  Future<void> saveClients(ClientList clients) async {
    StorageViewModel model = new StorageViewModel();
    await model.saveClients(clients);
  }

  Future<Survey> loadSurvey(String surveyGuid) async {
    StorageViewModel model = new StorageViewModel();
    return await model.loadSurvey(surveyGuid);
  }

  Future<void> saveSurvey(String surveyGuid, Survey survey) async {
    StorageViewModel model = new StorageViewModel();
    await model.saveSurvey(surveyGuid, survey);
  }

  Future<bool> isSurveyExists(String surveyGuid) async {
    StorageViewModel model = new StorageViewModel();
    return await model.isSurveyExists(surveyGuid);
  }

  Future<void> saveSurveys(SurveyList surveys) async {
    StorageViewModel model = new StorageViewModel();
    model.saveSurveys(surveys);
  }

  Future<Surveyor> loadSurveyor() async {
    StorageViewModel model = new StorageViewModel();
    return await model.loadSurveyor();
  }

  Future<bool> isSurveyorExists() async {
    StorageViewModel model = new StorageViewModel();
    return model.isSurveyorExists();
  }

  Future<void> saveSurveyor(Surveyor surveyor) async {
    StorageViewModel model = new StorageViewModel();
    await model.saveSurveyor(surveyor);
  }

  Future<void> deleteSurveyor() async {
    StorageViewModel model = new StorageViewModel();
    await model.deleteSurveyor();
  }
  
  void dispose() {
    StorageViewModel model = new StorageViewModel();
    model.dispose();
  }

}
