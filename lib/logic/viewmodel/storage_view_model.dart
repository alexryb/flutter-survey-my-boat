
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/interfaces/i_storage_service.dart';

class StorageViewModel extends BaseViewModel {

  static Map<String, dynamic>? _codes;

  
  Future<void> deleteClients() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.deleteClients();
  }

  
  Future<void> deleteCodes() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.deleteCodes();
  }

  
  Future<void> deleteCredentials() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.deleteCredentials();
  }

  
  Future<void> deleteSettings() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.deleteSettings();
  }

  
  Future<void> deleteSurveyor() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.deleteSurveyor();
  }

  
  Future<void> deleteSurveys() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.deleteSurveys();
  }

  
  void dispose() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.dispose();
  }

  
  Future<List<Client>> getAllClients() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await storageService.getAllClients();
  }

  
  Future<List<Survey>> getAllSurveys() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await  storageService.getAllSurveys();
  }

  
  Future<bool> isClientExists(String clientGuid) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return storageService.isClientExists(clientGuid);
  }

  
  Future<bool> isSurveyExists(String surveyGuid) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return storageService.isSurveyExists(surveyGuid);
  }

  
  Future<bool> isSurveyorExists() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return storageService.isSurveyorExists();
  }

  
  Future<Client?> loadClient(String clientGuid) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await storageService.loadClient(clientGuid);
  }

  
  Future<Map<String, dynamic>?> loadCodes() async {
    if(_codes == null) {
      IStorageService storageService = await new Injector(await flavor) .storageService;
      _codes = await storageService.loadCodes();
    }
    return _codes;
  }

  
  Future<LoginData?> loadCredentials() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await storageService.loadCredentials();
  }

  
  Future<Settings?> loadSettings() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await storageService.loadSettings();
  }

  
  Future<Survey> loadSurvey(String surveyGuid) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await storageService.loadSurvey(surveyGuid);
  }

  
  Future<Surveyor> loadSurveyor() async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    return await storageService.loadSurveyor();
  }

  
  Future<void> saveClient(String clientGuid, Client client) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveClient(clientGuid, client);
  }

  
  Future<void> saveClients(ClientList clients) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveClients(clients);
  }

  
  Future<void> saveCodes(Map<String, CodeList> codes) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveCodes(codes);
  }

  
  Future<void> saveCredentials(LoginData userData) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveCredentials(userData);
  }

  
  Future<void> saveSettings(Settings settings) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveSettings(settings);
  }

  
  Future<void> saveSurvey(String surveyGuid, Survey survey) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveSurvey(surveyGuid, survey);
  }

  
  Future<void> saveSurveyor(Surveyor surveyor) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveSurveyor(surveyor);
  }

  
  Future<void> saveSurveys(SurveyList surveys) async {
    IStorageService storageService = await new Injector(await flavor).storageService;
    storageService.saveSurveys(surveys);
  }

}
