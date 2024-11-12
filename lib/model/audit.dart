class Audit {
  String? createdBy;
  String? createDate;
  String? updatedBy;
  String? updateDate;
  bool inSync = true;

  void fromAuditJson(Map<String, dynamic> json) {
    inSync = json['inSync'] ?? true;
    createdBy = json['createdBy'];
    createDate = json['createDate'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
  }

  Map<String, dynamic> toAuditJson(Map<String, dynamic> data) {
    data['inSync'] = true;
    data['createdBy'] = createdBy;
    data['createDate'] = createDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    return data;
  }
}
