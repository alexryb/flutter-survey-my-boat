import 'resource_type.dart';

class Login {
  String? username;
  var password;

  Login({this.username, this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  Login.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }
}

class OauthUserResource {
  final String type = ResourceType.OauthUser;
  int? id;
  String? username;
  String? password;
  bool? accountExpired = false;
  bool? accountLocked = false;
  bool? credentialsExpired = false;
  bool? enabled = true;
  String? userGuid;

  OauthUserResource({required this.username, this.password});

  OauthUserResource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    accountExpired = json['accountExpired'];
    accountLocked = json['accountLocked'];
    credentialsExpired = json['credentialsExpired'];
    enabled = json['enabled'];
    userGuid = json['userGuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['accountExpired'] = accountExpired;
    data['accountLocked'] = accountLocked;
    data['credentialsExpired'] = credentialsExpired;
    data['enabled'] = enabled;
    data['userGuid'] = userGuid;
    return data;
  }

}

class LoginResponse {
  LoginData? data;

  LoginResponse({this.data});

  LoginResponse.fromJson(Map<String, dynamic> json)
      : data = LoginData.fromJson(json['data']);
}

class LoginData {
  Login? login;
  String? authToken;
  String? surveyorGuid;

  LoginData();
  LoginData.login(this.login);

  LoginData.fromJson(Map<String, dynamic> json) {
    authToken = json['authToken'];
    if(json['surveyorGuid'] != null) {
      surveyorGuid = json['surveyorGuid'];
    }
    if(json['userGuid'] != null) {
      surveyorGuid = json['userGuid'];
    }
    if(json['login'] != null) {
      login = Login.fromJson(json['login']);
    } else {
      login = new Login();
      if(json['username'] != null) {
        login?.username = json['username'];
      }
      if(json['password'] != null) {
        login?.password = json['password'];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['authToken'] = authToken;
    if (login != null) {
      data['login'] = login?.toJson();
    }
    if (surveyorGuid != null) {
      data['surveyorGuid'] = surveyorGuid;
    }
    return data;
  }
}
