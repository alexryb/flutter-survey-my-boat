import 'code.dart';
import 'resource_type.dart';

class SurveyorCertificate extends Code {
  final String type = ResourceType.SurveyorCertification;
  String? code;
  String? description;
  String? expiryDate;
  String? effectiveDate;
  String? surveyorCertificationGuid;
  String? surveyorGuid;
  String? certificateNumber;
  bool? isSelected = false;

  SurveyorCertificate.Null();

  SurveyorCertificate(
      { this.surveyorCertificationGuid,
        this.code,
        this.description,
        this.certificateNumber,
        this.surveyorGuid,
        this.expiryDate,
        this.effectiveDate});

  SurveyorCertificate.fromJson(Map<String, dynamic> json) {
      surveyorGuid = json['surveyorGuid'];
      certificateNumber = json['certificateNumber'];
      surveyorCertificationGuid = json['surveyorCertificationGuid'];
      effectiveDate = json['effectiveDate'];
      expiryDate = json['expiryDate'];
      description = json['description'];
      code = json['code'];
      fromAuditJson(json);
      isSelected = false;
      super.code = code;
      super.description = description;
      super.expiryDate = expiryDate;
      super.effectiveDate = effectiveDate;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data["@type"] = type;
    data['code'] = code ?? super.code;
    data['description'] = description ?? super.description;
    data['expiryDate'] = expiryDate ?? super.expiryDate;
    data['effectiveDate'] = effectiveDate ?? super.effectiveDate;
    data['surveyorCertificationGuid'] = surveyorCertificationGuid;
    data['surveyorGuid'] = surveyorGuid;
    data['certificateNumber'] = certificateNumber;
    super.toAuditJson(data);
    isSelected = false;
    return data;
  }

}
