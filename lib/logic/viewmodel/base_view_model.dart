import 'package:surveymyboatpro/di/dependency_injection.dart';

class BaseViewModel {

  final Flavor _flavor = Flavor.LOCAL;

  Future<Flavor> get flavor async {
    return _flavor;
  }

}