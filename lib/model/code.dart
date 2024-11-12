import 'audit.dart';

class CodeResponse {
  final Code data;

  CodeResponse({required this.data});

  CodeResponse.fromJson(Map<String, dynamic> json)
      : data = Code.fromJson(json['data']);
}

class Code extends Audit {
  String? type;
  String? code;
  String? description;
  String? expiryDate;
  String? effectiveDate;

  Code({this.type});
  Code.Named(this.type, this.code, this.description, this.expiryDate, this.effectiveDate);
  Code.NamedOptional({this.type, this.code, this.description, this.expiryDate, this.effectiveDate});

  Code.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    code = json['code'];
    description = json['description'];
    expiryDate = json['expiryDate'];
    effectiveDate = json['effectiveDate'];
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['code'] = this.code;
    data['description'] = this.description;
    data['expiryDate'] = this.expiryDate;
    data['effectiveDate'] = this.effectiveDate;
    super.toAuditJson(data);
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Code &&
              code == other.code;

  @override
  int get hashCode =>
      code.hashCode;

}
