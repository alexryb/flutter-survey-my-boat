import 'dart:convert';
import 'dart:typed_data';

import 'container_image.dart';
import 'resource_type.dart';

class VesselImage extends ContainerImage {
  final String type = ResourceType.VesselImage;
  String imageGuid;
  String vesselGuid;
  String mimeType;
  String name;
  String description;
  Uint8List content;

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
    data['@type'] = this.type;
    data['imageGuid'] = this.imageGuid;
    data['vesselGuid'] = this.vesselGuid;
    data['description'] = this.description;
    data['name'] = this.name;
    data['mimeType'] = this.mimeType;
    data['content'] = Base64Encoder().convert(this.content);
    super.toAuditJson(data);
    return data;
  }
}
