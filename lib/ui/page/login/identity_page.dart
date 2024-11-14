import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page_state_base.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return kIsWeb ? IdentityPageStateWeb() : IdentityPageStateApp();
  }
}

class IdentityPageStateWeb extends IdentityPageStateBase<IdentityPage> {

}

class IdentityPageStateApp extends IdentityPageStateBase<IdentityPage> {

}
