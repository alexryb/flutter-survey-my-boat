import 'dart:async';

import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class IVesselService {
  Future<NetworkServiceResponse<VesselCatalogListResponse>> findCatalogVessel(String modelName);
  Future<NetworkServiceResponse<VesselCatalogListResponse>> getVesselCatalog();
}
