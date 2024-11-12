import 'dart:async';

import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_code_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class CodeService extends NetworkService implements ICodeService {
  static const _codePath = "/codes";

  @override
  Future<NetworkServiceResponse<CodeListResponse>> getCodeListResponse(String code) async {
    SecureRestClient? _restClient = await oauthRestClient;
    var result = await _restClient?.getRequest<CodeList>(restApiBaseUrl.toString(), _codePath + "/" + code);
    if (result?.mappedResult != null) {
      return new NetworkServiceResponse(
        content: CodeListResponse(
            data: CodeList.fromJson(result?.mappedResult)
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }
}
