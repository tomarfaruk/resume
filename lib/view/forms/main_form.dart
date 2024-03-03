import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_builder/config/app_routes.dart';
import 'package:resume_builder/config/extension.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';
import 'package:resume_builder/widget/scale_animation_btn.dart';

import 'additional_info_form_page.dart';
import 'education_info_form_page.dart';
import 'experience_info_form_page.dart';
import 'image_form.dart';
import 'personal_info_form_page.dart';
import 'project_info_form_page.dart';
import 'signeture_pad.dart';

class MainForm extends StatefulWidget {
  const MainForm({super.key});

  @override
  State<MainForm> createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  PageController controller = PageController();
  final List<Widget> _list = <Widget>[
    PersonalInfoFormPage(key: UniqueKey()),
    EducationInfoFormPage(key: UniqueKey()),
    ExperienceInfoFormPage(key: UniqueKey()),
    ProjectInfoFormPage(key: UniqueKey()),
    AdditionalInfoFormPage(key: UniqueKey()),
    ImageForm(key: UniqueKey()),
    SignaturePad(key: UniqueKey()),
  ];

  int _curr = 0;

  GetStateController getStateController = Get.put(GetStateController());

  @override
  void initState() {
    super.initState();
    getStateController.readPersonalInfo();
    0.delay().then((value) {
      getStateController.readEducationInfo();
      getStateController.readExperienceInfo();
      getStateController.readProjectInfo();

      getStateController.readAdditionalInfo();
      getStateController.readImage();
      getStateController.readSign();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Build Resume"),
        actions: [
          ScaleAnimationBtn(
            onTap: () async {
              // final path = await TemplateTen().generatenPdf();
              Get.toNamed(AppRoutes.previewPdfPage);
            },
          ),
        ],
      ),
      body: _pages(),
      bottomNavigationBar: infoList(),
    );
  }

  Widget _pages() => _list[_curr];

  Widget infoList() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 10,
      child: Container(
        height: 65,
        color: Colors.grey[200],
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(5),
          itemCount: _list.length,
          itemBuilder: (BuildContext ctx, int index) => _infoCard(index),
        ),
      ),
    );
  }

  Widget _infoCard(int index) {
    return Card(
      color: index == _curr ? primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: index == _curr ? primaryColor : Colors.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          _curr = index;
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              _getText(index),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: index == _curr ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getText(int i) {
    String s = '';
    switch (i) {
      case 0:
        s = 'Personal';
        break;
      case 1:
        s = 'Education';
        break;
      case 2:
        s = 'Experience';
        break;
      case 3:
        s = 'Project';
        break;
      case 4:
        s = 'Additional';
        break;
      case 5:
        s = 'Image';
        break;
      case 6:
        s = 'Signature';
        break;
      case 7:
        s = 'Other';
        break;
      default:
        s = 'Not Set';
    }
    return s;
  }
}
