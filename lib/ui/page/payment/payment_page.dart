
import 'package:flutter/material.dart';

abstract class PaymentPage extends StatefulWidget {

  PaymentPage(String? title, {super.key}) {
    _title = title;
  }

  String? _title;

  String? get title => _title;

  set title(String? value) {
    _title = value;
  }
}