import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:surveymyboatpro/model/checkpoint.dart';
import 'package:surveymyboatpro/model/checkpoint_attribute_value.dart';
import 'package:surveymyboatpro/model/checkpoint_fix_priority.dart';
import 'package:surveymyboatpro/model/checkpoint_image.dart';
import 'package:surveymyboatpro/model/checkpoint_status.dart';
import 'package:surveymyboatpro/model/report.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/surveyor_certificate.dart';
import 'package:surveymyboatpro/model/vessel.dart';
import 'package:surveymyboatpro/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class LocalReportPdfBuilder {

  Survey? survey;
  final Map<String, String> _criticalIssues = {};
  final Map<String, String> _majorIssues = {};
  final Map<String, String> _minorIssues = {};

  LocalReportPdfBuilder(this.survey);

  Future<Report> createPdfReport() async {
    Report result = new Report();
    result.reportGuid = StringUtils.generateGuid();
    result.surveyGuid = survey!.surveyGuid!;
    result.name = "Survey ${survey?.surveyNumber} Report";
    result.content = await generateDocument(PdfPageFormat.standard, survey!);
    return Future.value(result);
  }

  Uint8List getBoatImage(Vessel vessel) {
    if (vessel.hasImage()) {
      return vessel.images[0].content;
    }
    return Uint8List.fromList(List.empty(growable: false));
  }

  List<pw.Widget> getSurveyorCertificates(Surveyor surveyor) {
    List<pw.Widget> result = List.empty(growable: true);
    result.add(
      pw.SizedBox(
        height: 40,
      ),
    );
    for (SurveyorCertificate cert in surveyor.certifications) {
      final pw.Text txt = pw.Text(cert.description,
          textScaleFactor: 1, textAlign: pw.TextAlign.center);
      result.add(txt);
    }
      return result;
  }

  List<pw.Widget> getIssues(String label, String hexColor, Map map) {
    List<pw.Widget> result = List.empty(growable: true);
    if (map.isNotEmpty) {
      result.add(
        pw.SizedBox(
          height: 10,
        ),
      );
      result.add(
        pw.Text(label,
            textScaleFactor: 1.0,
            textAlign: pw.TextAlign.left,
            style: pw.TextStyle(
              color: PdfColor.fromHex(hexColor),
              fontWeight: pw.FontWeight.bold,
        )),
      );
      result.add(
        pw.SizedBox(
          height: 5,
        ),
      );
      for (String key in map.keys) {
        result.add(
          pw.Row(children: [
            pw.Container(
              alignment: pw.Alignment.topLeft,
              width: 150,
              child: pw.Text(key,
                  textScaleFactor: 1, textAlign: pw.TextAlign.left),
            ),
            pw.Container(
              alignment: pw.Alignment.topLeft,
              width: 320,
              child: pw.Text('${map[key]}',
                  textScaleFactor: 1, textAlign: pw.TextAlign.left),
            ),
          ]),
        );
        result.add(
          pw.SizedBox(
            height: 5,
          ),
        );
      }
    }
    return result;
  }

  List<pw.Widget> getCheckpointImages(
      pw.Document doc, List<CheckPointImage>? images) {
    List<pw.Widget> result = List.empty(growable: true);
    int count = images!.length > 3 ? 3 : images.length;
    result.add(
      pw.SizedBox(
        height: 10,
      ),
    );
    result.add(pw.Row(children: [
      pw.SizedBox(
        width: 5,
      ),
      count >= 1
          ? pw.Image(
              pw.MemoryImage(
                images[0].content!,
              ),
              width: 160,
              height: 120)
          : pw.SizedBox.shrink(),
      pw.SizedBox(
        width: 5,
      ),
      count >= 2
          ? pw.Image(
              pw.MemoryImage(
                images[1].content!,
              ),
              width: 160,
              height: 120)
          : pw.SizedBox.shrink(),
      pw.SizedBox(
        width: 5,
      ),
      count >= 3
          ? pw.Image(
              pw.MemoryImage(
                images[2].content!,
              ),
              width: 160,
              height: 120)
          : pw.SizedBox.shrink(),
      pw.SizedBox(
        width: 5,
      ),
    ]));
    result.add(
      pw.SizedBox(
        height: 20,
      ),
    );
    return result;
  }

  /// This method takes a page format and generates the Pdf file data
  Future<Uint8List> generateDocument(
      PdfPageFormat format, Survey survey) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    doc.addPage(getCoverPage(doc, survey));
    doc.addPage(getTitlePage(doc, survey));
    doc.addPage(getIntroPage(doc, survey));
    doc.addPage(getGenInfoPage(doc, survey));
    doc.addPage(getSystemsPage(doc, survey));
    if (CheckPointStatus.Completed() == survey.seaTrail?.status) {
      doc.addPage(getSeaTrialPage(doc, survey));
    }
    doc.addPage(getFindingsPage(doc, survey));
    doc.addPage(getValuationPage(doc, survey));

    Uint8List bytes = await doc.save();
    return Future.value(bytes);
  }

  getCoverPage(pw.Document doc, Survey survey) {
    pw.Widget boatImageWidget = pw.SizedBox.shrink();
    bool isPortrait = true;
    try {
      if (survey.vessel!.hasImage()) {
        pw.DecorationImage boatImage = pw.DecorationImage(
          fit: pw.BoxFit.fill,
          image: pw.MemoryImage(
            getBoatImage(survey.vessel!),
          ),
        );
        int imageWidth = boatImage.image.width!;
        int imageHeight = boatImage.image.height!;
        isPortrait = imageWidth < imageHeight;
        boatImageWidget = pw.Container(
          width: isPortrait
              ? PdfPageFormat.letter.width * 0.45
              : PdfPageFormat.letter.width * 0.65,
          height: isPortrait
              ? PdfPageFormat.letter.height * 0.50
              : PdfPageFormat.letter.height * 0.45,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            image: boatImage,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return pw.Page(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
      build: (pw.Context context) => pw.Header(
        level: 0,
        text: 'Survey Report Cover',
        child: pw.Center(
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(
                      survey.surveyor?.organization != null ? survey.surveyor!.organization.name : survey.surveyor!.fullname,
                      textScaleFactor: 3,
                      textAlign: pw.TextAlign.center),
                      pw.Container(
                        width: 350,
                        child: pw.Center(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10.0),
                            child: pw.Text(
                              survey.surveyor?.organization != null ? survey.surveyor!.organization.addressLine : survey.surveyor!.addressLine,
                                textScaleFactor: 1.5,
                                textAlign: pw.TextAlign.center
                            ),
                          ),
                        ),
                      ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Text(
                      survey.surveyor?.organization != null ? survey.surveyor!.organization.phoneNumber : survey.surveyor!.phoneNumber,
                      textScaleFactor: 1.5),
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.Text('${survey.vessel!.modelYear} ${survey.vessel!.model}',
                      textScaleFactor: 2.0),
                  pw.Text('"${survey.vessel?.name == null ? 'No Name' : survey.vessel!.name}"', textScaleFactor: 2.0),
                  pw.SizedBox(
                    height: isPortrait ? 30 : 50,
                  ),
                  boatImageWidget,
                  //pw.PdfLogo()
                ],
            ),
        ),
      ),
    );
  }

  getTitlePage(pw.Document doc, Survey survey) {
    return pw.Page(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
      build: (pw.Context context) => pw.Header(
        level: 1,
        text: 'Survey Report Title',
        child: pw.Center(
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
              pw.Text('${survey.title}',
                  textScaleFactor: 3, textAlign: pw.TextAlign.center),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text('${survey.surveyNumber}', textScaleFactor: 2.0),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text('of The Vessel', textScaleFactor: 1.5),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text('${survey.vessel?.modelYear} ${survey.vessel?.model}',
                  textScaleFactor: 2.0),
                  pw.Text('"${survey.vessel?.name ?? 'No Name'}"', textScaleFactor: 2.0),
              pw.SizedBox(
                height: 40,
              ),
              pw.Text('conducted by', textScaleFactor: 1.5),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text('${survey.surveyor?.fullname}', textScaleFactor: 1.5),
              pw.Column(
                children: getSurveyorCertificates(survey.surveyor!),
              ),
              pw.SizedBox(
                height: 40,
              ),
              pw.Text(
                  'Prepared exclusively for "${survey.client?.lastName}, ${survey.client?.firstName}"',
                  textScaleFactor: 1.2,
                  textAlign: pw.TextAlign.center),
              pw.Text(DateFormat('yyyy-MM-dd').format(new DateTime.now()),
                  textScaleFactor: 1.5, textAlign: pw.TextAlign.center),
              //pw.PdfLogo()
            ])),
      ),
    );
  }

  getIntroPage(pw.Document doc, Survey survey) {
    return pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.black))),
              child: pw.Text('I. INTRODUCTION',
                  textScaleFactor: 2.0, textAlign: pw.TextAlign.center));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('DESCRIPTION', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Wrap(children: [
                pw.Text("${survey.description}", textScaleFactor: 0.8),
              ]),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('SCOPE OF SURVEY', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Wrap(children: [
                pw.Text(
                    StringUtils.stringToParagraph(survey.getScopeOfSurvey()),
                    textScaleFactor: 0.8),
              ]),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('CONDUCT OF SURVEY', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Text('${survey.conductOfSurvey}', textScaleFactor: 0.8),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('DEFINITION OF TERMS', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Text('${survey.definitionOfTerms}', textScaleFactor: 0.8),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('VESSEL DESCRIPTION', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Text(
                  StringUtils.stringToParagraph(survey.vessel!.vesselDescription),
                  textScaleFactor: 0.8),
            ]);
  }

  getGenInfoPage(pw.Document doc, Survey survey) {
    return pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.black))),
              child: pw.Text('II. GENERAL INFORMATION',
                  textScaleFactor: 2.0, textAlign: pw.TextAlign.center));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.SizedBox(
                height: 10,
              ),
              pw.Wrap(children: [
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Type of the Vessel',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text(
                            '${survey.vessel?.vesselType.description}',
                            textScaleFactor: 1.2,
                            textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Name of Vessel',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.name}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Type of Survey',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.surveyType?.description}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Year/Make/Model',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text(
                            '${survey.vessel?.modelYear} ${survey.vessel?.model}',
                            textScaleFactor: 1.2,
                            textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Designer/Builder',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text(
                            '${survey.vessel?.vesselDesigner} ${survey.vessel?.getBuilder()}',
                            textScaleFactor: 1.2,
                            textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('H.I.N.',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.hin}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('HIN Location',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.hinLocation}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Home Port',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.homePort}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('License Number',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.licenseNumber}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Registry Number',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.registryNo}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Owner',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text(
                            '${survey.client?.lastName}, ${survey.client?.firstName}',
                            textScaleFactor: 1.2,
                            textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Owner Address',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.client?.addressLine}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Owner Identity Verified By',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.client?.identityVerifiedBy}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('L.O.A',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.getLoa()}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Beam',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.getBeam()}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Draft',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.getDraft()}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Displacement',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.getDisp()}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Ballast',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.getBallast()}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Place of Survey',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.placeOfSurvey}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Date of Survey',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.dateOfInspection}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('Intended Use',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 250,
                        child: pw.Text('${survey.vessel?.documentedUse}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
              ]),
            ]);
  }

  getSystemsPage(pw.Document doc, Survey survey) {
    return pw.MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.black))),
            child: pw.Text('III. SYSTEMS',
                textScaleFactor: 2.0, textAlign: pw.TextAlign.center));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => iterateCheckpointPages(
          doc, List.empty(growable: true), survey.checkPoints!),
    );
  }

  getSeaTrialPage(pw.Document doc, Survey survey) {
    return pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.black))),
              child: pw.Text('IV. SEA TRIAL',
                  textScaleFactor: 2.0, textAlign: pw.TextAlign.center));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.SizedBox(
                height: 10,
              ),
              pw.Wrap(children: [
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Date of Sea Trial',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text(
                            '${survey.seaTrail?.dateConducted.toString()}',
                            textScaleFactor: 1.2,
                            textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Weather Condition',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.weatherCondition}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Attended Persons',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.attendedPersons}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Engine Start Up',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.engineStartup}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Engine Controls',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text(
                            '${survey.seaTrail?.engineControlOperation}',
                            textScaleFactor: 1.2,
                            textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Engine Performance',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.enginePerformance}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Steering Test',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.steeringTest}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Vibration Noted',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.vibrations}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Vessel Load',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.vesselLoad}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
                pw.SizedBox(
                  height: 25,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text('Comments',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${survey.seaTrail?.comments}',
                            textScaleFactor: 1.2, textAlign: pw.TextAlign.left),
                      ),
                    ]),
              ]),
            ]);
  }

  getFindingsPage(pw.Document doc, Survey survey) {
    return pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.black))),
              child: pw.Text('V. FINDINGS AND RECOMMENDATIONS',
                  textScaleFactor: 2.0, textAlign: pw.TextAlign.center));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.SizedBox(
                height: 10,
              ),
              pw.Wrap(children: [
                pw.Text("${survey.recommendations}", textScaleFactor: 0.8),
              ]),
              pw.SizedBox(
                height: 5,
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children:
                    getIssues("Critical Issues", "FF0000", _criticalIssues),
              ),
              pw.Column(
                children: getIssues("Major Issues", "FFA000", _majorIssues),
              ),
              pw.Column(
                children: getIssues("Minor Issues", "A8B300", _minorIssues),
              ),
            ]);
  }

  getValuationPage(pw.Document doc, Survey survey) {
    return pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.black))),
              child: pw.Text('VI. SUMMARY AND VALUATION',
                  textScaleFactor: 2.0, textAlign: pw.TextAlign.center));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('VALUATION',
                  textScaleFactor: 1.2, textAlign: pw.TextAlign.center),
              pw.SizedBox(
                height: 5,
              ),
              pw.Wrap(children: [
                pw.Text(survey.getValuation(), textScaleFactor: 0.8),
              ]),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('SUMMARY', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Text(StringUtils.stringToParagraph(survey.getSummary()),
                  textScaleFactor: 0.8),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text('COMMENTS', textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Text('${(survey.comments)}', textScaleFactor: 0.8),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text("SURVEYOR'S CERTIFICATION", textScaleFactor: 1.2),
              pw.SizedBox(
                height: 5,
              ),
              pw.Text(
                  StringUtils.stringToParagraph(survey.surveyCertification!),
                  textScaleFactor: 0.8),
              pw.SizedBox(
                height: 50,
              ),
              pw.Text('Attending Surveyor: ${survey.surveyor?.fullname}',
                  textScaleFactor: 0.8),
              pw.SizedBox(
                height: 30,
              ),
              pw.Row(children: [
                pw.Text('SIGNATURE:', textScaleFactor: 0.8),
                pw.SizedBox(
                  width: 30,
                ),
                if (survey.surveyor?.signature != null)
                  pw.Image(
                      pw.MemoryImage(
                        survey.surveyor!.signature,
                      ),
                      width: 160,
                      height: 120)
              ]),
            ]);
  }

  List<pw.Widget> iterateCheckpointPages(
      pw.Document doc, List<pw.Widget> result, List<CheckPoint> checkPoints) {
    for (CheckPoint _cp in checkPoints) {
      if (CheckPointStatus.Completed() == _cp.status) {
        if (CheckPointFixPriority.Critical() == _cp.fixPriority) {
          _criticalIssues.putIfAbsent(_cp.name!, () => _cp.severityNotes!);
        }
        if (CheckPointFixPriority.Major() == _cp.fixPriority) {
          _majorIssues.putIfAbsent(_cp.name!, () => _cp.severityNotes!);
        }
        if (CheckPointFixPriority.Minor() == _cp.fixPriority) {
          _minorIssues.putIfAbsent(_cp.name!, () => _cp.severityNotes!);
        }
        result.add(
          pw.SizedBox(
            height: 5,
          ),
        );
        result.add(
          pw.Text('${_cp.name}',
              textScaleFactor: 1.2 + (_cp.hasChild ? 0.1 : 0),
              textAlign: pw.TextAlign.center),
        );
        result.add(
          pw.SizedBox(
            height: 5,
          ),
        );
        if (_cp.generalDescription != null && "" != _cp.generalDescription) {
          result.add(
            pw.Wrap(children: [
              pw.Text("${_cp.generalDescription}", textScaleFactor: 0.8),
            ]),
          );
          result.add(
            pw.SizedBox(
              height: 5,
            ),
          );
        }
        if (_cp.constructionMaterial != null &&
            "" != _cp.constructionMaterial) {
          result.add(
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 150,
                child: pw.Text('Construction Material',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 330,
                child: pw.Text('${_cp.constructionMaterial?.description}',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
            ]),
          );
        }
        if (_cp.condition != null && "" != _cp.condition) {
          result.add(
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 150,
                child: pw.Text('Condition',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 330,
                child: pw.Text('${_cp.condition?.description}',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
            ]),
          );
        }
        if (_cp.fixPriority != null &&
            CheckPointFixPriority.NoIssue() != _cp.fixPriority) {
          result.add(
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 150,
                child: pw.Text('${_cp.fixPriority?.description}',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 330,
                child: pw.Text(
                  '${_cp.severityNotes}',
                  textScaleFactor: 0.8,
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex(_cp.fixPriority ==
                            CheckPointFixPriority.Critical()
                        ? "FF0000"
                        : _cp.fixPriority == CheckPointFixPriority.Major()
                            ? "FFA000"
                            : _cp.fixPriority == CheckPointFixPriority.Minor()
                                ? "A8B300"
                                : "000000"),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ]),
          );
        }
        if (_cp.changesNoted != null && "" != _cp.changesNoted) {
          result.add(
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 150,
                child: pw.Text('Changes Noted',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
              pw.Container(
                alignment: pw.Alignment.topLeft,
                width: 330,
                child: pw.Text('${_cp.changesNoted}',
                    textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
              ),
            ]),
          );
        }
        if (_cp.attributeValues != null) {
          for (CheckPointAttributeValue _val in _cp.attributeValues!) {
            if (_val.value != null && "" != _val.value) {
              result.add(
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 150,
                        child: pw.Text(
                            '${_val.inspectAreaAttribute?.description}',
                            textScaleFactor: 0.8,
                            textAlign: pw.TextAlign.left),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        width: 330,
                        child: pw.Text('${_val.value}',
                            textScaleFactor: 0.8, textAlign: pw.TextAlign.left),
                      ),
                    ]),
              );
            }
          }
        }
        if (_cp.images != null && _cp.images!.isNotEmpty) {
          result.addAll(getCheckpointImages(doc, _cp.images));
        }
        if (_cp.children != null && _cp.children!.isNotEmpty) {
          iterateCheckpointPages(doc, result, _cp.children!);
        }
      }
    }
    return result;
  }
}
