import 'vessel_catalog.dart';

class VesselCatalogListResponse {
  VesselCatalogList data;

  VesselCatalogListResponse({this.data});

  VesselCatalogListResponse.fromJson(Map<String, dynamic> json)
      : data = VesselCatalogList.fromJson(json['data']);
}

class VesselCatalogList {
  int pageNumber;
  int pageRowCount;
  int totalRowCount;
  int totalPageCount;
  List<VesselCatalog> elements;

  VesselCatalogList(
      { this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements}) {
    if (this.elements == null) {
      this.elements = List<VesselCatalog>.empty(growable: true);
    }
  }

  VesselCatalogList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<VesselCatalog>.empty(growable: true);
      json['elements'].forEach((v) {
        elements.add(new VesselCatalog.fromJson(v));
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
