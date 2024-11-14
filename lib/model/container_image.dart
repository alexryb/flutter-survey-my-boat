import 'dart:typed_data';

import 'audit.dart';

class ContainerImage extends Audit {
  String? _imageGuid;
  String? _mimeType;
  String? _name;
  String? _description;
  Uint8List? _content;

  ContainerImage();

  ContainerImage.Named(
      String imageGuid,
      String? name,
      String? description,
      String mimeType,
      Uint8List content
  ) {
    _imageGuid = imageGuid;
    _mimeType = mimeType;
    _name = name;
    _description = description;
    _content = content;
  }

  Uint8List? getContent() => _content;

  String? getDescription() => _description;

  String? getName() => _name;

  String? getMimeType() => _mimeType;

  String? getImageGuid() => _imageGuid;

}
