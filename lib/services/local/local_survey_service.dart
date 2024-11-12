import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/survey_search_filter.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/services/interfaces/i_survey_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/utils/string_utils.dart';

class LocalSurveyService implements ISurveyService {
  @override
  Future<NetworkServiceResponse<SurveyResponse>> fetchSurveyResponse(String surveyGuid) async {
    //await Future.delayed(Duration(seconds: 2));
    Survey survey = await _fetchSurvey(surveyGuid);
    return new NetworkServiceResponse(
      content: new SurveyResponse(data: survey),
      success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<SurveyListResponse>> findSurveyResponse(SurveySearchFilter filter) async {
    SurveyList surveys = await _getAll();
    return new NetworkServiceResponse(
      content: new SurveyListResponse(data: surveys),
      success: true,
    );
  }

  @override
  Future<NetworkServiceResponse<SurveyResponse>> saveSurveyResponse(Survey survey) async {
    _saveSurvey(survey);
    return new NetworkServiceResponse(
      content: new SurveyResponse(data: survey),
      success: true,
      validate: false,
    );
  }

  @override
  Future<NetworkServiceResponse<SurveyResponse>> createSurveyResponse(Survey survey, {bool clone = false}) async {
    Survey _result;
    if(clone) {
      _result = survey;
      _result.surveyNumber = "Clone ${survey.surveyNumber}";
    } else {
      _result = await _loadAssetSurvey();
      _result.vessel = survey.vessel;
    }
    _result.surveyGuid = StringUtils.generateGuid();
    _result.title = "New Survey";
    return new NetworkServiceResponse(
      content: new SurveyResponse(data: _result),
      success: true,
      validate: false,
    );
  }

  @override
  Future<NetworkServiceResponse<SurveyResponse>> archiveSurveyResponse(String surveyGuid) async {
    //await Future.delayed(Duration(seconds: 2));
    Survey survey = await _fetchSurvey(surveyGuid);
    if(survey != null) {
      survey.surveyStatus == SurveyStatus.Paid() ? SurveyStatus.Completed() : SurveyStatus.Archived();
      _saveSurvey(survey);
      return new NetworkServiceResponse(
        content: new SurveyResponse(status: survey.surveyStatus),
        success: true,
      );
    }
    return new NetworkServiceResponse(
      success: false,
      message: "The survey not exists in local storage. Please load the survey from remote server before archiving it"
    );
  }
}

StorageBloc _localStorageBloc = new StorageBloc();

Future<String> _loadSurveyAsset() async {
  return await rootBundle.loadString('assets/data/survey.json');
}

Future<SurveyList> _getAll() async {
  List<Survey> surveys = await _localStorageBloc.getAllSurveys();
  // if(surveys.isEmpty) {
  //   surveys.add(await _loadAssetSurvey());
  // }
  return new SurveyList(elements: surveys);
}

Future<Survey> _fetchSurvey(String surveyGuid) async {
  return await _localStorageBloc.loadSurvey(surveyGuid);
}

void _saveSurvey(Survey survey) async {
  survey.inSync = false;
  _localStorageBloc.saveSurvey(survey.surveyGuid!, survey);
}

Future<Survey> _loadAssetSurvey() async {
  String jsonString = await _loadSurveyAsset();
  final jsonResponse = json.decode(jsonString);
  return new Survey.fromJson(jsonResponse);
}

