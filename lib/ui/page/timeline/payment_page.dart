import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/payment_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/payment_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return PaymentPageState();
  }
}

class PaymentPageState extends State<PaymentPage> {

  Surveyor? _surveyor;

  PaymentBloc? _paymentBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;
  Widget displayWidget = progressWithBackground();
  
  //column1
  Widget profileColumn(BuildContext context, Payment payment) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: new AssetImage(UIData.imbLogoIcon),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${payment.createDate} \tSurvey No. ${payment.surveyNumber} \n\n  Trans. No: ${payment.transactionNumber ?? "Not available due to error"}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ))
        ],
      );

  //post cards
  Widget _paymentCard(BuildContext context, Payment payment) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profileColumn(context, payment),
          ),
          amountColumn(payment),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget amountColumn(Payment payment) => FittedBox(
    fit: BoxFit.contain,
    child: OverflowBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              payment.paymentMethod!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: UIData.ralewayFont),
            ),
            SizedBox(width: 20),
            Text(
              'Amount: ${payment.amount} ${payment.currency}',
              style: TextStyle(fontFamily: UIData.ralewayFont, color: Colors.blueGrey, fontWeight: FontWeight.bold,),
            ),
            SizedBox(width: 20),
            Text(
              'Status: ${payment.transactionNumber == null ? "FAILED" : payment.status}',
              style: TextStyle(fontFamily: UIData.ralewayFont, color: payment.transactionNumber == null ? Colors.red : Colors.green),
            ),
          ],
        ),
      ],
    ),
  );

  //allposts dropdown
  Widget bottomBar() => PreferredSize(
      preferredSize: Size(double.infinity, 50.0),
      child: Container(
          color: Colors.black,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "All Payments",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          )));

  Widget _appBar() => SliverAppBar(
        backgroundColor: Colors.black,
        elevation: 2.0,
        title: Text("Payments History"),
        forceElevated: true,
        pinned: true,
        floating: true,
        //bottom: bottomBar(),
      );

  Widget _paymentBodyList(List<Payment> posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _paymentCard(context, posts[index]),
          );
        }, childCount: posts.length),
      );

  Widget _commonScaffold(List<Payment> payments) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      drawer: CommonDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          _appBar(),
          _paymentBodyList(payments),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: () async => false, child: displayWidget);
  }

  @override
  initState() {
    super.initState();
    _paymentBloc = PaymentBloc();
    _apiStreamSubscription =
        apiCallSubscription(_paymentBloc!.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _paymentBloc?.dispose();
    super.dispose();
  }

  void _gotoNextScreen() {
    if (_surveyor == null) {
      StorageBloc localStorageBloc = new StorageBloc();
      localStorageBloc.loadSurveyor().then((surveyor) {
        _surveyor = surveyor;
        _paymentBloc?.getPayments(new PaymentViewModel.Payment(surveyorGuid: _surveyor!.surveyorGuid!));
        _paymentBloc?.payments.listen((paymentList) {
          setState(() => displayWidget = _commonScaffold(paymentList.elements!));
        });
            });
      localStorageBloc.dispose();
    } else {
      _paymentBloc?.getPayments(new PaymentViewModel.Payment(surveyorGuid: _surveyor!.surveyorGuid!));
      _paymentBloc?.payments.listen((paymentList) {
        setState(() => displayWidget = _commonScaffold(paymentList.elements!));
      });
    }
  }
}
