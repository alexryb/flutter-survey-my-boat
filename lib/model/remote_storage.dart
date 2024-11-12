import 'dart:convert';
import 'dart:typed_data';

import 'resource_type.dart';

import 'audit.dart';

class RemoteStorage extends Audit {

  final String type = ResourceType.RemoteStorage;
  String? createdBy;
  String? updatedBy;
  String? remoteStorageGuid;
  String? busketName;
  String? remoteStoragePath;
  Uint8List? content;

  RemoteStorage({
    this.remoteStorageGuid,
    this.busketName,
    this.remoteStoragePath,
    this.content,
  });

  RemoteStorage.fromJson(Map<String, dynamic> json) {
    remoteStorageGuid = json["remoteStorageGuid"];
    busketName = json["busketName"];
    remoteStoragePath = json["remoteStoragePath"];
    content = Base64Decoder().convert(json['content']);
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['remoteStorageGuid'] = this.remoteStorageGuid;
    data['busketName'] = this.busketName;
    data['remoteStoragePath'] = this.remoteStoragePath;
    data['content'] = Base64Encoder().convert(this.content!);
    super.toAuditJson(data);
    return data;
  }
}
