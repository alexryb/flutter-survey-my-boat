import 'dart:convert';
import 'dart:typed_data';

import 'container_image.dart';
import 'resource_type.dart';

class SurveyorImage extends ContainerImage {
  final String type = ResourceType.SurveyorImage;
  String? imageGuid;
  String? surveyorGuid;
  String? mimeType;
  String? name;
  String? description;
  Uint8List? content;

  SurveyorImage({
      this.imageGuid,
      this.surveyorGuid,
      this.mimeType,
      this.name,
      this.description,
      this.content
  });

  SurveyorImage.fromJson(Map<String, dynamic> json) {
    imageGuid = json['imageGuid'];
    surveyorGuid = json['surveyorGuid'];
    description = json['description'];
    name = json['name'];
    mimeType = json['mimeType'];
    content = Base64Decoder().convert(json['content']);
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['imageGuid'] = imageGuid;
    data['surveyorGuid'] = surveyorGuid;
    data['description'] = description;
    data['name'] = name;
    data['mimeType'] = mimeType;
    data['content'] = Base64Encoder().convert(content!);
    super.toAuditJson(data);
    return data;
  }
}
