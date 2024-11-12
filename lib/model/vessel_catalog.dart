import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../di/dependency_injection.dart';
import 'vessel.dart';
import 'vessel_image.dart';
import 'vessel_type.dart';

class VesselCatalog {
  String? createdBy;
  String? createDate;
  String? updatedBy;
  String? updateDate;
  String? vesselGuid;
  String? vesselUrl;
  String? vesselDescription;
  String? hullType;
  String? riggingType;
  String? loa;
  String? lwl;
  String? beam;
  String? saRep;
  String? draft;
  String? displacement;
  String? ballast;
  String? saDisplacement;
  String? ballastDisplacement;
  String? displacementLength;
  String? construction;
  String? ballastType;
  String? vesselBuilder;
  String? vesselDesigner;
  // String logoSrc;
  // String imageSrc;
  VesselType? vesselType;
  VesselImage? image;

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
    hullType = vessel.vesselType?.description;
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
    if(vessel.images != null && vessel.images!.isNotEmpty) {
      image = vessel.images![0];
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
      image = new VesselImage(content: Base64Decoder().convert(json['logoContent']));
    }
    vesselType = json['vesselType'] != null
        ? new VesselType.fromJson(json['vesselType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['createdBy'] = createdBy;
    data['createDate'] = createDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['vesselGuid'] = vesselGuid;
    data['vesselUrl'] = vesselUrl;
    data['vesselDescription'] = vesselDescription;
    data['hullType'] = hullType;
    data['riggingType'] = riggingType;
    data['loa'] = loa;
    data['lwl'] = lwl;
    data['beam'] = beam;
    data['saRep'] = saRep;
    data['draft'] = draft;
    data['displacement'] = displacement;
    data['ballast'] = ballast;
    data['saDisplacement'] = saDisplacement;
    data['ballastDisplacement'] = ballastDisplacement;
    data['displacementLength'] = displacementLength;
    data['construction'] = construction;
    data['ballastType'] = ballastType;
    data['vesselBuilder'] = vesselBuilder;
    data['vesselDesigner'] = vesselDesigner;
    // data['logoSrc'] = this.logoSrc;
    // data['imageSrc'] = this.imageSrc;
    if (vesselType != null) {
      data['vesselType'] = vesselType?.toJson();
    }
    return data;
  }

  String? getVesselDescription() {
    if(vesselDescription != null) {
      if(vesselDescription!.contains("(")) {
        return vesselDescription!.substring(
            0, vesselDescription!.indexOf("(")).trim();
      }
      return vesselDescription;
    }
    return "";
  }

  String? getHullType() {
    if(hullType != null) {
      return hullType;
    }
    return "";
  }

  String? getRiggingType() {
    if(riggingType != null) {
      return riggingType;
    }
    return "";
  }

  String? getBuilder() {
    if(vesselBuilder != null) {
      if(vesselBuilder!.contains("(")) {
        return vesselBuilder?.substring(
            0, vesselBuilder?.indexOf("(")).trim();
      }
      return vesselBuilder;
    }
    return "";
  }

  String? getLoa() {
    if (kDebugMode) {
      print("Locale: ${Injector.SETTINGS?.localeName}");
    }
    if(loa != null) {
      if(loa!.contains("/")) {
        switch(Injector.SETTINGS?.localeName) {
          case "en_CA":
            return loa?.substring(0, loa?.indexOf("/"));
          case "en_US":
            return loa?.substring(0, loa?.indexOf("/"));
          case "UK":
            return loa?.substring(loa!.indexOf("/"), loa!.length - 1);
          case "AU":
            return loa?.substring(loa!.indexOf("/"), loa!.length - 1);
          case "NZ":
            return loa?.substring(loa!.indexOf("/"), loa!.length - 1);
          default:
            return loa;
        }
      }
      return loa;
    }
    return "";
  }

  String? getBeam() {
    if(beam != null) {
      if(beam!.contains("/")) {
        switch(Injector.SETTINGS?.localeName) {
          case "en_CA":
            return beam?.substring(0, beam!.indexOf("/"));
          case "en_US":
            return beam?.substring(0, beam!.indexOf("/"));
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
}
