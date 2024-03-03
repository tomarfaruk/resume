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

class TemplateTen {
  GetStateController getStateController = Get.find();
  PdfSetting pdfSetting = Get.find();

  late AdditionalInfoModel additionalInfoModel;
  late PersonalInfoModel personalInfoModel;
  List<CommonInfoModel> _educationList = [];
  List<CommonInfoModel> _experienceList = [];
  List<CommonInfoModel> _projectList = [];

  String headerBgColor = '#404040';
  Font? ttf;

  TemplateTen() {
    if (pdfSetting.color.value.isNotEmpty) {
      headerBgColor = pdfSetting.color.value;
    }
    additionalInfoModel = getStateController.additionalInfoModel;
    personalInfoModel = getStateController.personalInfoModel;
    _educationList = getStateController.educationList;
    _experienceList = getStateController.experienceList;
    _projectList = getStateController.projectList;
  }

  Future<File> generatenPdf() async {
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
            buildHeader(),
            Container(
              margin: const EdgeInsets.all(42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  personalInfo(),
                  ...educationInfo('Education', _educationList),
                  ...educationInfo('Experience', _experienceList),
                  ...educationInfo('Project', _projectList),
                  commonTemplate('Skills', additionalInfoModel.skills ?? ''),
                  commonTemplate(
                      'Interest', additionalInfoModel.interest ?? ''),
                  commonTemplate(
                      'References', additionalInfoModel.reference ?? ''),
                  commonTemplate(
                      'Languages', additionalInfoModel.languages ?? ''),
                  commonTemplate('Awards', additionalInfoModel.awards ?? ''),
                  socialProfile(),
                ],
              ),
            ),
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

  Container buildHeader() {
    List<Widget> widgets = <Widget>[];

    String fname = personalInfoModel.firstName ?? '';
    String lanme = personalInfoModel.lastName ?? '';
    String email = personalInfoModel.email ?? '';
    String phone = personalInfoModel.phone ?? '';

    final nameChild = Text(
      '$fname $lanme',
      style: TextStyle(fontSize: 28, font: ttf, color: PdfColors.white),
    );

    final phoneChild = UrlLink(
        child: Text(phone, style: const TextStyle(color: PdfColors.white)),
        destination: 'tel:$phone');
    final emailChild = UrlLink(
        child: Text(email, style: const TextStyle(color: PdfColors.white)),
        destination: 'mailto:$email');

    if (fname.isNotEmpty || lanme.isNotEmpty) widgets.add(nameChild);
    if (phone.isNotEmpty) {
      widgets.add(SizedBox(height: 0.5 * PdfPageFormat.cm));
      widgets.add(phoneChild);
    }
    if (email.isNotEmpty) {
      widgets.add(SizedBox(height: 0.1 * PdfPageFormat.cm));
      widgets.add(emailChild);
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      height: 200,
      color: PdfColor.fromHex(headerBgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: headerNoBorder('Profile')),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        )
      ],
    );
  }

  List<Widget> _singleLink(String title, String url) {
    return [
      Text(title, style: const TextStyle(color: PdfColors.grey, fontSize: 18)),
      UrlLink(
        child: Text(
          url,
          style: const TextStyle(
              color: PdfColors.black, decoration: TextDecoration.underline),
        ),
        destination: url,
      ),
    ];
  }

  Widget personalInfo() {
    Widget addressChild = Container();
    Widget birthChild = Container();
    Widget summaryChild = Container();

    String street = personalInfoModel.street ?? '';
    String country = personalInfoModel.country ?? '';
    String city = personalInfoModel.city ?? '';
    String birthday = personalInfoModel.birthdate ?? '';
    String summary = personalInfoModel.aboutYourself ?? '';

    String address = '';

    if (street.isNotEmpty) address = '$street, ';
    if (city.isNotEmpty) address += '$city, ';
    if (country.isNotEmpty) address += country;

    if (address.isNotEmpty) {
      addressChild = Container(
        margin: const EdgeInsets.only(bottom: 01 * PdfPageFormat.mm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text('Address:',
                  style: const TextStyle(color: PdfColors.grey)),
            ),
            Expanded(flex: 3, child: Text(address))
          ],
        ),
      );
    }
    if (birthday.isNotEmpty) {
      birthChild = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text('Birth Date:',
                  style: const TextStyle(color: PdfColors.grey))),
          Expanded(flex: 3, child: Text(birthday)),
        ],
      );
    }
    if (summary.isNotEmpty) {
      summaryChild = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: const TextStyle(color: PdfColors.grey)),
          SizedBox(height: 01 * PdfPageFormat.mm),
          Paragraph(text: summary),
        ],
      );
    }
    if (birthday.isEmpty && address.isEmpty && summary.isEmpty) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: headerNoBorder('About Me')),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemHeader('Details Info'),
              SizedBox(height: 0.1 * PdfPageFormat.cm),
              addressChild,
              birthChild,
              summaryChild,
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 0.3 * PdfPageFormat.cm),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      style: BorderStyle.dashed,
                      color: PdfColor.fromHex(headerBgColor)),
                ),
              ),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> educationInfo(String title, List<CommonInfoModel> infoList) {
    List<Widget> widgets = [];
    if (infoList.isEmpty) return [Container()];

    for (int i = 0; i < infoList.length; i++) {
      if (0 == i) {
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: headerNoBorder(title)),
            Expanded(
              flex: 8,
              child: singleEducationInfo(infoList[i]),
            )
          ],
        ));
      } else {
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: headerNoBorder('')),
            Expanded(
              flex: 8,
              child: singleEducationInfo(infoList[i]),
            )
          ],
        ));
      }
    }

    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: headerNoBorder('')),
        Expanded(
          flex: 8,
          child: _divider(),
        )
      ],
    ));
    return widgets;
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.only(bottom: 1 * PdfPageFormat.cm),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              style: BorderStyle.dashed,
              color: PdfColor.fromHex(headerBgColor)),
        ),
      );

  Widget commonTemplate(String title, String text) {
    if (text.isEmpty) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: headerNoBorder(title)),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text),
              SizedBox(height: 0.5 * PdfPageFormat.cm),
              _divider(),
              SizedBox(height: 0.3 * PdfPageFormat.cm),
            ],
          ),
        )
      ],
    );
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

  Text headerNoBorder(String text) {
    return Text(
      text,
      style: TextStyle(
        color: PdfColor.fromHex(headerBgColor),
        fontSize: 24,
        height: 1,
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
        fontWeight: FontWeight.bold,
        font: ttf,
      ),
    );
  }
}
