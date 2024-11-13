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
    this._imageGuid = imageGuid;
    this._mimeType = mimeType;
    this._name = name;
    this._description = description;
    this._content = content;
  }

  Uint8List? getContent() => _content;

  String? getDescription() => _description;

  String? getName() => _name;

  String? getMimeType() => _mimeType;

  String? getImageGuid() => _imageGuid;

}
