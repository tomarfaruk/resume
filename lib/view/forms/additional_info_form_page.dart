import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_builder/config/extension.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';
import 'package:resume_builder/model/additional_info_model.dart';
import 'package:resume_builder/widget/input_decorator.dart';

class AdditionalInfoFormPage extends StatefulWidget {
  const AdditionalInfoFormPage({super.key});

  @override
  State<AdditionalInfoFormPage> createState() => _AdditionalInfoFormPageState();
}

class _AdditionalInfoFormPageState extends State<AdditionalInfoFormPage> {
  final _skillsController = TextEditingController();

  final _languagesController = TextEditingController();

  final _interestController = TextEditingController();

  final _linkedinController = TextEditingController();

  final _facebookController = TextEditingController();

  final _twitterController = TextEditingController();

  final _blogsiteController = TextEditingController();

  final _otherController = TextEditingController();

  final _referenceController = TextEditingController();

  final _awardsController = TextEditingController();

  double space = kFieldSeparator;

  GetStateController getStateController = Get.find();

  @override
  void initState() {
    super.initState();

    // getStateController.readAdditionalInfo();

    final infoData = getStateController.additionalInfoModel;

    _skillsController.text = infoData.skills ?? '';
    _languagesController.text = infoData.languages ?? '';
    _interestController.text = infoData.interest ?? '';
    _linkedinController.text = infoData.linked ?? '';
    _facebookController.text = infoData.facebook ?? '';
    _twitterController.text = infoData.twitter ?? '';
    _blogsiteController.text = infoData.blogsite ?? '';
    _otherController.text = infoData.other ?? '';
    _referenceController.text = infoData.reference ?? '';
    _awardsController.text = infoData.awards ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10),
              child: Row(
                children: [
                  const Text('Additional Info',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: _submit, icon: const Icon(Icons.check))
                ],
              ),
            ),
            TextFormField(
              controller: _skillsController,
              keyboardType: TextInputType.name,
              decoration:
                  CommonDecorator.inputDecorator('Skills Seperate By Comma'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _languagesController,
              keyboardType: TextInputType.name,
              decoration:
                  CommonDecorator.inputDecorator('Languages Seperate By Comma'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _interestController,
              keyboardType: TextInputType.name,
              decoration: CommonDecorator.inputDecorator('Interest'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _linkedinController,
              keyboardType: TextInputType.url,
              decoration:
                  CommonDecorator.inputDecorator('Linkedin Profile Link'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _facebookController,
              keyboardType: TextInputType.url,
              decoration:
                  CommonDecorator.inputDecorator('FaceBook Profile Link'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _twitterController,
              keyboardType: TextInputType.url,
              decoration:
                  CommonDecorator.inputDecorator('Twitter Profile Link'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _blogsiteController,
              keyboardType: TextInputType.url,
              decoration:
                  CommonDecorator.inputDecorator('Personal Bolg Site Link'),
            ),
            SizedBox(height: space),
            TextFormField(
              controller: _otherController,
              keyboardType: TextInputType.url,
              decoration: CommonDecorator.inputDecorator('Other'),
            ),
            SizedBox(height: space),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              controller: _referenceController,
              decoration: CommonDecorator.inputDecorator('Reference'),
            ),
            SizedBox(height: space),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              controller: _awardsController,
              decoration: CommonDecorator.inputDecorator('Awards'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    AdditionalInfoModel info = AdditionalInfoModel();
    info.skills = _skillsController.text;
    info.languages = _languagesController.text;
    info.interest = _interestController.text;
    info.linked = _linkedinController.text;
    info.facebook = _facebookController.text;
    info.twitter = _twitterController.text;
    info.blogsite = _blogsiteController.text;
    info.other = _otherController.text;
    info.reference = _referenceController.text;
    info.awards = _awardsController.text;

    getStateController.saveAdditionalInfo(info);
  }

  @override
  void dispose() {
    super.dispose();

    _submit();
  }
}
