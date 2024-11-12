import 'dart:convert';
import 'dart:typed_data';

import 'resource_type.dart';

class AppFeedResponse {
  AppFeed data;

  AppFeedResponse({required this.data});

  AppFeedResponse.fromJson(Map<String, dynamic> json)
      : data = AppFeed.fromJson(json['data']);
}

class AppFeed {
  final String type = ResourceType.AppFeed;
  final String createdBy;
  final String createDate;
  final String updatedBy;
  final String updateDate;
  final String appFeedGuid;
  final String title;
  final String content;
  final Uint8List image;

  AppFeed(
      {
        required this.createdBy,
        required this.createDate,
        required this.updatedBy,
        required this.updateDate,
        required this.appFeedGuid,
        required this.title,
        required this.content,
        required this.image
      });

  AppFeed.fromJson(Map<String, dynamic> json)
    : createdBy = json['createdBy'] as String,
    createDate = json['createDate'] as String,
    updatedBy = json['updatedBy'] as String,
    updateDate = json['updateDate'] as String,
    appFeedGuid = json['appFeedGuid'] as String,
    title = json['title'] as String,
    content = json['content'] as String,
    image = Base64Decoder().convert(json['image']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['createdBy'] = createdBy;
    data['createDate'] = createDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['appFeedGuid'] = appFeedGuid;
    data['title'] = title;
    data['content'] = content;
    data['image'] = Base64Encoder().convert(image);
    return data;
  }

}

