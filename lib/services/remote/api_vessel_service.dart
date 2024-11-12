import 'dart:async';

import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_vessel_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class VesselService extends NetworkService implements IVesselService {
  static const _vesselCatalogUri = "/vesselsCatalog";

  @override
  Future<NetworkServiceResponse<VesselCatalogListResponse>> findCatalogVessel(String modelName) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.postRequest<VesselCatalogList>(restApiBaseUrl.toString(), _vesselCatalogUri, modelName);
    if (result?.mappedResult != null) {
      VesselCatalogList res = VesselCatalogList.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: new VesselCatalogListResponse(data: res),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<VesselCatalogListResponse>> getVesselCatalog() {
    // TODO: implement getVesselCatalog
    throw UnimplementedError();
  }
}
