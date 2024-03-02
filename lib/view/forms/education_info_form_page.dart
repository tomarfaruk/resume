import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';
import 'package:resume_builder/model/education_info_model.dart';
import 'package:resume_builder/widget/empty_state.dart';
import 'common_form/common_form.dart';

class EducationInfoFormPage extends StatefulWidget {
  const EducationInfoFormPage({Key? key}) : super(key: key);

  @override
  State<EducationInfoFormPage> createState() => _EducationInfoFormPageState();
}

class _EducationInfoFormPageState extends State<EducationInfoFormPage> {
  List<CommonForm> formList = [];

  GetStateController getStateController = Get.find();

  @override
  void initState() {
    super.initState();

    // getStateController.readEducationInfo();
    final infoData = getStateController.educationList;

    if (infoData.isNotEmpty) {
      for (var infoModel in infoData) {
        formList.add(
          CommonForm(
            key: GlobalKey(),
            headerhint: 'College/University',
            titlehint: 'Degree Title',
            infoModel: infoModel,
            onDelete: () => onDelete(infoModel),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: formList.isEmpty
            ? const EmptyState(message: 'Click on add button to include a new form')
            : SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 20, left: 10),
                    child: Row(
                      children: [
                        const Text('Educational Info',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(onPressed: onSave, icon: const Icon(Icons.check))
                      ],
                    ),
                  ),
                  ...formList
                ]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddForm,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    onSave();
    super.dispose();
  }

  ///on form user deleted
  void onDelete(CommonInfoModel user) {
    var find = formList.firstWhere((it) => it.infoModel == user);
    formList.removeAt(formList.indexOf(find));
    var data = formList.map((it) => it.infoModel).toList();
    getStateController.saveEducationInfo(data);

    chengeState();
  }

  void chengeState() {
    if (mounted) setState(() {});
  }

  ///on add form
  void onAddForm() {
    var educationInfoModel = CommonInfoModel();
    formList.add(
      CommonForm(
        key: GlobalKey(),
        headerhint: 'College/University',
        titlehint: 'Degree Title',
        infoModel: educationInfoModel,
        onDelete: () => onDelete(educationInfoModel),
      ),
    );
    chengeState();
  }

  ///on save forms
  void onSave() {
    if (formList.isNotEmpty) {
      for (var form in formList) {
        form.saveform();
      }
      var data = formList.map((it) => it.infoModel).toList();
      getStateController.saveEducationInfo(data);
    }
  }
}
