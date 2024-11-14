import 'survey.dart';

class SurveyListResponse {
  SurveyList? data;

  SurveyListResponse({this.data});

  SurveyListResponse.fromJson(Map<String, dynamic> json)
      : data = SurveyList.fromJson(json['data']);
}

class SurveyList {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<Survey>? elements;

  SurveyList(
      {
        this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements}) {
    elements ??= List<Survey>.empty(growable: true);
  }

  SurveyList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<Survey>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new Survey.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['pageRowCount'] = pageRowCount;
    data['totalRowCount'] = totalRowCount;
    data['totalPageCount'] = totalPageCount;
    if (elements != null) {
      data['elements'] = elements?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}