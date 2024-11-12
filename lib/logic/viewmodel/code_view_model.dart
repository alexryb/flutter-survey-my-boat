import 'package:flutter/foundation.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/code.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_code_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class CodeViewModel extends BaseViewModel {

  static final Map<String, List<Code>> _codes = {};
  Map<String, List<Code>>? get codes => _codes;

  CodeViewModel() ;

  Future<void> loadCodes() async {
    if(_codes.isEmpty) {
      await _getCodes("checkPointCondition");
      await _getCodes("checkPointFixPriority");
      await _getCodes("checkPointStatus");
      await _getCodes("constructionMaterial");
      await _getCodes("surveyorCertificate");
      await _getCodes("surveyType");
      await _getCodes("vesselDocumentType");
      await _getCodes("vesselType");
      await _getCodes("regulationStandards");
    }
  }

  Future<Null> _getCodes(String codeTableName) async {
    List<Code>? result = _codes[codeTableName];
    if(result == null) {
      ICodeService codeService = await new Injector(kIsWeb ? Flavor.REMOTE : Flavor.LOCAL).codeService;
      NetworkServiceResponse<CodeListResponse> result = await codeService.getCodeListResponse(codeTableName);
      List<Code> elements = List.from(result.content!.data?.elements as Iterable);
      _codes.putIfAbsent(codeTableName, () => result.content != null ? elements : List.empty(growable: true));
      if (kDebugMode) {
        print('$codeTableName codes loaded');
      }
    }
  }
}
