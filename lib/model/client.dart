import 'package:flutter/material.dart';
import 'client_image.dart';
import 'container_image.dart';
import 'image_container.dart';
import 'resource_type.dart';
import '../utils/uidata.dart';

class ClientResponse {
  Client? data;

  ClientResponse({this.data});

  ClientResponse.fromJson(Map<String, dynamic> json)
      : data = Client.fromJson(json['data']);
}

class Client extends ImageContainer {
  final String type = ResourceType.Client;
  String? clientGuid;
  String? firstName;
  String? middleName;
  String? lastName;
  String? addressLine;
  String? phoneNumber;
  String? emailAddress;
  String? identityVerifiedBy;
  Image? clientImage;
  List<ClientImage>? images;
  bool? editMode = false;

  Client(
      {this.clientGuid,
      this.firstName,
      this.middleName,
      this.lastName,
      this.addressLine,
      this.phoneNumber,
      this.emailAddress,
      this.identityVerifiedBy});

  String getName() => fullName();

  String fullName() {
    return '$lastName, $firstName ${middleName ?? ""}';
  }

  Image? image() {
    return clientImage == null
        ? (images != null && images!.isNotEmpty) ? Image.memory(images![0].content!) : Image.asset(UIData.userIcon, fit: BoxFit.none)
        : this.clientImage;
  }

  Image? defaultImage(Image defaultImage) {
    return clientImage == null
        ? (images != null && images!.isNotEmpty) ? Image.memory(images![0].content!) : defaultImage
        : this.clientImage;
  }

  Client.fromJson(Map<String, dynamic> json) {
    clientGuid = json['clientGuid'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    addressLine = json['addressLine'];
    phoneNumber = json['phoneNumber'];
    emailAddress = json['emailAddress'];
    identityVerifiedBy = json['identityVerifiedBy'];
    if (json['images'] != null) {
      images = List<ClientImage>.empty(growable: true);
      json['images'].forEach((v) {
        images?.add(new ClientImage.fromJson(v));
      });
    }
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['clientGuid'] = this.clientGuid;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['addressLine'] = this.addressLine;
    data['phoneNumber'] = this.phoneNumber;
    data['emailAddress'] = this.emailAddress;
    data['identityVerifiedBy'] = this.identityVerifiedBy;
    if (this.images != null) {
      data['images'] =
          this.images?.map((v) => v.toJson()).toList();
    }
    super.toAuditJson(data);
    return data;
  }

  void addImage(ContainerImage image) {
    if(images == null) {
      images = List<ClientImage>.empty(growable: true);
    }
    images?.clear();
    String formattedDate = new DateTime.now().toString().substring(0,10);
    ClientImage img = ClientImage(
        imageGuid: image.getImageGuid(),
        clientGuid: this.clientGuid,
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

  @override
  String toString() {
    return 'Name: $lastName, $firstName $middleName\n Address: $addressLine\n Phone: $phoneNumber\n Email: $emailAddress\n';
  }
}
