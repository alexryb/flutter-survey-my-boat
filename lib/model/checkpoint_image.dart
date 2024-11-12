import 'dart:convert';
import 'dart:typed_data';

import 'container_image.dart';
import 'resource_type.dart';

class CheckPointImage extends ContainerImage {
  final String type = ResourceType.CheckPointImage;
  String? imageGuid;
  String? checkPointGuid;
  String? surveyGuid;
  String? mimeType;
  String? name;
  String? description;
  Uint8List? content;

  CheckPointImage({
    imageGuid, checkPointGuid, surveyGuid, mimeType, name, description, content});


  CheckPointImage.fromJson(Map<String, dynamic> json) {
    imageGuid = json['imageGuid'];
    checkPointGuid = json['checkPointGuid'];
    surveyGuid = json['surveyGuid'];
    mimeType = json['mimeType'];
    description = json['description'];
    name = json['name'];
    content = Base64Decoder().convert(json['content']);
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['imageGuid'] = imageGuid;
    data['checkPointGuid'] = checkPointGuid;
    data['surveyGuid'] = surveyGuid;
    data['mimeType'] = mimeType;
    data['description'] = description;
    data['name'] = name;
    data['content'] = Base64Encoder().convert(content as List<int>);
    super.toAuditJson(data);
    return data;
  }
}
