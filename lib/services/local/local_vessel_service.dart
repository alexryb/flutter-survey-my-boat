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
    VesselCatalogList _result = await _getVesselCatalog(modelName);
    return NetworkServiceResponse(
        success: true,
        content: new VesselCatalogListResponse(data: _result)
    );
  }

  Future<String?> _loadVesselCatalogAsset() async {
    if (vesselCatalogJson == null) {
      vesselCatalogJson = await rootBundle.loadString('assets/data/vesselCatalog.json');
    }
    return vesselCatalogJson;
  }

  Future<VesselCatalogList> _getVesselCatalog(String modelName) async {
    List<VesselCatalog> _result = List.empty(growable: true);
    String? jsonString = await _loadVesselCatalogAsset();
    final jsonResponse = json.decode(jsonString!);
    VesselCatalogList _vesselCatalogList = new VesselCatalogList.fromJson(jsonResponse);
    if (modelName != null) {
      for (VesselCatalog _vessel in _vesselCatalogList.elements!) {
        if (_vessel.vesselDescription != null) {
          if (_vessel.vesselDescription!.toLowerCase().contains(
              modelName.toLowerCase())) {
            _result.add(_vessel);
          }
        }
      }
    }
    return new VesselCatalogList(elements: _result);
  }

  @override
  Future<NetworkServiceResponse<VesselCatalogListResponse>> getVesselCatalog() async {
    String? jsonString = await _loadVesselCatalogAsset();
    final jsonResponse = json.decode(jsonString!);
    VesselCatalogList _vesselCatalogList = new VesselCatalogList.fromJson(jsonResponse);
    return NetworkServiceResponse(
        success: true,
        content: new VesselCatalogListResponse(data: _vesselCatalogList)
    );
  }
}

