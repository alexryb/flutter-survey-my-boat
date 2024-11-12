import 'code.dart';

class CodeListResponse {
  CodeList? data;

  CodeListResponse({this.data});

  CodeListResponse.fromJson(Map<String, dynamic> json)
      : data = CodeList.fromJson(json['data']);
}

class CodeMapResponse {
  Map<String, CodeList> data;

  CodeMapResponse({required this.data});

}

class CodeList {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  late final List<Code> elements;
  String? codeTableName;
  String? description;

  CodeList(
      {this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        required this.elements,
        this.codeTableName,
        this.description}) {
    //elements ??= List<Code>.empty(growable: true);
  }

  CodeList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<Code>.empty(growable: true);
      json['elements'].forEach((v) {
        elements.add(new Code.fromJson(v));
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
    data['elements'] = elements.map((v) => v.toJson()).toList();
      data['codeTableName'] = codeTableName;
    data['description'] = description;
    return data;
  }
}
