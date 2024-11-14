import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/model/code.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/checkpoint_condition_list.dart';
import 'package:surveymyboatpro/model/checkpoint_fix_priority_list.dart';
import 'package:surveymyboatpro/model/checkpoint_status_list.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/construction_material_list.dart';
import 'package:surveymyboatpro/model/regulation_standard_code_list.dart';
import 'package:surveymyboatpro/model/survey_type_list.dart';
import 'package:surveymyboatpro/model/surveyor_certificate_list.dart';
import 'package:surveymyboatpro/model/vessel_document_type_list.dart';
import 'package:surveymyboatpro/model/vessel_type_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_code_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class LocalCodeService implements ICodeService {
  @override
  Future<NetworkServiceResponse<CodeListResponse>> getCodeListResponse(String code) async {
    //await Future.delayed(Duration(seconds: 2));
    CodeList? result = await _loadLocalCodes(code);
    result ??= await _fetchAssetsCodes(code);
    return new NetworkServiceResponse(
      content: CodeListResponse(
          data: result
      ),
      success: true,
    );
  }
}

StorageBloc _localStorageBloc = new StorageBloc();

Future<String> _loadCodesAsset(String code) async {
  return await rootBundle.loadString('assets/data/' + code + ".json");
}

Future<CodeList?> _loadLocalCodes(String code) async {
  Map<String, dynamic>? mapResult = await _localStorageBloc.loadCodes();
  return mapResult!.isNotEmpty ? CodeList.fromJson(await mapResult[code]) : null;
}

Future<CodeList> _fetchAssetsCodes(String code) async {
  CodeList result = new CodeList(elements: List.empty(growable: true));
  String jsonString = await _loadCodesAsset(code);
  final jsonResponse = json.decode(jsonString);
  switch (code) {
    case "checkPointCondition":
      result.elements.addAll(new CheckPointConditionList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "checkPointFixPriority":
      result.elements.addAll(new CheckPointFixPriorityList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "checkPointStatus":
      result.elements.addAll(new CheckPointStatusList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "constructionMaterial":
      result.elements.addAll(new ConstructionMaterialList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "surveyorCertificate":
      result.elements.addAll(new SurveyorCertificateList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "surveyType":
      result.elements.addAll(new SurveyTypeList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "vesselDocumentType":
      result.elements.addAll(new VesselDocumentTypeList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "vesselType":
      result.elements.addAll(new VesselTypeList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    case "regulationStandards":
      result.elements.addAll(new RegulationStandardsCodeList.fromJson(jsonResponse).elements as Iterable<Code>);
      return result;
    default:
      throw new Exception("Code $code not recognized");
  }
}
