import 'checkpoint_status.dart';
import 'code_list.dart';

class CheckPointStatusList extends CodeListResponse {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<CheckPointStatus>? elements = List.empty(growable: true);
  String? codeTableName;
  String? description;

  CheckPointStatusList(
      {this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements,
        this.codeTableName,
        this.description});

  CheckPointStatusList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<CheckPointStatus>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new CheckPointStatus.fromJson(v));
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

  static CheckPointStatus getByCode(String code) {
    switch (code) {
      case "NOTSTRT":
        return CheckPointStatus.NotStarted();
      case "UNCOMP":
        return CheckPointStatus.UnCompleted();
      case "COMP":
        return CheckPointStatus.Completed();
      case "NA":
        return CheckPointStatus.NotAvailable();
      default:
        return CheckPointStatus();
    }
  }
}
