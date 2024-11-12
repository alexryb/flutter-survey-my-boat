import '../di/dependency_injection.dart';
import 'container_image.dart';
import 'image_container.dart';
import 'resource_type.dart';
import 'vessel_catalog.dart';
import 'vessel_image.dart';

import 'vessel_type.dart';

class Vessel extends ImageContainer {
  final String type = ResourceType.Vessel;
  String vesselGuid;
  String name;
  String model;
  String modelYear;
  String dateofManifacture;
  String licenseNumber;
  String hin;
  String hinLocation;
  String registryNo;
  String registryExpires;
  String loa;
  String draft;
  String displacement;
  String beam;
  String ballast;
  String vesselDescription;
  String documentedUse;
  String homePort;
  String vesselBuilder;
  List<VesselImage> images;

  String vesselDesigner;
  VesselType vesselType;

  Vessel.Catalog(this.vesselGuid, this.name);

  String getName() => name;

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
        images.add(new VesselImage.fromJson(v));
      });
    }
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['vesselGuid'] = this.vesselGuid;
    data['name'] = this.name;
    data['model'] = this.model;
    data['modelYear'] = this.modelYear;
    data['licenseNumber'] = this.licenseNumber;
    data['hin'] = this.hin;
    data['hinLocation'] = this.hinLocation;
    data['registryNo'] = this.registryNo;
    data['draft'] = this.draft;
    data['displacement'] = this.displacement;
    data['beam'] = this.beam;
    data['ballast'] = this.ballast;
    data['vesselDescription'] = this.vesselDescription;
    data['documentedUse'] = this.documentedUse;
    data['homePort'] = this.homePort;
    data['vesselBuilder'] = this.vesselBuilder;
    data['vesselDesigner'] = this.vesselDesigner;
    if (this.vesselType != null) {
      data['vesselType'] = this.vesselType.toJson();
    }
    if (this.images != null) {
      data['images'] =
          this.images.map((v) => v.toJson()).toList();
    }
    data['loa'] = this.loa;
    super.toAuditJson(data);
    return data;
  }

  bool hasImage() {
    return images != null && !images.isEmpty;
  }

  void addImage(ContainerImage image) {
    if(images == null) {
      images = List<VesselImage>.empty(growable: true);
    }
    String formattedDate = new DateTime.now().toString().substring(0,10);
    VesselImage img = VesselImage(
        imageGuid: image.getImageGuid(),
        vesselGuid: this.vesselGuid,
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

  String getBuilder() {
    if(this.vesselBuilder != null) {
      if(this.vesselBuilder.contains("(")) {
        return this.vesselBuilder.substring(
            0, this.vesselBuilder.indexOf("(")).trim();
      }
      return this.vesselBuilder;
    }
    return "";
  }

  String getLoa() {
    print("Locale: ${Injector.SETTINGS.localeName}");
    if(this.loa != null) {
      if(this.loa.contains("/")) {
        switch(Injector.SETTINGS.localeName) {
          case "en_CA":
            return this.loa.substring(0, this.loa.indexOf("/"));
          case "en_US":
            return this.loa.substring(0, this.loa.indexOf("/"));
          case "UK":
            return this.loa.substring(this.loa.indexOf("/"), this.loa.length - 1);
          case "AU":
            return this.loa.substring(this.loa.indexOf("/"), this.loa.length - 1);
          case "NZ":
            return this.loa.substring(this.loa.indexOf("/"), this.loa.length - 1);
          default:
            return this.loa;
        }
      }
      return this.loa;
    }
    return "";
  }

  String getBeam() {
    if(this.beam != null) {
      if(this.beam.contains("/")) {
        switch(Injector.SETTINGS.localeName) {
          case "en_CA":
            return this.beam.substring(0, this.beam.indexOf("/"));
          case "en_US":
            return this.beam.substring(0, this.beam.indexOf("/"));
          case "UK":
            return this.beam.substring(this.beam.indexOf("/"), this.beam.length - 1);
          case "AU":
            return this.beam.substring(this.beam.indexOf("/"), this.beam.length - 1);
          case "NZ":
            return this.beam.substring(this.beam.indexOf("/"), this.beam.length - 1);
          default:
            return this.beam;
        }
      }
    }
    return "";
  }

  String getDisp() {
    if(this.displacement != null) {
      if(this.displacement.contains("/")) {
        switch(Injector.SETTINGS.localeName) {
          case "en_CA":
            return this.displacement.substring(0, this.displacement.indexOf("/"));
          case "en_US":
            return this.displacement.substring(0, this.displacement.indexOf("/"));
          case "UK":
            return this.displacement.substring(this.displacement.indexOf("/"), this.displacement.length - 1);
          case "AU":
            return this.displacement.substring(this.displacement.indexOf("/"), this.displacement.length - 1);
          case "NZ":
            return this.displacement.substring(this.displacement.indexOf("/"), this.displacement.length - 1);
          default:
            return this.displacement;
        }
      }
    }
    return "";
  }

  String getBallast() {
    if(this.ballast != null) {
      if(this.ballast.contains("/")) {
        switch(Injector.SETTINGS.localeName) {
          case "en_CA":
            return this.ballast.substring(0, this.ballast.indexOf("/"));
          case "en_US":
            return this.ballast.substring(0, this.ballast.indexOf("/"));
          case "UK":
            return this.ballast.substring(this.ballast.indexOf("/"), this.ballast.length - 1);
          case "AU":
            return this.ballast.substring(this.ballast.indexOf("/"), this.ballast.length - 1);
          case "NZ":
            return this.ballast.substring(this.ballast.indexOf("/"), this.ballast.length - 1);
          default:
            return this.ballast;
        }
      }
    }
    return "";
  }

  String getDraft() {
    if(this.draft != null) {
      if(this.draft.contains("/")) {
        switch(Injector.SETTINGS.localeName) {
          case "en_CA":
            return this.draft.substring(0, this.draft.indexOf("/"));
          case "en_US":
            return this.draft.substring(0, this.draft.indexOf("/"));
          case "UK":
            return this.draft.substring(this.draft.indexOf("/"), this.draft.length - 1);
          case "AU":
            return this.draft.substring(this.draft.indexOf("/"), this.draft.length - 1);
          case "NZ":
            return this.draft.substring(this.draft.indexOf("/"), this.draft.length - 1);
          default:
            return this.draft;
        }
      }
    }
    return "";
  }
}
