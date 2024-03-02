import 'dart:async';
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
// import 'package:http/http.dart' as http;

class TemplateThirteen {
  final _headerSpace = 0.4;
  String headerColor = '#faa2a2';
  Font? ttf;

  GetStateController getStateController = Get.find();
  PdfSetting pdfSetting = Get.find();

  late AdditionalInfoModel additionalInfoModel;
  late PersonalInfoModel personalInfoModel;
  late List<int> userImage;
  late List<int> userSign;
  List<CommonInfoModel> _educationList = [];
  List<CommonInfoModel> _experienceList = [];
  List<CommonInfoModel> _projectList = [];

  TemplateThirteen() {
    if (pdfSetting.color.value.isNotEmpty) {
      headerColor = pdfSetting.color.value;
    }

    additionalInfoModel = getStateController.additionalInfoModel;
    personalInfoModel = getStateController.personalInfoModel;
    _educationList = getStateController.educationList;
    _experienceList = getStateController.experienceList;
    _projectList = getStateController.projectList;
    userImage = getStateController.image;
    userSign = getStateController.sign;
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
                  flex: 4,
                  child: buildLeftSide(pageTheme),
                ),
                Partition(
                  flex: 6,
                  child: buildRightSide(),
                ),
              ],
            ),
            SignatureWidget(),
          ];
        },
      ),
    );

    return PdfApi.saveDocument(name: 'imagepdf.pdf', pdf: doc);
  }

  Widget buildPdfHeader() {
    String fname = personalInfoModel.firstName ?? '';
    String lanme = personalInfoModel.lastName ?? '';
    String profession = personalInfoModel.profession ?? '';

    Widget nameChild = Container();
    Widget professionChild = Container();

    if (fname.isNotEmpty || lanme.isNotEmpty) {
      nameChild = Text('$fname $lanme',
          style: TextStyle(fontSize: 50, font: ttf, color: PdfColors.black));
    }
    if (profession.isNotEmpty) {
      professionChild = Text(
        profession,
        style: const TextStyle(fontSize: 28, color: PdfColors.black),
      );
    }
    return Container(
      width: double.infinity,
      height: 350,
      color: PdfColor.fromHex(headerColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          nameChild,
          Container(
            height: 1,
            color: PdfColors.white,
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          professionChild
        ],
      ),
    );
  }

  Container buildRightSide() {
    return Container(
      padding: const EdgeInsets.only(right: 1 * PdfPageFormat.cm),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPdfHeader(),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildSummary(),
          ...educationInfo('Education', _educationList),
          ...educationInfo('Experience', _experienceList),
          ...educationInfo('Project', _projectList),
        ],
      ),
    );
  }

  Container buildLeftSide(PageTheme pageTheme) {
    Widget imageChild = Container(
      margin: const EdgeInsets.symmetric(vertical: 1 * PdfPageFormat.cm),
    );

    if (userImage.isNotEmpty) {
      imageChild = Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(Uint8List.fromList(userImage)),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        margin: const EdgeInsets.symmetric(vertical: 1 * PdfPageFormat.cm),
      );
    }

    return Container(
      margin: const EdgeInsets.only(right: 1 * PdfPageFormat.cm),
      padding: const EdgeInsets.only(
          left: 1 * PdfPageFormat.cm, right: 1 * PdfPageFormat.cm),
      color: PdfColor.fromHex(headerColor),
      constraints: BoxConstraints(minHeight: pageTheme.pageFormat.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageChild,
          buildContactMe(),
          SizedBox(height: 1 * PdfPageFormat.cm),
          headerWithBorder('Other Information'),
          commonTemplate('Skills', additionalInfoModel.skills ?? ''),
          commonTemplate('Interest', additionalInfoModel.interest ?? ''),
          commonTemplate('Languages', additionalInfoModel.languages ?? ''),
          commonTemplate('References', additionalInfoModel.reference ?? ''),
          commonTemplate('Awards', additionalInfoModel.awards ?? ''),
          socialProfile()
        ],
      ),
    );
  }

  Widget commonTemplate(String title, String text) {
    if (text.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.0 * PdfPageFormat.cm),
        headerNoBorder(title),
        Text(text),
      ],
    );
  }

  Widget buildContactMe() {
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

    String email = personalInfoModel.email ?? '';
    String phone = personalInfoModel.phone ?? '';

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

    if (phone.isNotEmpty) {
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

    if (widgets.isEmpty) return Container();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        headerWithBorder('Contact Me'),
        SizedBox(height: _headerSpace * PdfPageFormat.cm),
        ...widgets,
      ],
    );
  }

  Widget buildSummary() {
    String summary = personalInfoModel.aboutYourself ?? '';
    if (summary.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        headerWithBorder('Summary'),
        SizedBox(height: _headerSpace * PdfPageFormat.cm),
        Paragraph(text: summary),
      ],
    );
  }

  Widget socialProfile() {
    List<Widget> widgets = [SizedBox(height: 1 * PdfPageFormat.cm)];

    String fb = additionalInfoModel.facebook ?? '';

    String linkedin = additionalInfoModel.linked ?? '';

    String blog = additionalInfoModel.blogsite ?? '';

    String twitter = additionalInfoModel.twitter ?? '';

    if (fb.isNotEmpty) {
      widgets.add(_singleLink('Facebook', fb));
    }
    if (linkedin.isNotEmpty) {
      widgets.add(_singleLink('LinkedIn', linkedin));
    }
    if (twitter.isNotEmpty) {
      widgets.add(_singleLink('Twitter', twitter));
    }
    if (blog.isNotEmpty) {
      widgets.add(_singleLink('Website', blog));
    }
    if (widgets.length == 1) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _singleLink(String title, String url) => UrlLink(
        child: Text(
          url,
          style: const TextStyle(
              color: PdfColors.black, decoration: TextDecoration.underline),
        ),
        destination: url,
      );

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
            headerWithBorder(title),
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
      widgets.add(SizedBox(height: _headerSpace * PdfPageFormat.cm));
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget headerWithBorder(String text) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: PdfColor.fromHex('#807c7c'), width: 1.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          height: 1,
          color: PdfColor.fromHex('#807c7c'),
          fontWeight: FontWeight.bold,
          font: ttf,
        ),
      ),
    );
  }

  Text headerNoBorder(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        height: 1,
        color: PdfColor.fromHex('#807c7c'),
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
