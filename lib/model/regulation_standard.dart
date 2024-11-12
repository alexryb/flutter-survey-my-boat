import 'audit.dart';
import 'resource_type.dart';

class RegulationStandard extends Audit {
  final String type = ResourceType.RegulationStandard;
  String? surveyRegulationStandardGuid;
  String? surveyGuid;
  String? regulationStandardGuid;
  String? issuedCountryCode;
  String? issuedAuthorityCode;
  String? issuedAuthorityName;
  String? title;
  String? description;
  String? url;
  String? imageSrc;

  RegulationStandard({
    this.surveyGuid,
    this.regulationStandardGuid,
    this.issuedCountryCode,
    this.issuedAuthorityCode,
    this.issuedAuthorityName,
    this.title,
    this.description,
    this.url,
    this.imageSrc});

  RegulationStandard.fromJson(Map<String, dynamic> json) {
    surveyRegulationStandardGuid = json['surveyRegulationStandardGuid'];
    surveyGuid = json['surveyGuid'];
    regulationStandardGuid = json['regulationStandardGuid'];
    issuedCountryCode = json['issuedCountryCode'];
    issuedAuthorityCode = json['issuedAuthorityCode'];
    issuedAuthorityName = json['issuedAuthorityName'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    imageSrc = json['imageSrc'];
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['surveyRegulationStandardGuid'] = this.surveyRegulationStandardGuid;
    data['surveyGuid'] = this.surveyGuid;
    data['regulationStandardGuid'] = this.regulationStandardGuid;
    data['issuedCountryCode'] = this.issuedCountryCode;
    data['issuedAuthorityCode'] = this.issuedAuthorityCode;
    data['issuedAuthorityName'] = this.issuedAuthorityName;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['imageSrc'] = this.imageSrc;
    super.toAuditJson(data);
    return data;
  }
}
