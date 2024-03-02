import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_builder/config/extension.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';
import 'package:resume_builder/model/personal_info_model.dart';
import 'package:resume_builder/utils/utils.dart';
import 'package:resume_builder/widget/input_decorator.dart';

class PersonalInfoFormPage extends StatefulWidget {
  const PersonalInfoFormPage({Key? key}) : super(key: key);
  @override
  State<PersonalInfoFormPage> createState() => _PersonalInfoFormPageState();
}

class _PersonalInfoFormPageState extends State<PersonalInfoFormPage> {
  final _fnameController = TextEditingController();

  final _lnameController = TextEditingController();

  final _phoneController = TextEditingController();

  final _emailController = TextEditingController();

  final _countryController = TextEditingController();

  final _cityController = TextEditingController();

  final _streetController = TextEditingController();

  final _birthController = TextEditingController();

  final _professionController = TextEditingController();

  final _aboutController = TextEditingController();

  GetStateController getStateController = Get.find();

  @override
  void initState() {
    super.initState();

    // getStateController.readPersonalInfo();
    final infoData = getStateController.personalInfoModel;

    _fnameController.text = infoData.firstName ?? '';
    _lnameController.text = infoData.lastName ?? '';
    _phoneController.text = infoData.phone ?? '';
    _emailController.text = infoData.email ?? '';
    _countryController.text = infoData.country ?? '';
    _cityController.text = infoData.city ?? '';
    _streetController.text = infoData.street ?? '';
    _birthController.text = infoData.birthdate ?? '';
    _professionController.text = infoData.profession ?? '';
    _aboutController.text = infoData.aboutYourself ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Row(
            children: [
              const Text(
                'Personal Info',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(onPressed: _submit, icon: const Icon(Icons.check))
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fnameController,
                  keyboardType: TextInputType.name,
                  decoration: CommonDecorator.inputDecorator('First Name'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _lnameController,
                  decoration: CommonDecorator.inputDecorator('Last Name'),
                ),
              ),
            ],
          ),
          SizedBox(height: kFieldSeparator),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: CommonDecorator.inputDecorator('Phone'),
          ),
          SizedBox(height: kFieldSeparator),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: CommonDecorator.inputDecorator('Email'),
          ),
          SizedBox(height: kFieldSeparator),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _countryController,
                  keyboardType: TextInputType.name,
                  decoration: CommonDecorator.inputDecorator('Country  '),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _cityController,
                  decoration: CommonDecorator.inputDecorator('City'),
                ),
              ),
            ],
          ),
          SizedBox(height: kFieldSeparator),
          TextFormField(
            keyboardType: TextInputType.streetAddress,
            controller: _streetController,
            decoration: CommonDecorator.inputDecorator('Street No/Name'),
          ),
          SizedBox(height: kFieldSeparator),
          TextFormField(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate();
            },
            keyboardType: TextInputType.datetime,
            controller: _birthController,
            decoration: CommonDecorator.inputDecorator('Date Of Birth'),
          ),
          SizedBox(height: kFieldSeparator),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: _professionController,
            decoration: CommonDecorator.inputDecorator('Profession'),
          ),
          SizedBox(height: kFieldSeparator),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            controller: _aboutController,
            decoration: CommonDecorator.inputDecorator('About Yourself'),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _submit();
  }

  Future<void> _submit() async {
    PersonalInfoModel model = PersonalInfoModel();
    model.firstName = _fnameController.text;
    model.lastName = _lnameController.text;
    model.phone = _phoneController.text;
    model.email = _emailController.text;
    model.country = _countryController.text;
    model.city = _cityController.text;
    model.birthdate = _birthController.text;
    model.profession = _professionController.text;
    model.aboutYourself = _aboutController.text;
    model.street = _streetController.text;

    getStateController.savePersonalInfo(model);
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthController.text = Utils.formatDate(picked);
      });
    }
  }
}
