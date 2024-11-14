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
    data['@type'] = type;
    data['surveyRegulationStandardGuid'] = surveyRegulationStandardGuid;
    data['surveyGuid'] = surveyGuid;
    data['regulationStandardGuid'] = regulationStandardGuid;
    data['issuedCountryCode'] = issuedCountryCode;
    data['issuedAuthorityCode'] = issuedAuthorityCode;
    data['issuedAuthorityName'] = issuedAuthorityName;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['imageSrc'] = imageSrc;
    super.toAuditJson(data);
    return data;
  }
}
