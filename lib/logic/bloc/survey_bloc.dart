import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/viewmodel/survey_view_model.dart';
import 'package:surveymyboatpro/model/checkpoint.dart';
import 'package:surveymyboatpro/model/checkpoint_condition.dart';
import 'package:surveymyboatpro/model/checkpoint_status.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:rxdart/rxdart.dart';

class SurveyBloc {
  String? searchString;
  List<CheckPoint>? checkPoints;

  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;
  
  final surveysResultController = StreamController<SurveyList>();
  final surveyResultController = StreamController<Survey>();
  final surveyArchiveResultController = StreamController<SurveyStatus>();

  Stream<SurveyList> get surveys => surveysResultController.stream;
  Stream<Survey> get survey => surveyResultController.stream;
  Stream<SurveyStatus> get archived => surveyArchiveResultController.stream;

  Future<void> getSurvey(SurveyViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getSurvey;

    await model.fetchSurvey(model.surveyGuid!);

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveyResultController.add(model.surveyResult!);

  }

  Future<void> saveSurvey(SurveyViewModel model, {required ApiType apiType}) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = apiType;

    await model.saveSurvey();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveyResultController.add(model.surveyResult!);

  }

  Future<void> createSurvey(SurveyViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.createSurvey;

    await model.createSurvey();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveyResultController.add(model.surveyResult!);

  }

  Future<void> getSurveys(SurveyViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getSurveys;
    
    await model.getSurveys();
    
    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveysResultController.add(model.surveyListResult!);
    
  }

  Future<void> archiveSurvey(SurveyViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.archiveSurvey;

    await model.archiveSurvey();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    surveyArchiveResultController.add(model.status!);
    
  }

  void dispose() {
    apiController.close();
    surveyResultController.close();
    surveysResultController.close();
    surveyArchiveResultController.close();
  }

  List<List<CheckPoint>> convertListOfCheckPointsTo2dList(int colCnt,
      List<CheckPoint> checkPoints) {
    int rowCount = 0;
    int columnsCount = 0;
    List<CheckPoint> colList = List<CheckPoint>.empty(growable: true);
    List<List<CheckPoint>> rowList = List<List<CheckPoint>>.empty(growable: true);
    for (CheckPoint checkPoint in checkPoints) {
      if (columnsCount == 0) {
        colList = List<CheckPoint>.empty(growable: true);
      }
      if (columnsCount < colCnt) {
        colList.add(checkPoint);
        columnsCount++;
      } else {
        rowList.add(colList);
        rowCount++;
        colList = List<CheckPoint>.empty(growable: true);
        colList.add(checkPoint);
        columnsCount = 1;
      }
      //print(checkPoint.name);
    }
    if(colList.isNotEmpty) {
      rowList.add(colList);
      rowCount++;
    }
    return rowList;
  }

  Color seaTrailStatusColor(Survey survey) {
    if(survey.seaTrail != null && survey.seaTrail?.status == CheckPointStatus.NotAvailable()) {
      return Colors.grey;
    }
    if(survey.seaTrail != null && survey.seaTrail?.status == CheckPointStatus.Completed()) {
      return Colors.green;
    } else {
      return Colors.blueGrey;
    }
  }

  Color checkPointStatusColor(CheckPoint checkPoint) {
    bool hasChild = checkPoint.children != null && checkPoint.children!.isNotEmpty;
    if(checkPoint.status == CheckPointStatus.NotStarted() && !hasChild) {
      return Colors.blueGrey;
    }
    if(checkPoint.status == CheckPointStatus.UnCompleted() && !hasChild) {
      return Colors.orange;
    }
    if(checkPoint.status == CheckPointStatus.NotAvailable() && !hasChild) {
      return Colors.grey;
    }
    if(checkPoint.status == CheckPointStatus.Completed() && !hasChild) {
      return Colors.green;
    }

    int total = checkPoint.children!.length + 1;
    int isNoStart = checkPoint.status == CheckPointStatus.NotStarted() ? 1 : 0;
    int isUncomp = checkPoint.status == CheckPointStatus.UnCompleted() ? 1 : 0;
    int isComp = checkPoint.status == CheckPointStatus.Completed() ? 1 : 0;
    int isNotAvail = checkPoint.status == CheckPointStatus.NotAvailable() ? 1 : 0;

    for (CheckPoint _child in checkPoint.children!) {
      if(_child.status == CheckPointStatus.NotStarted()) {
        isNoStart ++;
      }
      if(_child.status == CheckPointStatus.UnCompleted()) {
        isUncomp ++;
      }
      if(_child.status == CheckPointStatus.NotAvailable()) {
        isNotAvail ++;
      }
      if(_child.status == CheckPointStatus.Completed()) {
        isComp ++;
      }
    }

    if (total == isNotAvail) {
      return Colors.grey;
    }
    if(total == isNoStart || total == isNoStart + isNotAvail) {
      return Colors.blueGrey;
    }
    if (total > isComp + isNotAvail) {
      return Colors.orange;
    }
    if(total == isComp || total == isComp + isNotAvail ) {
      return Colors.green;
    }

    return Colors.black;
  }

  bool checkSurveyCompleted(List<CheckPoint> checkPoints) {
    int total = checkPoints.length;
    for (CheckPoint checkPoint in checkPoints) {
      //print('${checkPoint.name} status is ${checkPoint.status.code}');
      if ((checkPoint.status == CheckPointStatus.Completed())
          || (checkPoint.status == CheckPointStatus.NotAvailable())) {
        total --;
      }
    }
    return total == 0;
  }

  void setCheckPointStatusRecursive(CheckPoint checkPoint, String conditionCode) {

    if(conditionCode == CheckPointCondition.NotAvailable().code) {
      checkPoint.status = CheckPointStatus.NotAvailable();
    } else {
      checkPoint.status = CheckPointStatus.UnCompleted();
    }

    if(checkPoint.children != null) {
      for (CheckPoint cp in checkPoint.children!) {
        if(checkPoint.condition == CheckPointCondition.New()) {
          cp.condition = checkPoint.condition;
        }
        setCheckPointStatusRecursive(cp, conditionCode);
      }
    }
  }

  void setCheckPointExpressRecursive(CheckPoint checkPoint) {
    if(checkPoint.children != null) {
      for (CheckPoint cp in checkPoint.children!) {
        cp.expressMode = checkPoint.expressMode;
        if(cp.expressMode! && cp.status != CheckPointStatus.Completed()) {
          cp.status = CheckPointStatus.NotAvailable();
        } else if (!cp.expressMode! && cp.status != CheckPointStatus.Completed()) {
          cp.status = CheckPointStatus.NotStarted();
        }
        setCheckPointExpressRecursive(cp);
      }
    }
  }
  
  List<CheckPoint> findCheckPointByName(List<CheckPoint> checkPoints, List<CheckPoint> result, bool wildCard) {
    for (CheckPoint checkPoint in checkPoints) {
      if(wildCard) {
        if (checkPoint.name!.toLowerCase().contains(
            searchString!.toLowerCase())) {
          result.add(checkPoint);
        } else {
          if (checkPoint.children != null) {
            result =
                findCheckPointByName(checkPoint.children!, result, wildCard);
          }
        }
      } else
        if (checkPoint.name!.toLowerCase() == (searchString!.toLowerCase())) {
          result.add(checkPoint);
        } else {
          if(checkPoint.children != null) {
            result = findCheckPointByName(checkPoint.children!, result, wildCard);
          }
        }
    }
    return result;
  }
}
