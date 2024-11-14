import 'checkpoint_image.dart';
import 'container_image.dart';
import 'image_container.dart';
import 'resource_type.dart';

import 'checkpoint_attribute_value.dart';
import 'checkpoint_condition.dart';
import 'checkpoint_fix_priority.dart';
import 'checkpoint_status.dart';
import 'construction_material.dart';
import 'inspection_area.dart';

class CheckPoint extends ImageContainer {
  final String type = ResourceType.CheckPoint;
  String? checkPointGuid;
  String? surveyGuid;
  @override
  String? name;
  String? generalDescription;
  String? manufacturer;
  String? model;
  String? changesNoted;
  String? severityNotes;
  int? reportOrder;
  ConstructionMaterial? constructionMaterial;
  CheckPointCondition? condition;
  InspectionArea? inspectionArea;
  CheckPointStatus? status;
  CheckPointFixPriority? fixPriority;
  List<CheckPointAttributeValue>? attributeValues;
  List<CheckPointImage>? images;
  List<CheckPoint>? children;
  bool? expressMode = false;

  CheckPoint? parent;

  CheckPoint({
    this.checkPointGuid,
    this.surveyGuid,
    String? name,
    this.generalDescription,
    this.manufacturer,
    this.model,
    this.changesNoted,
    this.severityNotes,
    this.reportOrder,
    this.constructionMaterial,
    this.condition,
    this.inspectionArea,
    //this.status,
    this.fixPriority,
    this.attributeValues,
    this.children,
    this.expressMode
  });

  bool get hasChild  {
    return children != null && children!.isNotEmpty;
  }

  void setStatus(CheckPointStatus status) {
    this.status = status;
    if(parent != null && status == CheckPointStatus.UnCompleted()) {
      parent?.status = CheckPointStatus.UnCompleted();
    }
  }

  CheckPoint.fromJson(Map<String, dynamic> json) {
    checkPointGuid = json['checkPointGuid'];
    surveyGuid = json['surveyGuid'];
    name = json['name'];
    generalDescription = json['generalDescription'];
    manufacturer = json['manufacturer'];
    model = json['model'];
    changesNoted = json['changesNoted'];
    severityNotes = json['severityNotes'];
    reportOrder = json['reportOrder'];
    constructionMaterial = json['constructionMaterial'] != null ? new ConstructionMaterial.fromJson(json['constructionMaterial']) : null;
    condition = json['condition'] != null ? new CheckPointCondition.fromJson(json['condition']) : CheckPointCondition.Servicable();
    if (json['images'] != null) {
      images = List<CheckPointImage>.empty(growable: true);
      json['images'].forEach((v) => images?.add(new CheckPointImage.fromJson(v)));
    }
    status = json['status'] != null ? new CheckPointStatus.fromJson(json['status']) : CheckPointStatus.NotStarted();
    fixPriority = json['fixPriority'] != null ? new CheckPointFixPriority.fromJson(json['fixPriority']) : CheckPointFixPriority.NoIssue();
    if (json['attributeValues'] != null) {
      attributeValues = List<CheckPointAttributeValue>.empty(growable: true);
      json['attributeValues'].forEach((v) =>
        attributeValues?.add(new CheckPointAttributeValue.fromJson(v)));
    }
    if (json['children'] != null) {
      children = List<CheckPoint>.empty(growable: true);
      json['children'].forEach((v) =>
        children?.add(new CheckPoint.fromJson(v)));
    }
    if(json['expressMode'] != null) {
      expressMode = json['expressMode'];
    } else {
      expressMode = false;
    }
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@type'] = type;
    data['checkPointGuid'] = checkPointGuid;
    data['surveyGuid'] = surveyGuid;
    data['name'] = name;
    data['generalDescription'] = generalDescription;
    data['manufacturer'] = manufacturer;
    data['model'] = model;
    data['changesNoted'] = changesNoted;
    data['severityNotes'] = severityNotes;
    data['reportOrder'] = reportOrder;
    data['constructionMaterial'] = constructionMaterial;
    if (condition != null) {
      data['condition'] = condition?.toJson();
    }
    if (images != null) {
      data['images'] =
          images?.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status?.toJson();
    }
    data['fixPriority'] = fixPriority;
    if (attributeValues != null) {
      data['attributeValues'] =
          attributeValues?.map((v) => v.toJson()).toList();
    }
    if (children != null) {
      data['children'] = children?.map((v) => v.toJson()).toList();
    }
    if(expressMode != null) {
      data['expressMode'] = expressMode;
    }
    super.toAuditJson(data);
    return data;
  }

  @override
  void addImage(ContainerImage image) {
    images ??= List<CheckPointImage>.empty(growable: true);
    String formattedDate = new DateTime.now().toString().substring(0,10);
    CheckPointImage img = CheckPointImage(
        imageGuid: image.getImageGuid(),
        checkPointGuid: checkPointGuid,
        surveyGuid: surveyGuid,
        mimeType: image.getMimeType(),
        name: image.getName(),
        description: image.getDescription(),
        content: image.getContent()
    );
    img.createdBy = "IMB-APP";
    img.createDate = formattedDate;
    img.updatedBy = "IMB-APP";
    img.updateDate = formattedDate;
    images?.add(img);
  }
}
