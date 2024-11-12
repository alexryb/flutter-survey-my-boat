import 'dart:async';

import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class ILoginService {
  Future<NetworkServiceResponse<LoginResponse>> fetchLoginResponse(Login userLogin);
  Future<NetworkServiceResponse<LoginResponse>> changePasswordResponse(Login userLogin, String newPassword);
  Future<NetworkServiceResponse<LoginResponse>> recoverPasswordResponse(Login login);
}
