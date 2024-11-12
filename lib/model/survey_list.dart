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
    if(this.elements == null) {
      this.elements = List<Survey>.empty(growable: true);
    }
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
    data['pageNumber'] = this.pageNumber;
    data['pageRowCount'] = this.pageRowCount;
    data['totalRowCount'] = this.totalRowCount;
    data['totalPageCount'] = this.totalPageCount;
    if (this.elements != null) {
      data['elements'] = this.elements?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}