import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_vessel_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class VesselCatalogViewModel extends BaseViewModel {

  String? modelName ;
  VesselCatalogList? vesselCatalogListResult;
  NetworkServiceResponse? apiCallResult;

  VesselCatalogViewModel.search({this.modelName});

  Future<Null> searchVesselCatalog() async {
    IVesselService vesselService = await new Injector(Flavor.LOCAL).vesselService;
    NetworkServiceResponse<VesselCatalogListResponse> result;
    if(modelName != null) {
      result = await vesselService.findCatalogVessel(modelName!);
    } else {
      result = await vesselService.getVesselCatalog();
    }
    apiCallResult = result;
    if(result.content != null) vesselCatalogListResult = result.content!.data;
  }
}
