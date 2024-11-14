import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:surveymyboatpro/model/vessel_catalog.dart';
import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_vessel_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class LocalVesselService implements IVesselService {

  static String? vesselCatalogJson;

  @override
  Future<NetworkServiceResponse<VesselCatalogListResponse>> findCatalogVessel(
      String modelName) async {
    //await Future.delayed(Duration(seconds: 2));
    VesselCatalogList result = await _getVesselCatalog(modelName);
    return NetworkServiceResponse(
        success: true,
        content: new VesselCatalogListResponse(data: result)
    );
  }

  Future<String?> _loadVesselCatalogAsset() async {
    vesselCatalogJson ??= await rootBundle.loadString('assets/data/vesselCatalog.json');
    return vesselCatalogJson;
  }

  Future<VesselCatalogList> _getVesselCatalog(String modelName) async {
    List<VesselCatalog> result = List.empty(growable: true);
    String? jsonString = await _loadVesselCatalogAsset();
    final jsonResponse = json.decode(jsonString!);
    VesselCatalogList vesselCatalogList = new VesselCatalogList.fromJson(jsonResponse);
    for (VesselCatalog _vessel in vesselCatalogList.elements!) {
      if (_vessel.vesselDescription != null) {
        if (_vessel.vesselDescription!.toLowerCase().contains(
            modelName.toLowerCase())) {
          result.add(_vessel);
        }
      }
    }
      return new VesselCatalogList(elements: result);
  }

  @override
  Future<NetworkServiceResponse<VesselCatalogListResponse>> getVesselCatalog() async {
    String? jsonString = await _loadVesselCatalogAsset();
    final jsonResponse = json.decode(jsonString!);
    VesselCatalogList vesselCatalogList = new VesselCatalogList.fromJson(jsonResponse);
    return NetworkServiceResponse(
        success: true,
        content: new VesselCatalogListResponse(data: vesselCatalogList)
    );
  }
}

