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

class TemplateFive {
  GetStateController getStateController = Get.find();

  PdfSetting pdfSetting = Get.find();

  late AdditionalInfoModel additionalInfoModel;
  late PersonalInfoModel personalInfoModel;
  List<CommonInfoModel> _educationList = [];
  List<CommonInfoModel> _experienceList = [];
  List<CommonInfoModel> _projectList = [];

  static const _headerSpace = 0.4;
  static const _afterheader = 0.2;
  String headerColor = '#053e72';
  Font? ttf;

  TemplateFive() {
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
      // buildBackground: (Context context) => FullPage(
      //   ignoreMargins: true,
      //   child: Watermark.text('DRAFT'),
      // ),
      // buildForeground: (Context context) => Align(
      //   alignment: Alignment.bottomLeft,
      //   child: SizedBox(
      //     width: 100,
      //     height: 100,
      //     child: PdfLogo(),
      //   ),
      // ),
      // pageFormat: PdfPageFormat.a4,
      // margin: EdgeInsets.all(0),
    );

    doc.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (ctx) {
          return [
            ...buildHeader(),
            SizedBox(height: 0.7 * PdfPageFormat.cm),
            buildSummary(),
            ...educationInfo('Education', _educationList),
            ...educationInfo('Experience', _experienceList),
            ...educationInfo('Project', _projectList),
            commonTemplate('Skills', additionalInfoModel.skills ?? ''),
            commonTemplate('Interest', additionalInfoModel.interest ?? ''),
            commonTemplate('References', additionalInfoModel.reference ?? ''),
            commonTemplate('Languages', additionalInfoModel.languages ?? ''),
            commonTemplate('Awards', additionalInfoModel.awards ?? ''),
            socialProfile(),
            SignatureWidget(),
          ];
        },
        // footer: (ctx) => buildEducation(bytes),
      ),
    );

    return PdfApi.saveDocument(
      name: 'resume.pdf',
      pdf: doc,
    );
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

  List<Widget> buildHeader() {
    List<Widget> widgets = <Widget>[];

    String street = personalInfoModel.street ?? '';
    String country = personalInfoModel.country ?? '';
    String city = personalInfoModel.city ?? '';
    String birthday = personalInfoModel.birthdate ?? '';

    String address = '';

    if (street.isNotEmpty) address = '$street, ';
    if (city.isNotEmpty) address += '$city, ';
    if (country.isNotEmpty) address += country;

    String fname = personalInfoModel.firstName ?? '';
    String lanme = personalInfoModel.lastName ?? '';
    String email = personalInfoModel.email ?? '';
    String phone = personalInfoModel.phone ?? '';

    final nameChild = RichText(
      text: TextSpan(
        text: '$fname ',
        style: TextStyle(
            fontSize: 28, font: ttf, color: PdfColor.fromHex(headerColor)),
        children: <TextSpan>[
          TextSpan(text: lanme, style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );

    final phoneChild = UrlLink(
        child: Text(phone, style: const TextStyle(color: PdfColors.black)),
        destination: 'tel:$phone');
    final emailChild = UrlLink(
        child: Text(email, style: const TextStyle(color: PdfColors.black)),
        destination: 'mailto:$email');
    final addressChild =
        Text(address, style: const TextStyle(color: PdfColors.black));
    final birthChild =
        Text(birthday, style: const TextStyle(color: PdfColors.black));

    if (fname.isNotEmpty || lanme.isNotEmpty) widgets.add(nameChild);
    if (phone.isNotEmpty) {
      widgets.add(SizedBox(height: 0.5 * PdfPageFormat.cm));
      widgets.add(phoneChild);
    }
    if (email.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(emailChild);
    }
    if (address.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(addressChild);
    }
    if (birthday.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(birthChild);
    }

    if (widgets.isNotEmpty) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(
              top: 0.5 * PdfPageFormat.cm, bottom: 0.7 * PdfPageFormat.cm),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  style: BorderStyle.dashed,
                  color: PdfColor.fromHex(headerColor))),
        ),
      );
    }

    return widgets;
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
        headerNoBorder('Profile'),
        Container(
            margin: const EdgeInsets.symmetric(
                vertical: _headerSpace * PdfPageFormat.cm),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  style: BorderStyle.dashed,
                  color: PdfColor.fromHex(headerColor)),
            )),
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
                  color: PdfColors.blue, decoration: TextDecoration.underline)),
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
            SizedBox(height: 0.7 * PdfPageFormat.cm),
            headerNoBorder(title),
            Container(
                margin: const EdgeInsets.symmetric(
                    vertical: _headerSpace * PdfPageFormat.cm),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      style: BorderStyle.dashed,
                      color: PdfColor.fromHex(headerColor)),
                )),
            SizedBox(height: _afterheader * PdfPageFormat.cm),
            singleEducationInfo(infoList[i])
          ],
        ));
      } else {
        widgets.add(singleEducationInfo(infoList[i]));
      }
    }

    // _widgets.add(_divider());
    return widgets;
  }

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

  Widget commonTemplate(String title, String text) {
    if (text.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerNoBorder(title),
        Container(
          margin: const EdgeInsets.symmetric(
              vertical: _headerSpace * PdfPageFormat.cm),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  style: BorderStyle.dashed,
                  color: PdfColor.fromHex(headerColor))),
        ),
        Text(text),
        SizedBox(height: 1 * PdfPageFormat.cm)
      ],
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
