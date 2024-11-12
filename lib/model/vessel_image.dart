import 'dart:convert';
import 'dart:typed_data';

import 'container_image.dart';
import 'resource_type.dart';

class VesselImage extends ContainerImage {
  final String type = ResourceType.VesselImage;
  String? imageGuid;
  String? vesselGuid;
  String? mimeType;
  String? name;
  String? description;
  Uint8List? content;

  VesselImage({
      this.imageGuid,
      this.vesselGuid,
      this.mimeType,
      this.name,
      this.description,
      this.content
  });

  VesselImage.fromJson(Map<String, dynamic> json) {
    imageGuid = json['imageGuid'];
    vesselGuid = json['vesselGuid'];
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
    data['vesselGuid'] = vesselGuid;
    data['description'] = description;
    data['name'] = name;
    data['mimeType'] = mimeType;
    data['content'] = Base64Encoder().convert(content!);
    super.toAuditJson(data);
    return data;
  }
}
