import 'code_list.dart';
import 'construction_material.dart';

class ConstructionMaterialList extends CodeListResponse {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<ConstructionMaterial>? elements = List.empty(growable: true);
  String? codeTableName;
  String? description;

  ConstructionMaterialList(
      {this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements,
        this.codeTableName,
        this.description});

  ConstructionMaterialList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<ConstructionMaterial>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new ConstructionMaterial.fromJson(v));
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
