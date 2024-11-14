import 'package:flutter/foundation.dart';

import '../di/dependency_injection.dart';
import 'container_image.dart';
import 'image_container.dart';
import 'resource_type.dart';
import 'vessel_catalog.dart';
import 'vessel_image.dart';

import 'vessel_type.dart';

class Vessel extends ImageContainer {
  final String type = ResourceType.Vessel;
  String? vesselGuid;
  @override
  String? name;
  String? model;
  String? modelYear;
  String? dateofManifacture;
  String? licenseNumber;
  String? hin;
  String? hinLocation;
  String? registryNo;
  String? registryExpires;
  String? loa;
  String? draft;
  String? displacement;
  String? beam;
  String? ballast;
  String? vesselDescription;
  String? documentedUse;
  String? homePort;
  String? vesselBuilder;
  List<VesselImage>? images = List<VesselImage>.empty(growable: true);

  String? vesselDesigner;
  VesselType? vesselType;

  Vessel.Catalog(this.vesselGuid, this.name);

  @override
  String? getName() => name;

  Vessel({
      this.vesselGuid,
      this.name,
      this.model,
      this.modelYear,
      this.dateofManifacture,
      this.licenseNumber,
      this.hin,
      this.hinLocation,
      this.registryNo,
      this.registryExpires,
      this.loa,
      this.draft,
      this.displacement,
      this.beam,
      this.ballast,
      this.vesselDescription,
      this.documentedUse,
      this.homePort,
      this.vesselBuilder,
      this.vesselDesigner,
      this.vesselType,
      this.images
  });

  Vessel.fromVesselCatalog(VesselCatalog vesselCatalog) {
    createdBy = vesselCatalog.createdBy;
    createDate = vesselCatalog.createDate;
    updatedBy = vesselCatalog.updatedBy;
    updateDate = vesselCatalog.updateDate;
    vesselGuid = vesselCatalog.vesselGuid;
    model = vesselCatalog.vesselDescription;
    loa = vesselCatalog.loa;
    beam = vesselCatalog.beam;
    draft = vesselCatalog.draft;
    displacement = vesselCatalog.displacement;
    ballast = vesselCatalog.ballast;
    vesselBuilder = vesselCatalog.vesselBuilder;
    vesselDesigner = vesselCatalog.vesselDesigner;
    // logoSrc = null;
    // imageSrc = null;
    vesselType = vesselCatalog.vesselType;
    images = List<VesselImage>.empty(growable: true);
  }

  Vessel.fromJson(Map<String, dynamic> json) {
    vesselGuid = json['vesselGuid'];
    name = json['name'];
    model = json['model'];
    modelYear = json['modelYear'];
    licenseNumber = json['licenseNumber'];
    hin = json['hin'];
    hinLocation = json['hinLocation'];
    registryNo = json['registryNo'];
    draft = json['draft'];
    displacement = json['displacement'];
    beam = json['beam'];
    ballast = json['ballast'];
    vesselDescription = json['vesselDescription'];
    documentedUse = json['documentedUse'];
    homePort = json['homePort'];
    vesselBuilder = json['vesselBuilder'];
    vesselDesigner = json['vesselDesigner'];
    vesselType = json['vesselType'] != null
        ? new VesselType.fromJson(json['vesselType'])
        : null;
    loa = json['loa'];
    if (json['images'] != null) {
      images = List<VesselImage>.empty(growable: true);
      json['images'].forEach((v) {
        images?.add(new VesselImage.fromJson(v));
      });
    }
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['vesselGuid'] = vesselGuid;
    data['name'] = name;
    data['model'] = model;
    data['modelYear'] = modelYear;
    data['licenseNumber'] = licenseNumber;
    data['hin'] = hin;
    data['hinLocation'] = hinLocation;
    data['registryNo'] = registryNo;
    data['draft'] = draft;
    data['displacement'] = displacement;
    data['beam'] = beam;
    data['ballast'] = ballast;
    data['vesselDescription'] = vesselDescription;
    data['documentedUse'] = documentedUse;
    data['homePort'] = homePort;
    data['vesselBuilder'] = vesselBuilder;
    data['vesselDesigner'] = vesselDesigner;
    if (vesselType != null) {
      data['vesselType'] = vesselType?.toJson();
    }
    if (images != null) {
      data['images'] =
          images?.map((v) => v.toJson()).toList();
    }
    data['loa'] = loa;
    super.toAuditJson(data);
    return data;
  }

  bool hasImage() {
    return images != null && images!.isNotEmpty;
  }

  @override
  void addImage(ContainerImage image) {
    images ??= List<VesselImage>.empty(growable: true);
    String formattedDate = new DateTime.now().toString().substring(0,10);
    VesselImage img = VesselImage(
        imageGuid: image.getImageGuid(),
        vesselGuid: vesselGuid,
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

  String? getBuilder() {
    if(vesselBuilder != null) {
      if(vesselBuilder!.contains("(")) {
        return vesselBuilder!.substring(
            0, vesselBuilder!.indexOf("(")).trim();
      }
      return vesselBuilder;
    }
    return "";
  }

  String? getLoa() {
    if (kDebugMode) {
      print("Locale: ${Injector.SETTINGS!.localeName}");
    }
    if(loa != null) {
      if(loa!.contains("/")) {
        switch(Injector.SETTINGS!.localeName) {
          case "en_CA":
            return loa!.substring(0, loa!.indexOf("/"));
          case "en_US":
            return loa!.substring(0, loa!.indexOf("/"));
          case "UK":
            return loa!.substring(loa!.indexOf("/"), loa!.length - 1);
          case "AU":
            return loa!.substring(loa!.indexOf("/"), loa!.length - 1);
          case "NZ":
            return loa!.substring(loa!.indexOf("/"), loa!.length - 1);
          default:
            return loa!;
        }
      }
      return loa!;
    }
    return "";
  }

  String? getBeam() {
    if(beam != null) {
      if(beam!.contains("/")) {
        switch(Injector.SETTINGS?.localeName) {
          case "en_CA":
            return beam?.substring(0, beam?.indexOf("/"));
          case "en_US":
            return beam?.substring(0, beam?.indexOf("/"));
          case "UK":
            return beam?.substring(beam!.indexOf("/"), beam!.length - 1);
          case "AU":
            return beam?.substring(beam!.indexOf("/"), beam!.length - 1);
          case "NZ":
            return beam?.substring(beam!.indexOf("/"), beam!.length - 1);
          default:
            return beam;
        }
      }
    }
    return "";
  }

  String? getDisp() {
    if(displacement != null) {
      if(displacement!.contains("/")) {
        switch(Injector.SETTINGS?.localeName) {
          case "en_CA":
            return displacement?.substring(0, displacement!.indexOf("/"));
          case "en_US":
            return displacement?.substring(0, displacement!.indexOf("/"));
          case "UK":
            return displacement?.substring(displacement!.indexOf("/"), displacement!.length - 1);
          case "AU":
            return displacement?.substring(displacement!.indexOf("/"), displacement!.length - 1);
          case "NZ":
            return displacement?.substring(displacement!.indexOf("/"), displacement!.length - 1);
          default:
            return displacement;
        }
      }
    }
    return "";
  }

  String? getBallast() {
    if(ballast != null) {
      if(ballast!.contains("/")) {
        switch(Injector.SETTINGS?.localeName) {
          case "en_CA":
            return ballast?.substring(0, ballast!.indexOf("/"));
          case "en_US":
            return ballast?.substring(0, ballast!.indexOf("/"));
          case "UK":
            return ballast?.substring(ballast!.indexOf("/"), ballast!.length - 1);
          case "AU":
            return ballast?.substring(ballast!.indexOf("/"), ballast!.length - 1);
          case "NZ":
            return ballast?.substring(ballast!.indexOf("/"), ballast!.length - 1);
          default:
            return ballast;
        }
      }
    }
    return "";
  }

  String? getDraft() {
    if(draft != null) {
      if(draft!.contains("/")) {
        switch(Injector.SETTINGS?.localeName) {
          case "en_CA":
            return draft?.substring(0, draft!.indexOf("/"));
          case "en_US":
            return draft?.substring(0, draft!.indexOf("/"));
          case "UK":
            return draft?.substring(draft!.indexOf("/"), draft!.length - 1);
          case "AU":
            return draft?.substring(draft!.indexOf("/"), draft!.length - 1);
          case "NZ":
            return draft?.substring(draft!.indexOf("/"), draft!.length - 1);
          default:
            return draft;
        }
      }
    }
    return "";
  }
}
