import 'dart:async';

import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class ICodeService {
  Future<NetworkServiceResponse<CodeListResponse>> getCodeListResponse(String code);
}
