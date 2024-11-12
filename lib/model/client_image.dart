import 'dart:convert';
import 'dart:typed_data';

import 'container_image.dart';
import 'resource_type.dart';

class ClientImage extends ContainerImage {
  final String type = ResourceType.ClientImage;
  String? imageGuid;
  String? clientGuid;
  String? mimeType;
  String? name;
  String? description;
  Uint8List? content;

  ClientImage({
      this.imageGuid,
      this.clientGuid,
      this.mimeType,
      this.name,
      this.description,
      required this.content
  });

  ClientImage.fromJson(Map<String, dynamic> json) {
    imageGuid = json['imageGuid'];
    clientGuid = json['clientGuid'];
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
    data['clientGuid'] = clientGuid;
    data['description'] = description;
    data['name'] = name;
    data['mimeType'] = mimeType;
    data['content'] = Base64Encoder().convert(content!);
    super.toAuditJson(data);
    return data;
  }
}
