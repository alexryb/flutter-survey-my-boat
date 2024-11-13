import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:surveymyboatpro/logic/bloc/payment_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/payment_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/payment/payment_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';

class BraintreePayPalPaymentPage extends PaymentPage {

  Function? onFinish;
  Survey? survey;
  Widget? parent;

  BraintreePayPalPaymentPage.Survey(title, {this.survey, this.onFinish, this.parent}) : super(title);

  @override
  State<StatefulWidget> createState() {
    return BraintreePayPalPaymentPageState(this.survey!);
  }

}

class BraintreePayPalPaymentPageState extends State<BraintreePayPalPaymentPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Survey? survey;

  bool? _inProgress;
  bool? _completed;

  PaymentBloc? _paymentBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  BraintreePayPalPaymentPageState(this.survey);

  _payNow(Payment _payment) async {
    final request = BraintreePayPalRequest(
        amount: '${_payment.amount}'
    );
    BraintreePaymentMethodNonce? result = await Braintree.requestPaypalNonce(
      _payment!.clientToken!,
      request,
    );
    print("Response of the payment $result");
    if (result != null) {
      _payment.paymentNonce = result.nonce;
      _paymentBloc?.checkoutPayment(PaymentViewModel.Payment(paymentResult: _payment));
      _paymentBloc?.checkout.listen((event) {
        print(event.toString());
        if (event.transactionNumber != null) {
          _inProgress = false;
          _completed = true;
          widget.onFinish!(event);
        } else {
          _inProgress = false;
          _completed = true;
          widget.onFinish!(event);
        }
      });
    } else {
      _inProgress = false;
      _completed = true;
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _inProgress = false;
    _completed = false;
    _paymentBloc = new PaymentBloc();
    _apiStreamSubscription =
        apiCallSubscription(_paymentBloc!.apiResult, context, widget: widget);

    Future.delayed(Duration.zero, () async {
      Payment payment = Payment.fromSurvey(survey!, provider: "BRAINTREE", paymentMethod: PaymentMethod.PAYPAL.toString().split('.').last);
      if (!_inProgress! && !_completed!) {
        _inProgress = true;
        _paymentBloc?.createPayment(PaymentViewModel.Payment(paymentResult: payment));
        _paymentBloc?.payment.listen((payment) {
          if (_inProgress! && !_completed!) _payNow(payment);
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return widget.parent!;
  }

  @override
  void dispose() {
    _paymentBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }

}
