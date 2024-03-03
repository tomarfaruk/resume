import 'package:flutter/material.dart';
import 'package:resume_builder/config/extension.dart';
import 'package:resume_builder/model/education_info_model.dart';
import 'package:resume_builder/utils/utils.dart';
import 'package:resume_builder/widget/input_decorator.dart';

typedef OnDelete = Function();

class CommonForm extends StatefulWidget {
  final CommonInfoModel infoModel;
  final state = _CommonFormState();
  final OnDelete onDelete;
  final String headerhint;
  final String titlehint;

  CommonForm({
    super.key,
    required this.infoModel,
    required this.onDelete,
    required this.headerhint,
    required this.titlehint,
  });
  @override
  // ignore: no_logic_in_create_state
  State<CommonForm> createState() => state;

  bool saveform() => state.formSave();
}

class _CommonFormState extends State<CommonForm> {
  final formKey = GlobalKey<FormState>();

  final _headerController = TextEditingController();
  final _titleController = TextEditingController();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _headerController.text = widget.infoModel.header ?? '';

    _titleController.text = widget.infoModel.title ?? '';
    _startYearController.text = widget.infoModel.startDate ?? '';
    _endYearController.text = widget.infoModel.ednDate ?? '';
    _summaryController.text = widget.infoModel.summary ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                height: 40,
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                width: double.infinity,
                child: InkWell(
                  onTap: widget.onDelete,
                  child: const Icon(Icons.delete, color: Colors.black),
                ),
              ),
              TextFormField(
                // onSaved: (value) => widget.infoModel.header = value ?? '',
                controller: _headerController,
                keyboardType: TextInputType.name,
                decoration: CommonDecorator.inputDecorator(widget.headerhint),
              ),
              SizedBox(height: kFieldSeparator),
              TextFormField(
                // onSaved: (value) => widget.infoModel.title = value ?? '',
                controller: _titleController,
                keyboardType: TextInputType.name,
                decoration: CommonDecorator.inputDecorator(widget.titlehint),
              ),
              SizedBox(height: kFieldSeparator),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // onSaved: (value) =>
                      //     widget.infoModel.startDate = value ?? '',
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectDate(0);
                      },
                      controller: _startYearController,
                      keyboardType: TextInputType.datetime,
                      decoration: CommonDecorator.inputDecorator('Start Dat'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      // onSaved: (value) =>
                      //     widget.infoModel.ednDate = value ?? '',
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectDate(1);
                      },
                      keyboardType: TextInputType.datetime,
                      controller: _endYearController,
                      decoration: CommonDecorator.inputDecorator('End Date'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kFieldSeparator),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                controller: _summaryController,
                decoration: CommonDecorator.inputDecorator('Summary'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///form validator
  bool formSave() {
    // var valid = formKey.currentState!.validate();
    // formKey.currentState!.save();
    widget.infoModel.summary = _summaryController.text;
    widget.infoModel.ednDate = _endYearController.text;
    widget.infoModel.startDate = _startYearController.text;
    widget.infoModel.title = _titleController.text;
    widget.infoModel.header = _headerController.text;

    return true;
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(int i) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (i == 0) {
          _startYearController.text = Utils.formatDate(picked);
        } else {
          _endYearController.text = Utils.formatDate(picked);
        }
      });
    }
  }
}
