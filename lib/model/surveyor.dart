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
  Surveyor data;

  SurveyorResponse({this.data});

  SurveyorResponse.fromJson(Map<String, dynamic> json)
      : data = Surveyor.fromJson(json['data']);
}

class Surveyor extends ImageContainer {
  final String type = ResourceType.Surveyor;
  String surveyorGuid;
  String title;
  String firstName;
  String middleName;
  String lastName;
  String addressLine;
  String phoneNumber;
  String emailAddress;
  Uint8List signature;
  SurveyorOrganization organization;
  List<SurveyorCertificate> certifications;
  List<SurveyorImage> images;
  Image surveyorImage;

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

  Image image() {
    return surveyorImage == null
        ? (images != null && !images.isEmpty) ? Image.memory(images[0].content) : Image.asset(UIData.userIcon, fit: BoxFit.none)
        : this.surveyorImage;
  }

  Image defaultImage(Image defaultImage) {
    return surveyorImage == null
        ? (images != null && !images.isEmpty) ? Image.memory(images[0].content) : defaultImage
        : this.surveyorImage;
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
        certifications.add(new SurveyorCertificate.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = List<SurveyorImage>.empty(growable: true);
      json['images'].forEach((v) {
        images.add(new SurveyorImage.fromJson(v));
      });
    }
    if (json['signature'] != null) {
      signature = Base64Decoder().convert(json['signature']);
    }
    super.fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['surveyorGuid'] = this.surveyorGuid;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['addressLine'] = this.addressLine;
    data['phoneNumber'] = this.phoneNumber;
    data['emailAddress'] = this.emailAddress;
    if (this.organization != null) {
      data['organization'] = this.organization.toJson();
    }
    if (this.certifications != null) {
      data['certifications'] = this.certifications.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] =
          this.images.map((v) => v.toJson()).toList();
    }
    if(this.signature != null) {
      data['signature'] = Base64Encoder().convert(this.signature);
    }
    super.toAuditJson(data);
    return data;
  }

  String getName() => fullname;

  String get fullname {
    return '${this.lastName}, ${this.firstName}';
  }

  void addImage(ContainerImage image) {
    if(images == null) {
      images = List<SurveyorImage>.empty(growable: true);
    }
    images.clear();
    String formattedDate = new DateTime.now().toString().substring(0,10);
    SurveyorImage img = SurveyorImage(
        imageGuid: image.getImageGuid(),
        surveyorGuid: this.surveyorGuid,
        mimeType: image.getMimeType(),
        name: image.getName(),
        description: image.getDescription(),
        content: image.getContent()
    );
    img.createdBy = "IMB-APP";
    img.createDate = formattedDate;
    img.updatedBy = "IMB-APP";
    img.updateDate = formattedDate;
    images.add(img);
  }
}
