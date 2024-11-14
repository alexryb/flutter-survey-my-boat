import 'dart:async';

import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/surveyor.dart';

const String randomKey = "XmI43Xa3Y0HYLM3s7gE9zBlyc2MVxqjd";

abstract class IStorageService {

  Future<LoginData?> loadCredentials();
  void saveCredentials(LoginData userData);
  void deleteCredentials();

  Future<Settings?> loadSettings();
  void saveSettings(Settings settings);
  void deleteSettings();

  Future<Map<String, dynamic>> loadCodes();
  void saveCodes(Map<String, CodeList> codes);
  void deleteCodes();

  Future<List<Client>> getAllClients();
  Future<Client?> loadClient(String clientGuid);
  void saveClient(String clientGuid, Client client);
  Future<bool> isClientExists(String clientGuid);
  void saveClients(ClientList clients);
  void deleteClients();

  Future<List<Survey>> getAllSurveys();
  Future<Survey> loadSurvey(String surveyGuid);
  void saveSurvey(String surveyGuid, Survey survey) ;
  Future<bool> isSurveyExists(String surveyGuid);
  void saveSurveys(SurveyList surveys);
  void deleteSurveys();

  Future<Surveyor> loadSurveyor();
  Future<bool> isSurveyorExists();
  void saveSurveyor(Surveyor surveyor);
  void deleteSurveyor();

  void dispose();
}
