import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'container_image.dart';
import 'image_container.dart';
import 'resource_type.dart';
import 'surveyor_certificate.dart';
import 'surveyor_image.dart';
import 'surveyor_organization.dart';
import '../utils/uidata.dart';

class SurveyorResponse {
  Surveyor? data;

  SurveyorResponse({this.data});

  SurveyorResponse.fromJson(Map<String, dynamic> json)
      : data = Surveyor.fromJson(json['data']);
}

class Surveyor extends ImageContainer {
  final String type = ResourceType.Surveyor;
  String? surveyorGuid;
  String? title;
  String? firstName;
  String? middleName;
  String? lastName;
  String? addressLine;
  String? phoneNumber;
  String? emailAddress;
  Uint8List? signature;
  SurveyorOrganization? organization;
  List<SurveyorCertificate>? certifications;
  List<SurveyorImage>? images;
  Image? surveyorImage;

  Surveyor.Null({
    this.surveyorGuid = "",
  });

  Surveyor({
      this.surveyorGuid,
      this.title,
      this.firstName,
      this.middleName,
      this.lastName,
      this.addressLine,
      this.phoneNumber,
      this.emailAddress,
      this.organization,
      this.certifications});

  Image? image() {
    return surveyorImage ?? ((images != null && images!.isNotEmpty) ? Image.memory(images![0].content!) : Image.asset(UIData.userIcon, fit: BoxFit.none));
  }

  Image? defaultImage(Image defaultImage) {
    return surveyorImage ?? ((images != null && images!.isNotEmpty) ? Image.memory(images![0].content!) : defaultImage);
  }

  Surveyor.fromJson(Map<String, dynamic> json) {
    surveyorGuid = json['surveyorGuid'];
    title = json['title'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    addressLine = json['addressLine'];
    phoneNumber = json['phoneNumber'];
    emailAddress = json['emailAddress'];
    organization = json['organization'] != null
        ? new SurveyorOrganization.fromJson(json['organization'])
        : null;
    if (json['certifications'] != null) {
      certifications = List<SurveyorCertificate>.empty(growable: true);
      json['certifications'].forEach((v) {
        certifications?.add(new SurveyorCertificate.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = List<SurveyorImage>.empty(growable: true);
      json['images'].forEach((v) {
        images?.add(new SurveyorImage.fromJson(v));
      });
    }
    if (json['signature'] != null) {
      signature = Base64Decoder().convert(json['signature']);
    }
    super.fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['surveyorGuid'] = surveyorGuid;
    data['title'] = title;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['addressLine'] = addressLine;
    data['phoneNumber'] = phoneNumber;
    data['emailAddress'] = emailAddress;
    if (organization != null) {
      data['organization'] = organization?.toJson();
    }
    if (certifications != null) {
      data['certifications'] = certifications?.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] =
          images?.map((v) => v.toJson()).toList();
    }
    if(signature != null) {
      data['signature'] = Base64Encoder().convert(signature!);
    }
    super.toAuditJson(data);
    return data;
  }

  String getName() => fullname;

  String get fullname {
    return '$lastName, ${firstName}';
  }

  void addImage(ContainerImage image) {
    images ??= List<SurveyorImage>.empty(growable: true);
    images?.clear();
    String formattedDate = new DateTime.now().toString().substring(0,10);
    SurveyorImage img = SurveyorImage(
        imageGuid: image.getImageGuid(),
        surveyorGuid: surveyorGuid,
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
