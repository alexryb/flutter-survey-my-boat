import 'client.dart';

class ClientListResponse {
  final ClientList data;

  ClientListResponse({required this.data});

  ClientListResponse.fromJson(Map<String, dynamic> json)
      : data = ClientList.fromJson(json['data']);
}

class ClientList {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  late final List<Client> elements;

  ClientList(
      { this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        required this.elements}) {
  }

  ClientList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<Client>.empty(growable: true);
      json['elements'].forEach((v) {
        elements.add(new Client.fromJson(v));
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
