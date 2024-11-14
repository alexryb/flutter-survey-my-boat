import 'checkpoint_fix_priority.dart';
import 'code_list.dart';

class CheckPointFixPriorityList extends CodeListResponse {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<CheckPointFixPriority>? elements = List.empty(growable: true);
  String? codeTableName;
  String? description;

  CheckPointFixPriorityList(
      {this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements,
        this.codeTableName,
        this.description});

  CheckPointFixPriorityList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<CheckPointFixPriority>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new CheckPointFixPriority.fromJson(v));
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

  static CheckPointFixPriority getByCode(String code) {
    switch (code) {
      case "CRITICAL":
        return CheckPointFixPriority.Critical();
      case "MAJOR":
        return CheckPointFixPriority.Major();
      case "MINOR":
        return CheckPointFixPriority.Minor();
      case "NAN":
        return CheckPointFixPriority.NoIssue();
      default:
        return CheckPointFixPriority();
    }
  }
}
