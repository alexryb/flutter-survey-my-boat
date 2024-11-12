import 'payment.dart';

class PaymentListResponse {
  PaymentList? data;

  PaymentListResponse({this.data});

  PaymentListResponse.fromJson(Map<String, dynamic> json)
      : data = PaymentList.fromJson(json['data']);
}

class PaymentList {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<Payment>? elements;

  PaymentList(
      { this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements});

  PaymentList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    if (json['elements'] != null) {
      elements = List<Payment>.empty(growable: true);
      json['elements'].forEach((v) {
        elements?.add(new Payment.fromJson(v));
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
      data['elements'] = this.elements?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
