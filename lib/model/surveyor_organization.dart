import 'audit.dart';
import 'resource_type.dart';

class SurveyorOrganization extends Audit {
  final String type = ResourceType.SurveyorOrganization;
  String? organizationGuid;
  String? businessNumber;
  String? name;
  String? addressLine;
  String? emailAddress;
  String? phoneNumber;

  SurveyorOrganization ({
    this.organizationGuid,
    this.businessNumber,
    this.name,
    this.addressLine,
    this.emailAddress,
    this.phoneNumber
  });

  SurveyorOrganization.fromJson(Map<String, dynamic> json) {
    businessNumber = json['businessNumber'];
    name = json['name'];
    addressLine = json['addressLine'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    organizationGuid = json['surveyorOrganizationGuid'];
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['businessNumber'] = businessNumber;
    data['name'] = name;
    data['addressLine'] = addressLine;
    data['emailAddress'] = emailAddress;
    data['phoneNumber'] = phoneNumber;
    data['surveyorOrganizationGuid'] = organizationGuid;
    super.toAuditJson(data);
    return data;
  }
}
