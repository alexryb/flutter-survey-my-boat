import 'dart:async';

import 'package:surveymyboatpro/model/sign_up.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class ISignUpService {
  Future<NetworkServiceResponse<SignUpResponse>> signUpSurveyorResponse(SignUp signUp);
  Future<NetworkServiceResponse<SignUpResponse>> signUpUserAccountResponse(SignUp signUp);
}
