import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/interfaces/i_storage_service.dart';
import 'package:path_provider/path_provider.dart';

const String randomKey = "XmI43Xa3Y0HYLM3s7gE9zBlyc2MVxqjd";

class LocalStorageService implements IStorageService {

  Future<String> get _localTempPath async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/reports';
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localCredentialsFile async {
    final path = await _localPath;
    //print(path);
    return File('$path/c.imb');
  }

  Future<File> get _localSettingsFile async {
    final path = await _localPath;
    //print(path);
    return File('$path/s.imb');
  }

  Future<File> get _localSurveyorFile async {
    final path = await _localPath;
    //print(path);
    return File('$path/surveyor.imb');
  }

  Future<File> getLocalCodesFile(String code) async {
    final path = await _localPath;
    //print(path);
    return File('$path/codes/' + code + '.imb');
  }

  Future<File> getLocalSurveyFile(String surveyGuid) async {
    final path = await _localPath;
    //print(path);
    return File('$path/surveys/' + surveyGuid + '.imb');
  }

  Future<File> getLocalClientFile(String clientGuid) async {
    final path = await _localPath;
    //print(path);
    return File('$path/clients/' + clientGuid + '.imb');
  }

  Future<File> getTempReportFile(String reportGuid) async {
    final path = await _localTempPath;
    //print(path);
    return File('$path/' + reportGuid + '.pdf');
  }

  Future<LoginData?> loadCredentials() async {
    final file = await _localCredentialsFile;
    var _json = await _readFile(file);
    LoginData d = LoginData();
    if (_json != null) {
      d = LoginData.fromJson(_json);
      d.login!.password = _decrypt(d.login!.password);
    }
    return d;
  }

  void saveCredentials(LoginData userData) async {
    final file = await _localCredentialsFile;
    userData.login!.password = await _encrypt(userData.login!.password);
    _writeFile(file, userData.toJson());
  }

  void deleteCredentials() async {
    final path = await _localPath;
    Directory _settingsDir = Directory('$path/credentials');
    if (_settingsDir.existsSync()) {
      List<FileSystemEntity> files = _settingsDir.listSync();
      for (FileSystemEntity file in files) {
        _deleteFile(File(file.path));
      }
    }
  }

  Future<Settings?> loadSettings() async {
    final file = await _localSettingsFile;
    var _json = await _readFile(file);
    Settings s = Settings.local();
    try {
      if (_json != null) {
        s = Settings.fromJson(_json);
        //s.hostname = _decrypt(s.hostname);
        //s.apiBaseUrl = _decrypt(s.apiBaseUrl);
        //s.oauthBaseUrl = _decrypt(s.oauthBaseUrl);
      }
    } catch (_) {
      print(_);
    }
    return s;
  }

  void saveSettings(Settings settings) async {
    final file = await _localSettingsFile;

    //settings.hostname = _encrypt(settings.hostname);
    //settings.apiBaseUrl = _encrypt(settings.apiBaseUrl);
    //settings.oauthBaseUrl = _encrypt(settings.oauthBaseUrl);

    _writeFile(file, settings.toJson());
  }

  void deleteSettings() async {
    final path = await _localPath;
    Directory _settingsDir = Directory('$path/settings');
    if (await _settingsDir.existsSync()) {
      List<FileSystemEntity> files = _settingsDir.listSync();
      for (FileSystemEntity file in files) {
        _deleteFile(File(file.path));
      }
    }
  }

  Future<Map<String, dynamic>> loadCodes() async {
    final path = await _localPath;
    Directory codesDir = Directory('$path/codes');
    if (!codesDir.existsSync()) {
      codesDir.createSync();
    }
    List<FileSystemEntity> files = codesDir.listSync();
    Map<String, dynamic> resultMap = new Map();
    for (FileSystemEntity file in files) {
      String path = file.path;
      int lastSlashInd = path.lastIndexOf("/") + 1;
      int dotInd = path.lastIndexOf(".");
      String key = path.substring(lastSlashInd, dotInd);
      resultMap.putIfAbsent(key, () => _readFile(File(file.path)));
    }
    return resultMap;
  }

  void saveCodes(Map<String, CodeList> codes) async {
    codes.forEach((key, value) {
      final file = getLocalCodesFile(key);
      _writeFile(file, value.toJson());
    });
  }

  void deleteCodes() async {
    final path = await _localPath;
    Directory _codesDir = Directory('$path/codes');
    if (await _codesDir.existsSync()) {
      List<FileSystemEntity> files = await _codesDir.listSync();
      for (FileSystemEntity file in files) {
        _deleteFile(File(file.path));
      }
    }
  }

  void deleteSurveys() async {
    final path = await _localPath;
    Directory surveysDir = Directory('$path/surveys');
    if (await surveysDir.existsSync()) {
      List<FileSystemEntity> files = await surveysDir.listSync();
      for (FileSystemEntity file in files) {
        _deleteFile(File(file.path));
      }
    }
  }

  void deleteClients() async {
    final path = await _localPath;
    Directory clientsDir = Directory('$path/clients');
    if (await clientsDir.existsSync()) {
      List<FileSystemEntity> files = clientsDir.listSync();
      for (FileSystemEntity file in files) {
        _deleteFile(File(file.path));
      }
    }
  }

  Future<List<Survey>> getAllSurveys() async {
    List<Survey> result = List.empty(growable: true);
    final path = await _localPath;
    Directory surveysDir = Directory('$path/surveys');
    if (!await surveysDir.existsSync()) {
      surveysDir.createSync();
    }
    List<FileSystemEntity> files = await surveysDir.listSync();
    List<Map<String, dynamic>> resultMap = List.empty(growable: true);
    for (FileSystemEntity file in files) {
      resultMap.add(_readFile(File(file.path)) as Map<String, dynamic>);
    }
    for(Map<String, dynamic> json in resultMap) {
      result.add(new Survey.fromJson(json));
    }
    return result;
  }

  Future<List<Client>> getAllClients() async {
    List<Client> result = List.empty(growable: true);
    final path = await _localPath;
    Directory clientsDir = Directory('$path/clients');
    if (!await clientsDir.existsSync()) {
      clientsDir.createSync();
    }
    List<FileSystemEntity> files = await clientsDir.listSync();
    List<Map<String, dynamic>> resultMap = List.empty(growable: true);
    for (FileSystemEntity file in files) {
      resultMap.add(_readFile(File(file.path)) as Map<String, dynamic>);
    }
    for(Map<String, dynamic> json in resultMap) {
      result.add(new Client.fromJson(json));
    }
    return result;
  }

  Future<Client?> loadClient(String clientGuid) async {
    final file = await getLocalClientFile(clientGuid);
    Map<String, dynamic>? _json = _readFile(file) as Map<String, dynamic>?;
    Client c = Client();
    if(_json != null) {
      c = new Client.fromJson(_json);
    }
    return c;
  }

  void saveClient(String clientGuid, Client client) async {
    final file = await getLocalClientFile(clientGuid);
    _writeFile(file, client.toJson());
  }

  Future<bool> isClientExists(String clientGuid) async {
    final file = await getLocalClientFile(clientGuid);
    return await file.exists();
  }

  void saveClients(ClientList clients) async {
    for (Client client in clients.elements) {
      saveClient(client.clientGuid!, client);
    }
  }

  Future<Survey> loadSurvey(String surveyGuid) async {
    final file = await getLocalSurveyFile(surveyGuid);
    Map<String, dynamic>? _json = _readFile(file) as Map<String, dynamic>?;
    Survey s = new Survey.fromJson(_json!);
    return s;
  }

  void saveSurvey(String surveyGuid, Survey survey) async {
    final file = await getLocalSurveyFile(surveyGuid);
    _writeFile(file, survey.toJson());
  }

  Future<bool> isSurveyExists(String surveyGuid) async {
    final file = await getLocalSurveyFile(surveyGuid);
    return await file.exists();
  }

  void saveSurveys(SurveyList surveys) async {
    for (Survey survey in surveys.elements!) {
      saveSurvey(survey.surveyGuid!, survey);
    }
  }

  Future<Surveyor> loadSurveyor() async {
    final file = await _localSurveyorFile;
    Map<String, dynamic> _json = _readFile(file) as Map<String, dynamic>;
    return Surveyor.fromJson(_json);
  }

  Future<bool> isSurveyorExists() async {
    final file = await _localSurveyorFile;
    return await file.exists();
  }

  void saveSurveyor(Surveyor surveyor) async {
    final file = await _localSurveyorFile;
    _writeFile(file, surveyor.toJson());
  }

  void deleteSurveyor() async {
    final file = await _localSurveyorFile;
    _deleteFile(file);
  }

  void _writeFile(final file, Map<String, dynamic> object) async {
    File f = await file;
    try {
      if (!await f.parent.exists()) await f.parent.create(recursive: true);
      final jsonString = await convert.JsonEncoder().convert(object);
      await f.writeAsString(jsonString);
    } catch(e) {
      throw Exception("Unable to save file ${f.path}: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>?> _readFile(final file) async {
    File f = await file;
    if (await f.exists()) {
      try {
        final objectString = await f.readAsString();
        return convert.JsonDecoder().convert(objectString);
      } catch (e) {
        print("Unable to read file ${f.path}: ${e.toString()}");
      }
    }
    return null;
  }

  void _deleteFile(final file) async {
    File f = await file;
    await f.delete();
    print('File ${f.path} deleted');
  }

  void _deleteTempReports() async {
    final path = await _localTempPath;
    Directory _reportsDir = Directory('$path');
    if (await _reportsDir.exists()) {
      List<FileSystemEntity> files = _reportsDir.listSync(recursive: true);
      for (FileSystemEntity file in files) {
        _deleteFile(File(file.path));
      }
    }
  }

  String _encrypt(String value) {
    final key = encrypt.Key.fromUtf8(randomKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return convert.base64.encode(encrypter.encrypt(value, iv: iv).bytes);
  }

  String _decrypt(String value) {
    final key = encrypt.Key.fromUtf8(randomKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(value), iv: iv);
  }

  void dispose() {
    _deleteTempReports();
  }
}
