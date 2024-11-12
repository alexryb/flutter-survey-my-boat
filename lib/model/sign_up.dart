import 'login.dart';
import 'surveyor.dart';

class SignUp {
  String? username;
  String? password;
  Surveyor? surveyor;

  SignUp({this.username, this.password, this.surveyor});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class SignUpResponse {
  LoginData? data;
  OauthUserResource? user;

  SignUpResponse({this.data, this.user});

  SignUpResponse.fromJson(Map<String, dynamic> json)
      : data = LoginData.fromJson(json['data']);
}
