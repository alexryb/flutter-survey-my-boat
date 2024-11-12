import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/vessel_catalog_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:rxdart/rxdart.dart';

class VesselCatalogBloc {
  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;

  final vesselCatalogController = StreamController<VesselCatalogList>();

  Stream<VesselCatalogList> get clients => vesselCatalogController.stream;

  Future<void> getVesselCatalog(VesselCatalogViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    apiController.add(process);
    process.type = ApiType.getVesselCatalog;

    await model.searchVesselCatalog();

    process.loading = false;
    process.response  = model.apiCallResult;
    apiController.add(process);
    vesselCatalogController.add(model.vesselCatalogListResult);
  }

  void dispose() {
    vesselCatalogController.close();
    apiController.close();
  }
}
