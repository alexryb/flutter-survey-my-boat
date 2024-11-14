import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surveymyboatpro/logic/bloc/report_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/report_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/report.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/ui/page/survey/preview_report_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';

class PreviewReportPageStateBase<T> extends State<PreviewReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  static Size? deviceSize;

  String? title = "Survey Report Preview";
  Surveyor? _surveyor;
  Survey? survey;
  Map<String, List<DropdownMenuItem<String>>>? codes;

  Report? _report;
  ReportBloc? _reportBloc;
  StorageBloc? _localStorageBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;
  PdfController? _pdfController;
  int? _actualPageNumber = 1, _allPagesCount = 0;

  bool? _surveyorLoad;
  bool? _reportLoad;

  Widget displayWidget = progressWithBackground();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  PreviewReportPageStateBase(this.title, this.survey, this.codes);

  Widget _pdfWidget() => Container(
    //width: deviceSize.width * 0.95,
    alignment: Alignment.center,
    margin: const EdgeInsets.only(bottom: 2.0 * pdf.PdfPageFormat.mm, left: 3.2 * pdf.PdfPageFormat.mm, right: 3.2 * pdf.PdfPageFormat.mm),
    padding: const EdgeInsets.only(bottom: 2.0 * pdf.PdfPageFormat.mm, left: 3.2 * pdf.PdfPageFormat.mm, right: 3.2 * pdf.PdfPageFormat.mm),
    child:
      PdfView(
        //documentLoader: Center(child: CircularProgressIndicator()),
        //pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController!,
        scrollDirection: Axis.vertical,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
            displayWidget = _previewReportBody();
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
            displayWidget = _previewReportBody();
          });
        },
    )
  );

  Widget _floatingDownloadBar() => Ink(
        decoration: ShapeDecoration(
            shape: StadiumBorder(),
            gradient: LinearGradient(colors: UIData.kitGradients)),
        child: FloatingActionButton.extended(
          onPressed: () {
            if(this.survey?.surveyor?.signature == null) {
              showPopup(context, _signReportWidget(), "Sign the Report",
                  callBack: _downloadReport, bottomOffset: 360);
            } else {
              _downloadReport();
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          backgroundColor: Colors.black87,
          icon: Icon(
            FontAwesomeIcons.download,
            color: Colors.white,
          ),
          label: Text(
            "Print / Save Report",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Widget notSupportedWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.sadTear,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(
              height: 40.0,
            ),
            ApplicationTitle(
              title: "Not Supported",
              subtitle:
                      "\nPreview not supported in WEB vertion.\n\n "
                      "      Please use the button below",
              titleTextColor: Colors.white,
            )
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    _surveyorLoad = this._surveyor != null;
    _reportLoad = kIsWeb || this._report != null;
    _reportBloc = new ReportBloc();
    _localStorageBloc = new StorageBloc();
    _signatureController.addListener(() => print('Signature changed'));
    _apiStreamSubscription =
        apiCallSubscription(_reportBloc!.apiResult, context, widget: widget);
    title = "Survey ${survey?.surveyNumber} Report";
    if(!_surveyorLoad!) _initSurveyor();
    if(!_reportLoad!) _initReport();
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _reportBloc?.dispose();
    _localStorageBloc?.dispose();
    _pdfController?.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  void _initSurveyor() async {
    if (this._surveyor == null) {
      await _localStorageBloc?.loadSurveyor().then((surveyor) {
        this._surveyor = surveyor;
        if(surveyor.signature != null) {
          this.survey?.surveyor?.signature = surveyor.signature;
        }
        setState(() => this._surveyorLoad = true);
        _gotoNextScreen();
            });
    }
  }

  void _initReport() async {
    if (this._report == null) {
      await _reportBloc?.previewReport(ReportViewModel.Survey(survey: survey));
      _reportBloc?.report.listen((report) {
        this._report = report;
        setState(() => this._reportLoad = true);
        _pdfController = PdfController(
          document: PdfDocument.openData(this._report!.content!),
        );
        _gotoNextScreen();
      });
    } else {
      setState(() => this._reportLoad = true);
      _pdfController = PdfController(
        document: PdfDocument.openData(this._report!.content!),
      );
      _gotoNextScreen();
    }
  }

  void _gotoNextScreen() {
    if(_surveyorLoad! && _reportLoad!) {
      setState(() => displayWidget = _previewReportBody());
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return new WillPopScope(onWillPop: () async => true, child: displayWidget);
  }

  Widget _previewReportBody() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(title!),
        backgroundColor: Colors.black,
        leading: new Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SurveyPage.Survey(survey: survey!, codes: codes!)));
            },
          );
        }),
        actions: <Widget>[
          Visibility(
            visible: !kIsWeb,
            child: IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () {
                _pdfController?.previousPage(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 100),
                );
              },
            ),
          ),
          Visibility(
            visible: !kIsWeb,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '$_actualPageNumber/$_allPagesCount',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Visibility(
            visible: !kIsWeb,
            child: IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                _pdfController?.nextPage(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 100),
                );
              },
            ),
          ),
        ],
      ),
      body: kIsWeb ? notSupportedWidget() : _pdfWidget(),
      backgroundColor: Colors.blueGrey,
      // bottomNavigationBar: feedbackBottomBar(context,
      //     label: "Print / Save Report",
      //     callBackAction: _downloadReport
      // ),
      bottomNavigationBar: _floatingDownloadBar(),
    );
  }

  _downloadReport() async {
    await _reportBloc?.downloadReport(ReportViewModel.Survey(survey: survey));
    _reportBloc?.download.listen((report) {
      Printing.layoutPdf(
        name: report.name!,
        // [onLayout] will be called multiple times
        // when the user changes the printer or printer settings
        onLayout: (pdf.PdfPageFormat format) => Future.value(report.content),
      );
    });
  }

  Widget _signReportWidget() => Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Signature(
              controller: _signatureController,
              height: 300,
              backgroundColor: Colors.black12,
            ),
            //OK AND CLEAR BUTTONS
            Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.blue,
                    onPressed: () async {
                      if (_signatureController.isNotEmpty) {
                        final Uint8List? data = await _signatureController.toPngBytes();
                        _saveSurveyorSignature(data!);
                        Navigator.pop(context);
                        this._downloadReport();
                      }
                    },
                  ),
                  //CLEAR CANVAS
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() => _signatureController.clear());
                    },
                  ),
                ],
              ),
            ),
          ]
      )
  );

  void _saveSurveyorSignature(Uint8List data) async {
    this.survey!.surveyor?.signature = data;
    this._surveyor!.signature = data;
    _localStorageBloc?.saveSurveyor(_surveyor!);
  }
}
