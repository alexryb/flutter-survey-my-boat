import 'code_list.dart';
import 'surveyor_certificate.dart';

class SurveyorCertificateList extends CodeListResponse {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<SurveyorCertificate>? elements = List<SurveyorCertificate>.empty(growable: true);
  String? codeTableName;
  String? description;

  SurveyorCertificateList(
      {this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements,
        this.codeTableName,
        this.description});

  SurveyorCertificateList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<SurveyorCertificate>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new SurveyorCertificate.fromJson(v));
      });
    }
    codeTableName = json['codeTableName'];
    description = json['description'];
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
    data['codeTableName'] = codeTableName;
    data['description'] = description;
    return data;
  }
}

