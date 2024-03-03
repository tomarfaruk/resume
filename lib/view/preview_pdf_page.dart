import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resume_builder/config/strings.dart';
import 'package:resume_builder/controller/cntc_pdf.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';
import 'package:resume_builder/controller/pdf_setting.dart';
import 'package:resume_builder/controller/templeate_eleven.dart';
import 'package:resume_builder/controller/templeate_five.dart';
import 'package:resume_builder/controller/templeate_one.dart';
import 'package:resume_builder/controller/templeate_ten.dart';
import 'package:resume_builder/controller/templeate_thirteen.dart';
import 'package:resume_builder/controller/templeate_twelve.dart';
import 'package:resume_builder/controller/templeate_two.dart';
import 'package:resume_builder/utils/toast.dart';
import 'package:resume_builder/widget/circuler_btn.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewPdfPage extends StatefulWidget {
  const PreviewPdfPage({super.key});

  @override
  State<PreviewPdfPage> createState() => _PreviewPdfPageState();
}

class _PreviewPdfPageState extends State<PreviewPdfPage> {
  GetStateController getStateController = Get.find();
  PdfSetting pdfSetting = Get.put(PdfSetting());

  final _colorList = [
    '#808080',
    '#0000FF',
    '#00FFFF',
    '#008000',
    '#FFFF00',
    '#FFA500',
    '#FF0000',
    '#800080',
  ];

  @override
  void initState() {
    super.initState();

    // 1.delay().then((value) {
    //   getStateController.readPersonalInfo();
    //   getStateController.readEducationInfo();
    //   getStateController.readExperienceInfo();
    //   getStateController.readProjectInfo();
    //   getStateController.readProjectInfo();
    //   getStateController.readAdditionalInfo();
    //   getStateController.readImage();
    //   getStateController.readSign();
    // });
    // pdfPath = File(Get.arguments);
    _loadpdf();
  }

  _loadpdf() async {
    _isLoading = true;
    setState(() {});

    await _buildPdf();

    _isLoading = false;
    setState(() {});
  }

  late File pdfPath;

  bool _isLoading = true;
  int pdfIndex = 0;

  int indexPage = 0;

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    pickerColor = color;
  }

  Future<void> pickColor() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              InkWell(
                child: const Text('Got it'),
                onTap: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: Obx(() => ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        _loadpdf();
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: CheckboxListTile(
                        value: pdfSetting.isSign.value,
                        onChanged: (value) {
                          pdfSetting.isSign(value);
                        },
                        title: const Text('add signature'),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Font setting',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting.updateFontFamily(Strings.fontRobotoPath);
                    },
                    selected:
                        Strings.fontRobotoPath == pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontRobotoRegular),
                    ),
                    subtitle: const Text(Strings.fontRobotoRegular),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting.updateFontFamily(Strings.fontFiraSansPath);
                    },
                    selected:
                        Strings.fontFiraSansPath == pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontFiraSans),
                    ),
                    subtitle: const Text(Strings.fontFiraSans),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting.updateFontFamily(Strings.fontMontserratPath);
                    },
                    selected: Strings.fontMontserratPath ==
                        pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontMontserrat),
                    ),
                    subtitle: const Text(Strings.fontMontserrat),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting.updateFontFamily(Strings.fontOpenSansPath);
                    },
                    selected:
                        Strings.fontOpenSansPath == pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontOpenSans),
                    ),
                    subtitle: const Text(Strings.fontOpenSans),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting
                          .updateFontFamily(Strings.fontOpenSansItaliPath);
                    },
                    selected: Strings.fontOpenSansItaliPath ==
                        pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontOpenSansItalic),
                    ),
                    subtitle: const Text(Strings.fontOpenSansItalic),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting.updateFontFamily(Strings.fontOswaldPath);
                    },
                    selected:
                        Strings.fontOswaldPath == pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontOswald),
                    ),
                    subtitle: const Text(Strings.fontOswald),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      pdfSetting
                          .updateFontFamily(Strings.fontRobotoCondensedPath);
                    },
                    selected: Strings.fontRobotoCondensedPath ==
                        pdfSetting.fontFamily.value,
                    dense: true,
                    title: const Text(
                      'Press here to change the font family',
                      style: TextStyle(fontFamily: Strings.fontRobotoCondensed),
                    ),
                    subtitle: const Text(Strings.fontRobotoCondensed),
                  ),
                ),
              ],
            )),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            previewList(),
            _buildPdfView(),
            _buildFooter(),
            _buildSetting(),
          ],
        ),
      ),
    );
  }

  Positioned _buildSetting() {
    return Positioned(
      top: 150,
      right: 15,
      child: CirculerBtn(
        onTap: () {
          _scaffoldkey.currentState?.openEndDrawer();
        },
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }

  Positioned _buildPdfView() {
    return Positioned(
      top: 100,
      bottom: 0,
      left: 0,
      right: 0,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: SfPdfViewer.file(pdfPath),
            ),
    );
  }

  Positioned _buildFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CirculerBtn(
                  onTap: Get.back,
                  child: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
                CirculerBtn(
                  onTap: () async {
                    final status = await Permission.storage.request();
                    if (status == PermissionStatus.granted) {
                      pdfPath.copySync(await getPatFolderPath(pdfIndex));
                      myToast('PDF has been Saved ${Strings.appFolder}');
                    }
                  },
                  child: const Icon(Icons.download, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _getColorWidget(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getColorWidget() {
    List<Widget> widgets = [];
    widgets = List.generate(
        _colorList.length, (index) => _buildColorCard(_colorList[index]));

    final middleChild = Material(
      elevation: 20,
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await pickColor();
          String colorString = pickerColor.toString();
          var hexCode = colorString.split('(0x')[1].split(')')[0];
          hexCode = hexCode.substring(2, hexCode.length);
          pdfSetting.updateColor(hexCode);
          _loadpdf();
        },
        child: Image.asset('assets/radiuscolor.png', height: 30, width: 30),
      ),
    );

    widgets.insert(4, middleChild);

    return widgets;
  }

  Material _buildColorCard(String color) {
    return Material(
      elevation: 10,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          pdfSetting.updateColor(color);
          _loadpdf();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: HexColor(color)),
        ),
      ),
    );
  }

  Widget previewList() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        color: Colors.grey[200],
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            7,
            (index) => InkWell(
              onTap: () async {
                pdfIndex = index;
                pdfSetting.color('');
                await _loadpdf();
              },
              child: Card(
                child: Image.asset('assets/preview_layout/$index.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _buildPdf() async {
    try {
      if (0 == pdfIndex) {
        pdfPath = await TemplateOne().generatePdf();
      } else if (1 == pdfIndex) {
        pdfPath = await TemplateTwo().generatePdf();
      } else if (2 == pdfIndex) {
        pdfPath = await TemplateFive().generatePdf();
      } else if (3 == pdfIndex) {
        pdfPath = await TemplateTen().generatenPdf();
      } else if (4 == pdfIndex) {
        pdfPath = await TemplateEleven().generatePdf();
      } else if (5 == pdfIndex) {
        pdfPath = await TemplateTwelve().generatePdf();
      } else if (6 == pdfIndex) {
        pdfPath = await TemplateThirteen().generatePdf();
      } else {
        pdfPath = await CntcPdf.generateImagePdf();
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Please try again',
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

Future<String> getPatFolderPath(int i) async {
  var knockDir = await Directory(Strings.appFolder).create(recursive: true);

  String outpath =
      '${knockDir.path}/${i}_${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';

  return outpath;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
// https://www.w3schools.com/colors/colors_groups.asp