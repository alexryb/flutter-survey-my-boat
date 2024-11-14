
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surveymyboatpro/logic/bloc/payment_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/report_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/payment_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/ui/page/payment/braintree_google_payment_page.dart';
import 'package:surveymyboatpro/ui/page/survey/preview_report_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';

class PaymentSelectPage extends StatefulWidget {
  Survey survey;
  Map<String, List<DropdownMenuItem<String>>> codes;

  String title = "Survey Report Payment";

  PaymentSelectPage.Survey(this.survey, this.codes);

  @override
  State<StatefulWidget> createState() {
    return PaymentSelectPageState(survey, codes);
  }
}

class PaymentSelectPageState extends State<PaymentSelectPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static Size? deviceSize;

  Survey? survey;
  Map<String, List<DropdownMenuItem<String>>>? codes;

  List<PaymentSelect>? _paymentChoice = List.empty(growable: true);
  Widget? displayWidget = progressWithBackground();

  PaymentBloc? _paymentBloc;
  ReportBloc? _reportBloc;
  StreamSubscription<FetchProcess>? _apiPaymentStreamSubscription;
  StreamSubscription<FetchProcess>? _apiReportStreamSubscription;

  PaymentSelectPageState(this.survey, this.codes);

  @override
  Widget build(BuildContext context) {
    { deviceSize = MediaQuery.of(context).size; }
    return body();
  }

  @override
  initState() {
    super.initState();
    _reportBloc = ReportBloc();
    _paymentBloc = new PaymentBloc();
    _apiPaymentStreamSubscription =
        apiCallSubscription(_paymentBloc!.apiResult, context, widget: widget);
    _apiReportStreamSubscription =
        apiCallSubscription(_reportBloc!.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  void dispose() {
    _apiReportStreamSubscription?.cancel();
    _apiPaymentStreamSubscription?.cancel();
    _reportBloc?.dispose();
    _paymentBloc?.dispose();
    super.dispose();
  }

  Widget body() {
    return displayWidget!;
  }

  void _gotoNextScreen() {
    if(_paymentChoice!.isEmpty) {
      _paymentBloc?.getPaymentSettings(new PaymentViewModel());
      _paymentBloc?.payment.listen((payment) {
        String paymentType = payment.paymentType!;
        List<String> paymentTypes = paymentType.split(",");
        for(String str in paymentTypes) {
          if("SUBSCRIBE" == str) {
            PaymentSelect subscribe = PaymentSelect(
              title: "Subscribe",
              paymentType: str,
              icon: Icons.wallet_membership,
              amount: "${(double.parse(payment.amount!) * 10).toStringAsFixed(2)}",
              currency: "${payment.currency}",
              description: "One year subscription",
            );
            _paymentChoice?.add(subscribe);
          }
          if("PAYNOW" == str) {
            PaymentSelect paynow = PaymentSelect(
              title: "Pay Now",
              paymentType: str,
              icon: Icons.wallet_giftcard,
              amount: "${payment.amount}",
              currency: "${payment.currency}",
              description: "${survey!.surveyNumber!} report",
            );
            _paymentChoice?.add(paynow);
          }
        }
        setState(() => displayWidget = _paymentsScaffold());
      });
    } else {
      setState(() => displayWidget = _paymentsScaffold());
    }
  }

  Widget _paymentsScaffold() => CommonScaffold(
    scaffoldKey: _scaffoldKey,
    appTitle: "Select Payment",
    showDrawer: false,
    showFAB: false,
    showBottomNav: false,
    backGroundColor: Colors.blueGrey,
    bodyWidget: _paymentsGrid(),
  );

  Widget _paymentsGrid() => GridView.count(
    crossAxisCount:
      MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
    shrinkWrap: true,
    mainAxisSpacing: 5.0,
    crossAxisSpacing: 5.0,
    childAspectRatio: 1.0,
    children: _paymentCardList(),
  );

  List<Widget> _paymentCardList() {
    List<Widget> _result = List.empty(growable: true);
    for (PaymentSelect p in this._paymentChoice!) {
      _result.add(
          Container (
            height: 500,
            child: _paymentSelectCard(p)
          )
      );
    }
    return _result;
  }

  Widget _paymentSelectCard(PaymentSelect _paymentSelect) {
    return Card(
      clipBehavior: Clip.antiAlias,
      semanticContainer: true,
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 5,
            left: 5,
            right: 5,
            bottom: 45,
            child: Container(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
              child: _paymentSelectTitle(_paymentSelect),
              color: Color(0xff0c2b20).withOpacity(1),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new BraintreeGooglePaymentPage.Survey(
                            "Google Pay / Credit Card / PayPal",
                            survey: survey,
                            parent: widget,
                            onFinish: (payment) async {
                              setState(() =>
                                  _paymentResultDialog(payment as Payment));
                            },
                            paymentType: _paymentSelect.paymentType,
                          )),
                );
              },
            )),
          ),
          Positioned(
            bottom: 5.0,
            left: 5.0,
            right: 5.0,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${_paymentSelect.title}',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Color(0xff0c2b20).withOpacity(1),),
                        textScaleFactor: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentSelectTitle(PaymentSelect _paymentSelect) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Amount\n\n\$${_paymentSelect.amount} ${_paymentSelect.currency}\n\n${_paymentSelect.description}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: deviceSize!.height / 40,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ))
    ],
  );

  _paymentResultDialog(Payment payment) {
    survey?.surveyStatus =
        "PAID" == payment.status ? SurveyStatus.Paid() : SurveyStatus.UnCompleted();
    var displayDate = DateTime.parse(new DateTime.now().toString());
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _paymentResultTicket(payment, displayDate),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.transparent,
                      icon: Icon(
                        FontAwesomeIcons.download,
                        color: Colors.white,
                      ),
                      label: Text(
                        "PAID" == payment.status ? "Download Page" : "Back to Survey",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if("PAID" == payment.status) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviewReportPage.Survey(survey!, codes!)));
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) => new SurveyPage.Survey(surveyGuid: survey!.surveyGuid!, survey: survey!, codes: codes!)
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  _paymentResultTicket(Payment payment, displayDate) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Visibility(
                  visible: "PAID" == payment.status,
                  child: ApplicationTitle(
                    title: "Thank You!",
                    titleTextColor: Colors.purple,
                    subtitle: "Your transaction was successful",
                  ),
                ),
                Visibility(
                  visible: "PAID" != payment.status,
                  child: ApplicationTitle(
                    title: "Transaction failed",
                    titleTextColor: Colors.red,
                    subtitle: "Please contact your payment provider",
                  ),
                ),
                ListTile(
                  title: Text("Date"),
                  subtitle: Text(
                      "${displayDate.month}/${displayDate.day}/${displayDate.year}"),
                  trailing: Text("${displayDate.hour}:${displayDate.minute}"),
                ),
                ListTile(
                  title: Text(survey!.surveyor!.fullname),
                  subtitle: Text(survey!.surveyor!.emailAddress!),
                  trailing: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: survey!.surveyor!.image()!.image,
                  ),
                ),
                ListTile(
                  title: Text("Amount"),
                  subtitle: Text("\$${payment.amount}"),
                  trailing: Text("${payment.status}"),
                ),
                Visibility(
                    visible: "PAID" == payment.status,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0.0,
                      color: Colors.grey.shade300,
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.paypal,
                          color: Colors.blue,
                        ),
                        title: Text("Order Number"),
                        subtitle: Text("${payment.transactionNumber}"),
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
}

class PaymentSelect {
  IconData icon;
  String paymentType;
  String title;
  String amount;
  String currency;
  String description;

  PaymentSelect({
    required this.icon,
    required this.paymentType,
    required this.title,
    required this.amount,
    required this.currency,
    required this.description,
  });
}