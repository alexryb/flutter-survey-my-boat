import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surveymyboatpro/logic/bloc/credit_card_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/payment_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/payment_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/payment/payment_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BraintreeCreditCardPage extends PaymentPage {

  Function? onFinish;
  Survey? survey;
  Widget? parent;

  BraintreeCreditCardPage.Survey(title, {this.survey, this.onFinish, this.parent}) : super(title);

  @override
  State<StatefulWidget> createState() {
    return BraintreeCreditCardPageState(this.survey!);
  }

}

class BraintreeCreditCardPageState extends State<BraintreeCreditCardPage> {

  CreditCardBloc? _cardBloc;

  Survey? survey;

  bool? _inProgress;
  bool? _completed;

  PaymentBloc? _paymentBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  BraintreeCreditCardPageState(this.survey);
  
  var ccMask = new MaskTextInputFormatter(
      mask: "#### #### #### ####", filter: {"#": RegExp(r'[0-9]')});

  var expMask = new MaskTextInputFormatter(
      mask: "##/##", filter: {"#": RegExp(r'[0-9]')});

  Widget bodyData() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[creditCardWidget(), fillEntries()],
        ),
      );

  Widget creditCardWidget() {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height * 0.3,
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: UIData.kitGradients)),
              ),
              Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "assets/images/map.png",
                  fit: BoxFit.cover,
                ),
              ),
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? cardEntries()
                  : FittedBox(
                      child: cardEntries(),
                    ),
              Positioned(
                right: 10.0,
                top: 10.0,
                child: Icon(
                  FontAwesomeIcons.ccVisa,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 10.0,
                bottom: 10.0,
                child: StreamBuilder<String>(
                  stream: _cardBloc?.nameOutputStream,
                  initialData: "Your Name",
                  builder: (context, snapshot) => Text(
                        snapshot.data!.length > 0 ? snapshot.data! : "Your Name",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: UIData.ralewayFont,
                            fontSize: 20.0),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardEntries() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
                stream: _cardBloc?.ccOutputStream,
                initialData: "**** **** **** ****",
                builder: (context, snapshot) {
                  snapshot.data!.length > 0
                      ? ccMask.maskText(snapshot.data!)
                      : null;
                  return Text(
                    snapshot.data!.length > 0
                        ? snapshot.data!
                        : "**** **** **** ****",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<String>(
                    stream: _cardBloc?.expOutputStream,
                    initialData: "MM/YY",
                    builder: (context, snapshot) {
                      snapshot.data!.length > 0
                          ? expMask.maskText(snapshot.data!)
                          : null;
                      return ApplicationTitle(
                        titleTextColor: Colors.white,
                        title: "Expiry",
                        subtitle:
                            snapshot.data!.isNotEmpty ? snapshot.data : "MM/YY",
                      );
                    }),
                SizedBox(
                  width: 30.0,
                ),
                StreamBuilder<String>(
                    stream: _cardBloc?.cvvOutputStream,
                    initialData: "***",
                    builder: (context, snapshot) => ApplicationTitle(
                          titleTextColor: Colors.white,
                          title: "CVV",
                          subtitle:
                              snapshot.data!.length > 0 ? snapshot.data : "***",
                        )),
              ],
            ),
          ],
        ),
      );

  Widget fillEntries() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              inputFormatters: [ccMask],
              keyboardType: TextInputType.number,
              maxLength: 19,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => _cardBloc?.ccInputSink.add(ccMask.getMaskedText()),
              decoration: InputDecoration(
                  labelText: "Credit Card Number",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder()),
            ),
            TextField(
              inputFormatters: [expMask],
              keyboardType: TextInputType.number,
              maxLength: 5,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => _cardBloc?.expInputSink.add(expMask.getMaskedText()),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "MM/YY",
                  border: OutlineInputBorder()),
            ),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 3,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => _cardBloc?.cvvInputSink.add(out),
              decoration: InputDecoration(
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelText: "CVV",
                  border: OutlineInputBorder()),
            ),
            TextField(
              keyboardType: TextInputType.text,
              maxLength: 20,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => _cardBloc?.nameInputSink.add(out),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "Name on card",
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      );

  Widget floatingBar() => Ink(
        decoration: ShapeDecoration(
            shape: StadiumBorder(),
            gradient: LinearGradient(colors: UIData.kitGradients)),
        child: FloatingActionButton.extended(
          onPressed: () {
            _createPaymentRequest();
          },
          backgroundColor: Colors.transparent,
          icon: Icon(
            FontAwesomeIcons.creditCard,
            color: Colors.white,
          ),
          label: Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Credit Card"),
      ),
      body: bodyData(),
      floatingActionButton: floatingBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void initState() {
    super.initState();
    _inProgress = false;
    _completed = false;
    _cardBloc = CreditCardBloc();
    _paymentBloc = new PaymentBloc();
    _apiStreamSubscription =
        apiCallSubscription(_paymentBloc!.apiResult, context, widget: widget);
  }

  @override
  void dispose() {
    _paymentBloc?.dispose();
    _cardBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }

  _createPaymentRequest() async {
    Future.delayed(Duration.zero, () async {
      Payment payment = Payment.fromSurvey(survey!, provider: "BRAINTREE", paymentMethod: PaymentMethod.CREDIT_CARD.toString().split('.').last);
      if (!_inProgress! && !_completed!) {
        _inProgress = true;
        _paymentBloc?.createPayment(PaymentViewModel.Payment(paymentResult: payment));
        _paymentBloc?.payment.listen((payment) {
          if (_inProgress! && !_completed!) _payNow(payment);
        });
      }
    });
  }

  _payNow(Payment _payment) async {

    String? cardNumber = _cardBloc?.cardNumber!;
    String? expiry = _cardBloc?.expDate;
    String? cvv = _cardBloc?.cvv;
    String? nameOnCard = _cardBloc?.nameOnCard;

    final request = BraintreeCreditCardRequest(
      cardNumber: cardNumber!,
      expirationMonth: expiry!.substring(0, 2),
      expirationYear: expiry!.substring(3, 5),
      cvv: cvv!,
    );
    BraintreePaymentMethodNonce? result = await Braintree.tokenizeCreditCard(
      _payment.tokenKey!,
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
}
