import 'audit.dart';
import 'resource_type.dart';

class SurveyorOrganization extends Audit {
  final String type = ResourceType.SurveyorOrganization;
  String organizationGuid;
  String businessNumber;
  String name;
  String addressLine;
  String emailAddress;
  String phoneNumber;

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
    data['@type'] = this.type;
    data['businessNumber'] = this.businessNumber;
    data['name'] = this.name;
    data['addressLine'] = this.addressLine;
    data['emailAddress'] = this.emailAddress;
    data['phoneNumber'] = this.phoneNumber;
    data['surveyorOrganizationGuid'] = this.organizationGuid;
    super.toAuditJson(data);
    return data;
  }
}
