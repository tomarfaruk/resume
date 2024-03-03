import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';
import 'package:resume_builder/model/education_info_model.dart';
import 'package:resume_builder/widget/empty_state.dart';
import 'common_form/common_form.dart';

class ProjectInfoFormPage extends StatefulWidget {
  const ProjectInfoFormPage({super.key});

  @override
  State<ProjectInfoFormPage> createState() => _ProjectInfoFormPageState();
}

class _ProjectInfoFormPageState extends State<ProjectInfoFormPage> {
  List<CommonForm> formList = [];

  GetStateController getStateController = Get.find();

  @override
  void initState() {
    super.initState();

    // getStateController.readProjectInfo();
    final infoData = getStateController.projectList;

    if (infoData.isNotEmpty) {
      for (var infoModel in infoData) {
        formList.add(
          CommonForm(
            key: GlobalKey(),
            headerhint: 'Project name',
            titlehint: 'Project Title',
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
            ? const EmptyState(message: 'Add form by tapping add button below')
            : SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 20, left: 10),
                    child: Row(
                      children: [
                        const Text('Project Info',
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

  ///on form user deleted
  void onDelete(CommonInfoModel info) {
    var find = formList.firstWhere((it) => it.infoModel == info);
    formList.removeAt(formList.indexOf(find));

    var data = formList.map((it) => it.infoModel).toList();
    getStateController.saveProjectInfo(data);

    chengeState();
  }

  void chengeState() {
    if (mounted) setState(() {});
  }

  ///on add form
  void onAddForm() {
    var infoModel = CommonInfoModel();
    formList.add(
      CommonForm(
        key: GlobalKey(),
        headerhint: 'Project name',
        titlehint: 'Project Title',
        infoModel: infoModel,
        onDelete: () => onDelete(infoModel),
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
      getStateController.saveProjectInfo(data);
    }
  }

  @override
  void dispose() {
    super.dispose();
    onSave();
  }
}
