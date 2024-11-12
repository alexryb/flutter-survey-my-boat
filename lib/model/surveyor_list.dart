import 'surveyor.dart';

class SurveyorListResponse {
  SurveyorList data;

  SurveyorListResponse({this.data});

  SurveyorListResponse.fromJson(Map<String, dynamic> json)
      : data = SurveyorList.fromJson(json['data']);
}

class SurveyorList {
  int pageNumber;
  int pageRowCount;
  int totalRowCount;
  int totalPageCount;
  List<Surveyor> elements;

  SurveyorList(
      {
        this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements}) {
    if (this.elements == null) {
      this.elements = List<Surveyor>.empty(growable: true);
    }
  }

  SurveyorList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<Surveyor>.empty(growable: true);
      json['elements'].forEach((v) {
        elements.add(new Surveyor.fromJson(v));
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
      data['elements'] = this.elements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}