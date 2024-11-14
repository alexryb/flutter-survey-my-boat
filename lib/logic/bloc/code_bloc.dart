import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/viewmodel/code_view_model.dart';
import 'package:surveymyboatpro/model/code.dart';
import 'package:surveymyboatpro/model/code_list.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey_type.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:rxdart/rxdart.dart';

class CodeBloc {
  CodeViewModel codeViewModel = new CodeViewModel();

  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;

  final dropdownCodeController = StreamController<Map<String, List<DropdownMenuItem<String>>>>();
  final checkboxCodeController = StreamController<Map<String, List<Code>>>();

  Stream<Map<String, List<DropdownMenuItem<String>>>> get dropdownCodes => dropdownCodeController.stream;
  Stream<Map<String, List<Code>>> get checkboxCodes => checkboxCodeController.stream;

  Future<void> loadDropdownCodes() async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getCodes;

    await codeViewModel.loadCodes();
    Map<String, List<DropdownMenuItem<String>>> menuItems =
        <String, List<DropdownMenuItem<String>>>{};
    menuItems.putIfAbsent(
        "checkPointCondition", () => _getCheckPointConditionDropdownItems());
    menuItems.putIfAbsent("checkPointFixPriority",
        () => _getCheckPointFixPriorityDropdownItems());
    menuItems.putIfAbsent(
        "checkPointStatus", () => _getCheckPointStatusDropdownItems());
    menuItems.putIfAbsent(
        "constructionMaterial", () => _getConstructionMaterialDropdownItems());
    menuItems.putIfAbsent(
        "surveyorCertificate", () => _getSurveyorCertificateDropdownItems());
    menuItems.putIfAbsent(
        "vesselDocumentType", () => _getVesselDocumentTypeDropdownItems());
    menuItems.putIfAbsent("surveyType", () => _getSurveyTypeDropdownItems());
    menuItems.putIfAbsent("vesselType", () => _getVesselTypeDropdownItems());
    menuItems.putIfAbsent("regulationStandards", () => _getRegulationStandardsDropdownItems());

    process.loading = false;
    Map<String, CodeList> codeMap = {};
    codeViewModel.codes?.forEach((key, value) {
      codeMap.putIfAbsent(key, () => CodeList(elements: codeViewModel.codes![key]!));
    });
    process.response = new NetworkServiceResponse(
      content: CodeMapResponse(
          data: codeMap,
      ),
      success: true,
    );
    //for error dialog
    apiController.add(process);
    dropdownCodeController.add(menuItems);
  }

  Future<void> loadCheckboxCodes() async {
    await codeViewModel.loadCodes();
    Map<String, List<Code>> menuItems = <String, List<Code>>{};
    menuItems.putIfAbsent(
        "surveyorCertificate", () => _getSurveyorCertificateCodes());
    checkboxCodeController.add(menuItems);
  }

  DropdownMenuItem<String> getSelectedDropdownMenuItem(
      List<DropdownMenuItem<String>> menuItems, Code code) {
    DropdownMenuItem<String>? result;
    for (DropdownMenuItem<String> item in menuItems) {
      if (code.code == item.value) {
        result = item;
        break;
      }
    }
      return result ?? DropdownMenuItem<String>(
      value: SurveyType.PreOwner().code,
      child: Text(SurveyType.PreOwner().description!),
    );
  }

  List<DropdownMenuItem<String>> _getCheckPointConditionDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["checkPointCondition"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getCheckPointFixPriorityDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["checkPointFixPriority"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getCheckPointStatusDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["checkPointStatus"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getConstructionMaterialDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["constructionMaterial"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getSurveyorCertificateDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["surveyorCertificate"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<Code> _getSurveyorCertificateCodes() {
    return codeViewModel.codes!["surveyorCertificate"]!;
  }

  List<DropdownMenuItem<String>> _getVesselDocumentTypeDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["vesselDocumentType"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getSurveyTypeDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["surveyType"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getVesselTypeDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["vesselType"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  List<DropdownMenuItem<String>> _getRegulationStandardsDropdownItems() {
    List<DropdownMenuItem<String>> result = List<DropdownMenuItem<String>>.empty(growable: true);
    for (Code c in codeViewModel.codes!["regulationStandards"]!) {
      result.add(
        new DropdownMenuItem<String>(
          value: c.code,
          child: Text(c.description!),
        ),
      );
    }
    return result;
  }

  void dispose() {
    apiController.close();
    checkboxCodeController.close();
    dropdownCodeController.close();
  }
}
