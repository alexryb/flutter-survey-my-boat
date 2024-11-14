import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/surveyor_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/surveyor_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/surveyor_certificate.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';

class SurveyorCertificationPage extends StatefulWidget {
  Surveyor? surveyor;

  SurveyorCertificationPage({super.key});

  SurveyorCertificationPage.withUser(Surveyor userData, {super.key}) {
    surveyor = userData;
    surveyor?.inSync = false;
  }

  @override
  State<StatefulWidget> createState() {
    return new SurveyorCertificationPageState();
  }
}

class SurveyorCertificationPageState extends State<SurveyorCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static Size? deviceSize;
  Widget? displayWidget = progressWithBackground();

  SurveyorBloc? _surveyorBloc;
  StreamSubscription<FetchProcess>? _apiSurveyorStreamSubscription;

  Widget _certificatesBodyList(List<SurveyorCertificate> certificates) =>
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: _certificatesCard(certificates[index]),
          );
        }, childCount: certificates.length),
      );

  Widget _certificatesCard(SurveyorCertificate certificate) {
    return Container(
        color: Colors.yellow,
        child: Card(
          elevation: 2.0,
          color: Colors.teal,
          borderOnForeground: true,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _certificateColumn(certificate),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: deviceSize!.width * 0.6,
                  child: TextFormField(
                    maxLines: 1,
                    autofocus: true,
                    style: new TextStyle(
                        color: Colors.white, fontSize: deviceSize!.height / 40),
                    decoration: InputDecoration(
                      hintText: "Certificate Number",
                      suffixIcon: Icon(Icons.insert_drive_file),
                  ),
                  initialValue: certificate.certificateNumber,
                  onChanged: (un) => certificate.certificateNumber = un,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _certificateColumn(SurveyorCertificate surveyorCertificate) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text: '${surveyorCertificate.description}',
                        style: new TextStyle(
                            color: Colors.white, fontSize: deviceSize!.height / 50),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      );

  Widget _certificatesBody(List<SurveyorCertificate> certificates) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey,
        drawer: CommonDrawer(),
        appBar: AppBar(
          title: Text("My Certrificates"),
          backgroundColor: Colors.black, systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: [
            _certificatesBodyList(certificates),
          ],
        ),
        bottomNavigationBar: feedbackBottomBar(context, callBackAction: () {  }),
        floatingActionButton: _saveCertificationButton(),
      );

  Widget _saveCertificationButton() {
    return FloatingActionButton(
      onPressed: () {
        _saveSurveyor();
      },
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      child: new Icon(
        Icons.save_outlined,
        color: Colors.white,
      ),
    );
  }

  void _gotoNextScreen() {
    if (widget.surveyor == null) {
      StorageBloc localStorageBloc = new StorageBloc();
      localStorageBloc.loadSurveyor().then((surveyor) {
        widget.surveyor = surveyor;
        widget.surveyor?.inSync = false;
        setState(() => displayWidget =
            _certificatesBody(widget.surveyor!.certifications!));
            });
    } else {
      setState(() => displayWidget = _certificatesBody(widget.surveyor!.certifications!));
    }
  }

  @override
  initState() {
    super.initState();
    _surveyorBloc = new SurveyorBloc();
    _apiSurveyorStreamSubscription =
        apiCallSubscription(_surveyorBloc!.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  void dispose() {
    _surveyorBloc?.dispose();
    _apiSurveyorStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(onWillPop: _saveSurveyor, child: displayWidget!);
  }

  Future<bool> _saveSurveyor() {
    FocusScope.of(context).unfocus();
    _surveyorBloc?.saveSurveyor(SurveyorViewModel.save(widget.surveyor!));
    return new Future.value(true);
  }
}
