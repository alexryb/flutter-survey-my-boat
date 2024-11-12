import 'resource_type.dart';

import 'audit.dart';
import 'inspection_area_attribute.dart';

class CheckPointAttributeValue extends Audit {
  final String type = ResourceType.CheckPointAttributeValue;
  String? surveyGuid;
  String? checkPointGuid;
  String? checkPointAttributeValueGuid;
  InspectionAreaAttribute? inspectAreaAttribute;
  int? reportOrder;
  String? value;

  CheckPointAttributeValue(
      {this.checkPointAttributeValueGuid,
      this.inspectAreaAttribute,
      this.reportOrder,
      this.value});

  CheckPointAttributeValue.fromJson(Map<String, dynamic> json) {
    surveyGuid = json['surveyGuid'];
    checkPointGuid = json['checkPointGuid'];
    checkPointAttributeValueGuid = json['checkPointAttributeValueGuid'];
    inspectAreaAttribute = json['inspectAreaAttribute'] != null
        ? new InspectionAreaAttribute.fromJson(json['inspectAreaAttribute'])
        : null;
    reportOrder = json['reportOrder'];
    value = json['value'];
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['surveyGuid'] = surveyGuid;
    data['checkPointGuid'] = checkPointGuid;
    data['checkPointAttributeValueGuid'] = checkPointAttributeValueGuid;
    if (inspectAreaAttribute != null) {
      data['inspectAreaAttribute'] = inspectAreaAttribute?.toJson();
    }
    data['reportOrder'] = reportOrder;
    data['value'] = value;
    data['createdBy'] = createdBy;
    data['createDate'] = createDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    super.toAuditJson(data);
    return data;
  }
}
