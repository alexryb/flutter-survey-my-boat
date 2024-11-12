import 'checkpoint_condition.dart';
import 'code_list.dart';

class CheckPointConditionList extends CodeListResponse {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<CheckPointCondition>? elements = List.empty(growable: true);

  CheckPointConditionList(
      {this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements});

  CheckPointConditionList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<CheckPointCondition>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new CheckPointCondition.fromJson(v));
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

  static CheckPointCondition getByCode(String code) {
    switch(code) {
      case "NA":
        return CheckPointCondition.NotAvailable();
      case "NEW":
        return CheckPointCondition.New();
      case "SERVICABLE":
        return CheckPointCondition.Servicable();
      case "FAIR":
        return CheckPointCondition.Fair();
      case "REPLACE":
        return CheckPointCondition.Replace();
      default:
        return CheckPointCondition.New();
    }
  }
}
