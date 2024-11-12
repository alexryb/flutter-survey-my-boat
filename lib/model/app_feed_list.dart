import 'app_feed.dart';

class AppFeedListResponse {
  final AppFeedList data;

  AppFeedListResponse({required this.data});

  AppFeedListResponse.fromJson(Map<String, dynamic> json)
      : data = AppFeedList.fromJson(json['data']);
}

class AppFeedList {
  int? pageNumber;
  int? pageRowCount;
  int? totalRowCount;
  int? totalPageCount;
  List<AppFeed>? elements;

  AppFeedList(
      { this.pageNumber,
        this.pageRowCount,
        this.totalRowCount,
        this.totalPageCount,
        this.elements});

  AppFeedList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageRowCount = json['pageRowCount'];
    totalRowCount = json['totalRowCount'];
    totalPageCount = json['totalPageCount'];
    elements = List<AppFeed>.empty(growable: true);
    json['elements'].forEach((v) => elements?.add(new AppFeed.fromJson(v)));
  }
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['pageRowCount'] = pageRowCount;
    data['totalRowCount'] = totalRowCount;
    data['totalPageCount'] = totalPageCount;
    data['elements'] = elements?.map((v) => v.toJson()).toList();
    return data;
  }
}
