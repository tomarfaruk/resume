import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:resume_builder/config/strings.dart';
import 'package:resume_builder/controller/pdf_setting.dart';
import 'package:resume_builder/model/additional_info_model.dart';
import 'package:resume_builder/model/education_info_model.dart';
import 'package:resume_builder/model/personal_info_model.dart';

import 'get_storate_controller.dart';
import 'pdf_api.dart';
import 'signature_widget.dart';

class TemplateEleven {
  GetStateController getStateController = Get.find();
  PdfSetting pdfSetting = Get.find();

  late AdditionalInfoModel additionalInfoModel;
  late PersonalInfoModel personalInfoModel;
  List<CommonInfoModel> _educationList = [];
  List<CommonInfoModel> _experienceList = [];
  List<CommonInfoModel> _projectList = [];

  static const _headerSpace = 0.4;
  static const _afterheader = 0.2;
  String headerColor = '#009688';
  Font? ttf;

  TemplateEleven() {
    if (pdfSetting.color.value.isNotEmpty) {
      headerColor = pdfSetting.color.value;
    }

    additionalInfoModel = getStateController.additionalInfoModel;
    personalInfoModel = getStateController.personalInfoModel;
    _educationList = getStateController.educationList;
    _experienceList = getStateController.experienceList;
    _projectList = getStateController.projectList;
  }

  Future<File> generatePdf() async {
    final doc = Document(deflate: zlib.encode);

    final font = await rootBundle.load(pdfSetting.fontFamily.value);
    ttf = Font.ttf(font);

    final fontBold = await rootBundle.load(Strings.fontOpenSansBoldPath);
    final ttfBold = Font.ttf(fontBold);

    final fontItalic = await rootBundle.load(Strings.fontOpenSansItaliPath);
    final ttfItalic = Font.ttf(fontItalic);

    final fontBoldItalic =
        await rootBundle.load(Strings.fontOpenSansItaliBoldPath);
    final ttfBoldItalic = Font.ttf(fontBoldItalic);

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a3,
      theme: ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
        italic: ttfItalic,
        boldItalic: ttfBoldItalic,
      ),
      margin: const EdgeInsets.all(0),
    );

    doc.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (ctx) {
          return [
            Partitions(
              children: [
                Partition(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(right: 20),
                    color: PdfColor.fromHex(headerColor),
                    constraints: BoxConstraints(
                      minHeight: pageTheme.pageFormat.height,
                    ),
                    child: buildPdfHeader(),
                  ),
                ),
                Partition(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2 * PdfPageFormat.cm),
                        buildSummary(),
                        ...educationInfo('Education', _educationList),
                        ...educationInfo('Experience', _experienceList),
                        ...educationInfo('Project', _projectList),
                        Row(children: [
                          Expanded(
                            child: commonTemplate(
                                'Skills', additionalInfoModel.skills ?? ''),
                          ),
                          SizedBox(width: 1 * PdfPageFormat.cm),
                          Expanded(
                            child: commonTemplate('Languages',
                                additionalInfoModel.languages ?? ''),
                          )
                        ]),
                        commonTemplate(
                            'Interest', additionalInfoModel.interest ?? ''),
                        commonTemplate(
                            'References', additionalInfoModel.reference ?? ''),
                        commonTemplate(
                            'Awards', additionalInfoModel.awards ?? ''),
                        socialProfile(),
                        SignatureWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        // header: (ctx) => Text("hello omar faruk")
        // footer: (ctx) => buildEducation(bytes),
      ),
    );

    return PdfApi.saveDocument(
      name: 'resume.pdf',
      pdf: doc,
    );
  }

  Widget commonTemplate(String title, String text) {
    if (text.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        itemHeader(title),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        Text(text),
      ],
    );
  }

  Widget buildPdfHeader() {
    List<Widget> widgets = <Widget>[];

    String street = personalInfoModel.street ?? '';
    String country = personalInfoModel.country ?? '';
    String city = personalInfoModel.city ?? '';
    String birthday = personalInfoModel.birthdate ?? '';

    String address = '';

    if (street.isNotEmpty) address = '$street, ';
    if (address.isNotEmpty && city.isNotEmpty) {
      address += "\n$city, ";
    } else if (city.isNotEmpty) {
      address += '$city, ';
    }

    if (country.isNotEmpty) address += country;

    String fname = personalInfoModel.firstName ?? '';
    String lanme = personalInfoModel.lastName ?? '';
    String email = personalInfoModel.email ?? '';
    String phone = personalInfoModel.phone ?? '';

    final nameChild = Text('$fname\n$lanme',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 28, font: ttf, color: PdfColors.white));

    final phoneChild = UrlLink(
        child: Text(phone,
            textAlign: TextAlign.right,
            style: const TextStyle(color: PdfColors.white)),
        destination: 'tel:$phone');
    final emailChild = UrlLink(
        child: Text(email,
            textAlign: TextAlign.right,
            style: const TextStyle(color: PdfColors.white)),
        destination: 'mailto:$email');
    final addressChild = Text(address,
        textAlign: TextAlign.right,
        style: const TextStyle(color: PdfColors.white));
    final birthChild = Text(birthday,
        textAlign: TextAlign.right,
        style: const TextStyle(color: PdfColors.white));

    if (fname.isNotEmpty || lanme.isNotEmpty) widgets.add(nameChild);
    if (phone.isNotEmpty) {
      widgets.add(SizedBox(height: 0.5 * PdfPageFormat.cm));
      widgets.add(phoneChild);
    }
    if (email.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(emailChild);
    }
    if (birthday.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(birthChild);
    }
    if (address.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(addressChild);
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 2 * PdfPageFormat.cm),
          ...widgets,
        ]);
  }

  Widget buildSummary() {
    String summary = personalInfoModel.aboutYourself ?? '';
    if (summary.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerNoBorder('Summary'),
        SizedBox(height: _headerSpace * PdfPageFormat.cm),
        Paragraph(text: summary),
      ],
    );
  }

  Widget socialProfile() {
    List<Widget> widgets = [];

    String fb = additionalInfoModel.facebook ?? '';

    String linkedin = additionalInfoModel.linked ?? '';

    String blog = additionalInfoModel.blogsite ?? '';

    String twitter = additionalInfoModel.twitter ?? '';

    if (fb.isNotEmpty) {
      widgets.addAll(_singleLink('Facebook', fb));
    }
    if (linkedin.isNotEmpty) {
      widgets.addAll(_singleLink('LinkedIn', linkedin));
    }
    if (twitter.isNotEmpty) {
      widgets.addAll(_singleLink('Twitter', twitter));
    }
    if (blog.isNotEmpty) {
      widgets.addAll(_singleLink('Website', blog));
    }
    if (widgets.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        itemHeader('Profile'),
        SizedBox(height: _afterheader * PdfPageFormat.cm),
        ...widgets,
      ],
    );
  }

  List<Widget> _singleLink(String title, String url) {
    return [
      Text(title, style: const TextStyle(color: PdfColors.grey, fontSize: 18)),
      UrlLink(
          child: Text(url,
              style: const TextStyle(
                  // color: PdfColor.fromHex(headerColor),
                  decoration: TextDecoration.underline)),
          destination: url),
    ];
  }

  List<Widget> educationInfo(String title, List<CommonInfoModel> infoList) {
    List<Widget> widgets = [];
    if (infoList.isEmpty) return [Container()];

    for (int i = 0; i < infoList.length; i++) {
      if (0 == i) {
        widgets.add(Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            headerNoBorder(title),
            SizedBox(height: _afterheader * PdfPageFormat.cm),
            singleEducationInfo(infoList[i])
          ],
        ));
      } else {
        widgets.add(singleEducationInfo(infoList[i]));
      }
    }

    widgets.add(_divider());
    return widgets;
  }

  Widget _divider() => Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, style: BorderStyle.dashed)),
      );

  Widget singleEducationInfo(CommonInfoModel info) {
    List<Widget> widgets = [];

    String header = info.header ?? '';
    String title = info.title ?? '';
    String summary = info.summary ?? '';
    String start = info.startDate ?? '';
    String end = info.ednDate ?? '';

    if (header.isNotEmpty) {
      widgets.add(itemHeader(header));
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
    }
    if (start.isNotEmpty) {
      widgets.add(
          Text('$start-$end', style: const TextStyle(color: PdfColors.grey)));
      widgets.add(SizedBox(height: 01 * PdfPageFormat.mm));
    }
    if (title.isNotEmpty) {
      widgets.add(Text(title));
      widgets.add(SizedBox(height: 01 * PdfPageFormat.mm));
    }
    if (summary.isNotEmpty) {
      widgets.add(Paragraph(text: summary));
    }
    if (widgets.isNotEmpty) {
      widgets.add(SizedBox(height: 0.5 * PdfPageFormat.cm));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Text headerNoBorder(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        height: 1,
        color: PdfColor.fromHex(headerColor),
        fontWeight: FontWeight.bold,
        font: ttf,
      ),
    );
  }

  Text itemHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        height: 1,
        color: PdfColors.black,
        fontWeight: FontWeight.bold,
        font: ttf,
      ),
    );
  }
}
