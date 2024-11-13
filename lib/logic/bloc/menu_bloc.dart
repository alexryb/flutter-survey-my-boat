import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/menu_view_model.dart';
import 'package:surveymyboatpro/model/menu.dart';
import 'package:surveymyboatpro/model/surveyor.dart';

class MenuBloc {
  final _menuVM = MenuViewModel();
  final menuController = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => menuController.stream;

  MenuBloc(Surveyor userData) {
    if(userData.surveyorGuid!.isNotEmpty) {
      menuController.add(_menuVM.getMenuItems());
    } else {
      menuController.add(_menuVM.getAnonymusMenuItems());
    }
  }

  void dispose() {
    menuController?.close();
  }
}
