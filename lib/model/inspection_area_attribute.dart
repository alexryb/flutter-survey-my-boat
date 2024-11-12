import 'resource_type.dart';

import 'audit.dart';

class InspectionAreaAttribute extends Audit {
  final String type = ResourceType.InspectionAreaAttribute;
  String? inspectionAreaAttributeGuid;
  String? code;
  String? description;
  String? defaultValue1;
  String? defaultValue2;
  String? defaultValue3;
  String? defaultValue4;
  String? defaultValue5;

  InspectionAreaAttribute(
      inspectionAreaAttributeGuid,
      code,
      description,
      defaultValue1,
      defaultValue2,
      defaultValue3,
      defaultValue4,
      defaultValue5);

  InspectionAreaAttribute.fromJson(Map<String, dynamic> json) {
    inspectionAreaAttributeGuid = json['inspectionAreaAttributeGuid'];
    code = json['code'];
    description = json['description'];
    defaultValue1 = json['defaultValue1'];
    defaultValue2 = json['defaultValue2'];
    defaultValue3 = json['defaultValue3'];
    defaultValue4 = json['defaultValue4'];
    defaultValue5 = json['defaultValue5'];
    description = json['description'];
    super.fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['inspectionAreaAttributeGuid'] = inspectionAreaAttributeGuid;
    data['code'] = code;
    data['description'] = description;
    data['defaultValue1'] = defaultValue1;
    data['defaultValue2'] = defaultValue2;
    data['defaultValue3'] = defaultValue3;
    data['defaultValue4'] = defaultValue4;
    data['defaultValue5'] = defaultValue5;
    super.toAuditJson(data);
    return data;
  }
}
