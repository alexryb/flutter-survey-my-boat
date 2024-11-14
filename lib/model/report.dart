import 'dart:convert';
import 'dart:typed_data';

import 'audit.dart';
import 'resource_type.dart';

class ReportResponse {
  Report? data;

  ReportResponse({this.data});

  ReportResponse.fromJson(Map<String, dynamic> json)
      : data = Report.fromJson(json['data']);
}

class Report extends Audit {

  final String type = ResourceType.Report;
  String? reportGuid;
  String? surveyGuid;
  String? mimeType;
  String? name;
  String? description;
  Uint8List? content;

  Report({
    this.reportGuid,
    this.surveyGuid,
    this.mimeType,
    this.name,
    this.description,
    this.content
  });

  Report.fromJson(Map<String, dynamic> json) {
    reportGuid = json['reportGuid'];
    surveyGuid = json['surveyGuid'];
    description = json['description'];
    name = json['name'];
    mimeType = json['mimeType'];
    content = Base64Decoder().convert(json['content']);
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['reportGuid'] = reportGuid;
    data['surveyGuid'] = surveyGuid;
    data['description'] = description;
    data['name'] = name;
    data['mimeType'] = mimeType;
    data['content'] = Base64Encoder().convert(content!);
    super.toAuditJson(data);
    return data;
  }
}