import 'dart:convert';

import '../di/dependency_injection.dart';
import 'vessel.dart';
import 'vessel_image.dart';
import 'vessel_type.dart';

class VesselCatalog {
  String createdBy;
  String createDate;
  String updatedBy;
  String updateDate;
  String vesselGuid;
  String vesselUrl;
  String vesselDescription;
  String hullType;
  String riggingType;
  String loa;
  String lwl;
  String beam;
  String saRep;
  String draft;
  String displacement;
  String ballast;
  String saDisplacement;
  String ballastDisplacement;
  String displacementLength;
  String construction;
  String ballastType;
  String vesselBuilder;
  String vesselDesigner;
  // String logoSrc;
  // String imageSrc;
  VesselType vesselType;
  VesselImage image;

  VesselCatalog(
      { this.createdBy,
        this.createDate,
        this.updatedBy,
        this.updateDate,
        this.vesselGuid,
        this.vesselUrl,
        this.vesselDescription,
        this.hullType,
        this.riggingType,
        this.loa,
        this.lwl,
        this.beam,
        this.saRep,
        this.draft,
        this.displacement,
        this.ballast,
        this.saDisplacement,
        this.ballastDisplacement,
        this.displacementLength,
        this.construction,
        this.ballastType,
        this.vesselBuilder,
        this.vesselDesigner,
        // this.logoSrc,
        // this.imageSrc,
        this.vesselType,
        this.image,
      });

  VesselCatalog.fromVessel(Vessel vessel) {
    createdBy = vessel.createdBy;
    createDate = vessel.createDate;
    updatedBy = vessel.updatedBy;
    updateDate = vessel.updateDate;
    vesselGuid = vessel.vesselGuid;
    vesselUrl = null;
    vesselDescription = vessel.model;
    hullType = vessel.vesselType.description;
    riggingType = vessel.name;
    loa = vessel.loa;
    lwl = null;
    beam = vessel.beam;
    saRep = null;
    draft = vessel.draft;
    displacement = vessel.displacement;
    ballast = vessel.ballast;
    saDisplacement = null;
    ballastDisplacement = null;
    displacementLength = null;
    construction = null;
    ballastType = null;
    vesselBuilder = vessel.vesselBuilder;
    vesselDesigner = vessel.vesselDesigner;
    // logoSrc = null;
    // imageSrc = null;
    vesselType = vessel.vesselType;
    if(vessel.images != null && !vessel.images.isEmpty) {
      image = vessel.images[0];
    }
  }

  VesselCatalog.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createDate = json['createDate'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    vesselGuid = json['vesselGuid'];
    vesselUrl = json['vesselUrl'];
    vesselDescription = json['vesselDescription'];
    hullType = json['hullType'];
    riggingType = json['riggingType'];
    loa = json['loa'];
    lwl = json['lwl'];
    beam = json['beam'];
    saRep = json['saRep'];
    draft = json['draft'];
    displacement = json['displacement'];
    ballast = json['ballast'];
    saDisplacement = json['saDisplacement'];
    ballastDisplacement = json['ballastDisplacement'];
    displacementLength = json['displacementLength'];
    construction = json['construction'];
    ballastType = json['ballastType'];
    vesselBuilder = json['vesselBuilder'];
    vesselDesigner = json['vesselDesigner'];
    // logoSrc = json['logoSrc'];
    // imageSrc = json['imageSrc'];
    if(json['logoContent'] != null) {
      this.image = new VesselImage(content: Base64Decoder().convert(json['logoContent']));
    }
    vesselType = json['vesselType'] != null
        ? new VesselType.fromJson(json['vesselType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['createdBy'] = this.createdBy;
    data['createDate'] = this.createDate;
    data['updatedBy'] = this.updatedBy;
    data['updateDate'] = this.updateDate;
    data['vesselGuid'] = this.vesselGuid;
    data['vesselUrl'] = this.vesselUrl;
    data['vesselDescription'] = this.vesselDescription;
    data['hullType'] = this.hullType;
    data['riggingType'] = this.riggingType;
    data['loa'] = this.loa;
    data['lwl'] = this.lwl;
    data['beam'] = this.beam;
    data['saRep'] = this.saRep;
    data['draft'] = this.draft;
    data['displacement'] = this.displacement;
    data['ballast'] = this.ballast;
    data['saDisplacement'] = this.saDisplacement;
    data['ballastDisplacement'] = this.ballastDisplacement;
    data['displacementLength'] = this.displacementLength;
    data['construction'] = this.construction;
    data['ballastType'] = this.ballastType;
    data['vesselBuilder'] = this.vesselBuilder;
    data['vesselDesigner'] = this.vesselDesigner;
    // data['logoSrc'] = this.logoSrc;
    // data['imageSrc'] = this.imageSrc;
    if (this.vesselType != null) {
      data['vesselType'] = this.vesselType.toJson();
    }
    return data;
  }

  String getVesselDescription() {
    if(this.vesselDescription != null) {
      if(this.vesselDescription.contains("(")) {
        return this.vesselDescription.substring(
            0, this.vesselDescription.indexOf("(")).trim();
      }
      return this.vesselDescription;
    }
    return "";
  }

  String getHullType() {
    if(this.hullType != null) {
      return this.hullType;
    }
    return "";
  }

  String getRiggingType() {
    if(this.riggingType != null) {
      return this.riggingType;
    }
    return "";
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
}
