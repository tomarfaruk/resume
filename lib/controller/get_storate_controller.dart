import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resume_builder/config/strings.dart';
import 'package:resume_builder/model/additional_info_model.dart';
import 'package:resume_builder/model/education_info_model.dart';
import 'package:resume_builder/model/personal_info_model.dart';

class GetStateController extends GetxController {
  final appData = GetStorage();

  var sign = RxList<int>();
  var image = RxList<int>();

  final _additionalInfoModel = AdditionalInfoModel().obs;
  final _projectList = <CommonInfoModel>[].obs;
  final _experienceList = <CommonInfoModel>[].obs;
  final _personalInfo = PersonalInfoModel().obs;
  final _educationInfo = <CommonInfoModel>[].obs;

  List<CommonInfoModel> get projectList => _projectList;
  List<CommonInfoModel> get experienceList => _experienceList;
  List<CommonInfoModel> get educationList => _educationInfo;

  AdditionalInfoModel get additionalInfoModel => _additionalInfoModel.value;
  PersonalInfoModel get personalInfoModel => _personalInfo.value;

  void readSign() {
    var r = appData.read(Strings.signKey);
    if (r != null) {
      final d = <int>[];
      r.forEach((e) => d.add(e));
      sign(d);
    }
  }

  Future<void> readImage() async {
    var r = appData.read(Strings.image);
    if (r != null) {
      final d = <int>[];
      r.forEach((e) => d.add(e));
      image(d);
    }
  }

  Future<void> saveSignd(Uint8List data) async {
    appData.write(Strings.signKey, data);
    sign(data);
  }

  Future saveImage(File file) async {
    Uint8List data = file.readAsBytesSync();
    image(data);
    appData.write(Strings.image, data);
  }

  Future<void> saveAdditionalInfo(AdditionalInfoModel info) async {
    _additionalInfoModel(info);
    appData.write(Strings.additionalInfo, info.toJson());
  }

  void readAdditionalInfo() {
    var infodata = appData.read(Strings.additionalInfo);
    if (infodata != null) {
      _additionalInfoModel(AdditionalInfoModel.fromJson(infodata));
    }
  }

  Future<void> saveProjectInfo(List<CommonInfoModel> info) async {
    _projectList(info);

    final procesData = info.map((e) => e.toJson()).toList();

    appData.write(Strings.projectInfo, json.encode(procesData));
  }

  void readProjectInfo() {
    var infodata = appData.read(Strings.projectInfo);

    if (infodata != null) {
      final decodedInfo = json.decode(infodata) as List;

      final projList =
          decodedInfo.map((e) => CommonInfoModel.fromJson(e)).toList();
      _projectList(projList);
    }
  }

  Future<void> saveExperienceInfo(List<CommonInfoModel> info) async {
    _experienceList(info);

    final procesData = info.map((e) => e.toJson()).toList();

    appData.write(Strings.experienceInfo, json.encode(procesData));
  }

  void readExperienceInfo() {
    var infodata = appData.read(Strings.experienceInfo);

    if (infodata != null) {
      final decodedInfo = json.decode(infodata) as List;
      final projList =
          decodedInfo.map((e) => CommonInfoModel.fromJson(e)).toList();
      _experienceList(projList);
    }
  }

  Future<void> saveEducationInfo(List<CommonInfoModel> info) async {
    _educationInfo(info);

    final procesData = info.map((e) => e.toJson()).toList();

    appData.write(Strings.educationInfo, json.encode(procesData));
  }

  void readEducationInfo() {
    var infodata = appData.read(Strings.educationInfo);

    if (infodata != null) {
      final decodedInfo = json.decode(infodata) as List;
      final projList =
          decodedInfo.map((e) => CommonInfoModel.fromJson(e)).toList();
      _educationInfo(projList);
    }
  }

  Future<void> savePersonalInfo(PersonalInfoModel info) async {
    _personalInfo(info);

    final procesData = info.toJson();

    appData.write(Strings.personalInfo, json.encode(procesData));
  }

  void readPersonalInfo() {
    var infodata = appData.read(Strings.personalInfo);

    if (infodata != null) {
      final decodedInfo = json.decode(infodata);

      final personalInfo = PersonalInfoModel.fromJson(decodedInfo);
      _personalInfo(personalInfo);
    }
  }

  Future<void> saveCover(PersonalInfoModel info) async {
    _personalInfo(info);

    final procesData = info.toJson();

    appData.write(Strings.personalInfo, json.encode(procesData));
  }

  void readCover() {
    var infodata = appData.read(Strings.personalInfo);

    if (infodata != null) {
      final decodedInfo = json.decode(infodata);

      final personalInfo = PersonalInfoModel.fromJson(decodedInfo);
      _personalInfo(personalInfo);
    }
  }
}
