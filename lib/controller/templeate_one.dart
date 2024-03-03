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

class TemplateOne {
  GetStateController getStateController = Get.find();

  PdfSetting pdfSetting = Get.find();

  late AdditionalInfoModel additionalInfoModel;
  late PersonalInfoModel personalInfoModel;
  List<CommonInfoModel> _educationList = [];
  List<CommonInfoModel> _experienceList = [];
  List<CommonInfoModel> _projectList = [];

  String mainColor = '#000000';
  Font? ttf;

  TemplateOne() {
    if (pdfSetting.color.value.isNotEmpty) {
      mainColor = pdfSetting.color.value;
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
    );

    doc.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (ctx) {
          return [
            ...buildHeader(),
            personalInfo(),
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

  List<Widget> buildHeader() {
    List<Widget> widgets = <Widget>[];

    String fname = personalInfoModel.firstName ?? '';
    String lanme = personalInfoModel.lastName ?? '';
    String email = personalInfoModel.email ?? '';
    String phone = personalInfoModel.phone ?? '';

    final nameChild = RichText(
      text: TextSpan(
        text: '$fname ',
        style: TextStyle(fontSize: 28, font: ttf),
        children: <TextSpan>[
          TextSpan(
            text: lanme,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: PdfColor.fromHex(mainColor)),
          )
        ],
      ),
    );

    final phoneChild = UrlLink(
        child: Text('Phone: $phone',
            style: const TextStyle(color: PdfColors.black)),
        destination: 'tel:$phone');
    final emailChild = UrlLink(
        child: Text('Email: $email',
            style: const TextStyle(color: PdfColors.black)),
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
    if (widgets.isNotEmpty) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(
              top: 0.5 * PdfPageFormat.cm, bottom: 0.7 * PdfPageFormat.cm),
          decoration: BoxDecoration(
            border: Border.all(width: 1, style: BorderStyle.dashed),
          ),
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
          child: Text(url,
              style: const TextStyle(
                  color: PdfColors.blue, decoration: TextDecoration.underline)),
          destination: url),
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
                  border: Border.all(width: 1, style: BorderStyle.dashed),
                ),
              ),
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
        margin: const EdgeInsets.only(bottom: 0.7 * PdfPageFormat.cm),
        decoration: BoxDecoration(
            border: Border.all(width: 1, style: BorderStyle.dashed)),
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
              _divider()
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

  Widget headerNoBorder(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        height: 1,
        color: PdfColor.fromHex(mainColor),
        fontWeight: FontWeight.bold,
        font: ttf,
      ),
    );
  }

  Widget itemHeader(String text) {
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

  List<Widget> buildBulletPoints() => [
        Bullet(text: 'First Bullet'),
        Bullet(text: 'Second Bullet'),
        Bullet(text: 'Third Bullet'),
      ];
  List<Widget> buildBulletPointsWithourMargin() => [
        Bullet(
          text:
              'We use cookies and similar tools that are necessary to enable you to make purchases.',
          bulletMargin: const EdgeInsets.only(
            top: 1.5 * PdfPageFormat.mm,
            left: 0.0 * PdfPageFormat.mm,
            right: 2.0 * PdfPageFormat.mm,
          ),
        ),
        Bullet(
          text:
              'We use cookies and similar tools that are necessary to enable you to make purchases.',
          bulletMargin: const EdgeInsets.only(
            top: 1.5 * PdfPageFormat.mm,
            left: 0.0 * PdfPageFormat.mm,
            right: 2.0 * PdfPageFormat.mm,
          ),
        ),
        Bullet(
          text:
              'We use cookies and similar tools that are necessary to enable you to make purchases.',
          bulletMargin: const EdgeInsets.only(
            top: 1.5 * PdfPageFormat.mm,
            left: 0.0 * PdfPageFormat.mm,
            right: 2.0 * PdfPageFormat.mm,
          ),
        ),
      ];
}
