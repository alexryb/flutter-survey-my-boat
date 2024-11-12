import 'code.dart';
import 'resource_type.dart';

class SurveyorCertificate extends Code {
  final String type = ResourceType.SurveyorCertification;
  String code;
  String description;
  String expiryDate;
  String effectiveDate;
  String surveyorCertificationGuid;
  String surveyorGuid;
  String certificateNumber;
  bool isSelected = false;

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
    data["@type"] = this.type;
    data['code'] = this.code == null ? super.code : this.code;
    data['description'] = this.description == null ? super.description : this.description;
    data['expiryDate'] = this.expiryDate == null ? super.expiryDate : this.expiryDate;
    data['effectiveDate'] = this.effectiveDate == null ? super.effectiveDate : this.effectiveDate;
    data['surveyorCertificationGuid'] = this.surveyorCertificationGuid;
    data['surveyorGuid'] = this.surveyorGuid;
    data['certificateNumber'] = this.certificateNumber;
    super.toAuditJson(data);
    isSelected = false;
    return data;
  }

}
