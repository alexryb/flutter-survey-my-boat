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
    data['pageNumber'] = this.pageNumber;
    data['pageRowCount'] = this.pageRowCount;
    data['totalRowCount'] = this.totalRowCount;
    data['totalPageCount'] = this.totalPageCount;
    if (this.elements != null) {
      data['elements'] = this.elements?.map((v) => v.toJson()).toList();
    }
    data['codeTableName'] = this.codeTableName;
    data['description'] = this.description;
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
