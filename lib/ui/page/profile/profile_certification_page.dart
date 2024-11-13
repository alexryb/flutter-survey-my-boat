import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/surveyor_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/surveyor_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/surveyor_certificate.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';

class SurveyorCertificationPage extends StatefulWidget {
  Surveyor surveyor;

  SurveyorCertificationPage() {}

  SurveyorCertificationPage.withUser(Surveyor userData) {
    this.surveyor = userData;
    this.surveyor.inSync = false;
  }

  @override
  State<StatefulWidget> createState() {
    return new SurveyorCertificationPageState();
  }
}

class SurveyorCertificationPageState extends State<SurveyorCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static Size deviceSize;
  Widget displayWidget = progressWithBackground();

  SurveyorBloc _surveyorBloc;
  StreamSubscription<FetchProcess> _apiSurveyorStreamSubscription;

  Widget _certificatesBodyList(List<SurveyorCertificate> _certificates) =>
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: _certificatesCard(_certificates[index]),
          );
        }, childCount: _certificates.length),
      );

  Widget _certificatesCard(SurveyorCertificate _certificate) {
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
                child: _certificateColumn(_certificate),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: deviceSize.width * 0.6,
                  child: TextFormField(
                    maxLines: 1,
                    autofocus: true,
                    style: new TextStyle(
                        color: Colors.white, fontSize: deviceSize.height / 40),
                    decoration: InputDecoration(
                      hintText: "Certificate Number",
                      suffixIcon: Icon(Icons.insert_drive_file),
                  ),
                  initialValue: _certificate.certificateNumber,
                  onChanged: (un) => _certificate.certificateNumber = un,
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
                            color: Colors.white, fontSize: deviceSize.height / 50),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      );

  Widget _certificatesBody(List<SurveyorCertificate> _certificates) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey,
        drawer: CommonDrawer(),
        appBar: AppBar(
          title: Text("My Certrificates"),
          backgroundColor: Colors.black,
          // leading: new Builder(builder: (context) {
          //   return IconButton(
          //     icon: Icon(Icons.arrow_back),
          //     onPressed: () {
          //       _saveSurveyor();
          //     },
          //   );
          // }),
          brightness: Brightness.light,
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: [
            _certificatesBodyList(_certificates),
          ],
        ),
        bottomNavigationBar: feedbackBottomBar(context),
        floatingActionButton: _saveCertificationButton(),
      );

  Widget _saveCertificationButton() {
    return FloatingActionButton(
      child: new Icon(
        Icons.save_outlined,
        color: Colors.white,
      ),
      onPressed: () {
        _saveSurveyor();
      },
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );
  }

  void _gotoNextScreen() {
    if (widget.surveyor == null) {
      StorageBloc _localStorageBloc = new StorageBloc();
      _localStorageBloc.loadSurveyor().then((_surveyor) {
        if (_surveyor != null) {
          widget.surveyor = _surveyor;
          widget.surveyor.inSync = false;
          setState(() => displayWidget =
              _certificatesBody(this.widget.surveyor.certifications));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentityPage()));
        }
      });
    } else {
      setState(() => displayWidget = _certificatesBody(this.widget.surveyor.certifications));
    }
  }

  @override
  initState() {
    super.initState();
    _surveyorBloc = new SurveyorBloc();
    _apiSurveyorStreamSubscription =
        apiCallSubscription(_surveyorBloc.apiResult, context, widget: widget);
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
    return new WillPopScope(onWillPop: _saveSurveyor, child: displayWidget);
  }

  Future<bool> _saveSurveyor() {
    FocusScope.of(context).unfocus();
    _surveyorBloc.saveSurveyor(SurveyorViewModel.save(this.widget.surveyor));
    return new Future.value(true);
  }
}
