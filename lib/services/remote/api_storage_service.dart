import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/remote_storage.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/interfaces/i_storage_service.dart';
import 'package:surveymyboatpro/utils/string_utils.dart';

const String randomKey = "XmI43Xa3Y0HYLM3s7gE9zBlyc2MVxqjd";

class StorageService implements IStorageService {

  static final Map<String, dynamic> _storages = {};

  static Map<String, dynamic> get storages => _storages;

  Future<String> get _localPath async {
    final directory = Directory("Documents");
    return directory.path;
  }

  Future<File> get _localCredentialsFile async {
    final path = await _localPath;
    //print(path);
    return File('$path/c.json');
  }

  Future<File> get _localSettingsFile async {
    final path = await _localPath;
    //print(path);
    return File('$path/s.json');
  }

  Future<File> get _localSurveyorFile async {
    final path = await _localPath;
    //print(path);
    return File('$path/surveyor.json');
  }

  Future<File> getLocalCodesFile(String code) async {
    final path = await _localPath;
    //print(path);
    return File('$path/codes/' + code + '.json');
  }

  Future<File> getLocalSurveyFile(String surveyGuid) async {
    final path = await _localPath;
    //print(path);
    return File('$path/surveys/' + surveyGuid + '.json');
  }

  Future<File> getLocalClientFile(String clientGuid) async {
    final path = await _localPath;
    //print(path);
    return File('$path/clients/' + clientGuid + '.json');
  }

  Future<File> getDownloadReportFile(String filename) async {
    final path = await _localPath;
    print(path);
    return File('$path/IMB/$filename.pdf');
  }

  Future<File> getTempReportFile(String reportGuid) async {
    final path = await _localPath;
    //print(path);
    return File('$path/reports/' + reportGuid + '.pdf');
  }

  Future<LoginData> loadCredentials() async {
    final file = await _localCredentialsFile;
    var _json = await _readFile(file);
    LoginData d = LoginData();
    if (_json.isNotEmpty) {
      d = LoginData.fromJson(_json);
      d.login?.password = _decrypt(d.login?.password);
    }
    return d;
  }

  void saveCredentials(LoginData userData) async {
    final file = await _localCredentialsFile;
    userData.login?.password = await _encrypt(userData.login?.password);
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

  Future<Settings> loadSettings() async {
    final file = await _localSettingsFile;
    var _json = await _readFile(file);
    Settings s = Settings.local();
    try {
      if (_json.isNotEmpty) {
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
    if (!await codesDir.existsSync()) {
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
      resultMap.add(await _readFile(File(file.path)));
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
      resultMap.add(await _readFile(File(file.path)));
    }
    for(Map<String, dynamic> json in resultMap) {
      result.add(new Client.fromJson(json));
    }
    return result;
  }

  Future<Client> loadClient(String clientGuid) async {
    final file = await getLocalClientFile(clientGuid);
    Map<String, dynamic> _json = await _readFile(file);
    Client c = Client();
    if(_json.isNotEmpty) {
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
    Map<String, dynamic> _json = await _readFile(file);
    Survey s = Survey();
    if(_json.isNotEmpty) {
      s = new Survey.fromJson(_json);
    }
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
    Map<String, dynamic> _json = await _readFile(file);
    Surveyor s = Surveyor();
    s.surveyorGuid = "";
    if(_json.isNotEmpty) {
      s = Surveyor.fromJson(_json);
    }
    return s;
  }

  Future<bool> isSurveyorExists() async {
    return Future.value((await loadSurveyor()).surveyorGuid?.isNotEmpty);
  }

  void saveSurveyor(Surveyor surveyor) async {
    final file = await _localSurveyorFile;
    _writeFile(file, surveyor.toJson());
  }

  void deleteSurveyor() async {
    final file = await _localSurveyorFile;
    _deleteFile(file);
  }

  void deleteTempReport(String reportGuid) async {
    File file = await getTempReportFile(reportGuid);
    _deleteFile(file);
  }

  void _writeFile(final file, Map<String, dynamic> object) async {
    File f = await file;
    try {
      final jsonString = await convert.JsonEncoder().convert(object);
      RemoteStorage storage = RemoteStorage(
        busketName: f.path,
        remoteStoragePath: f.path,
        content: StringUtils.stringToBytes(jsonString),
      );
      _storages.putIfAbsent(storage.busketName!, () => storage);
    } catch(e) {
      throw Exception("Unable to save file ${f.path}: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> _readFile(final file) async {
    File f = await file;
    try {
      RemoteStorage storage = _storages[f.path];
      if(storage != null) {
        String objectString = StringUtils.bytesToString(storage.content!);
        return convert.JsonDecoder().convert(objectString);
      }
    } catch (e) {
       print("Unable to read file ${f.path}: ${e.toString()}");
    }
    return <String, dynamic>{};
  }

  void _deleteFile(final file) async {
    File f = await file;
    try {
      RemoteStorage storage = _storages[f.path];
      if(storage != null) {
        _storages.remove(f.path);
      }
    } catch (e) {
      print("Unable to remove file ${f.path}: ${e.toString()}");
    }
  }

  void _deleteTempReports() async {
    final path = await _localPath;
    Directory _reportsDir = Directory('$path/reports');
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




