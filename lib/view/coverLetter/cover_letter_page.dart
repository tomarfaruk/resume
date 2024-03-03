import 'package:flutter/material.dart';
import 'package:resume_builder/config/extension.dart';
import 'package:resume_builder/controller/cover_letter_controller.dart';
import 'package:resume_builder/controller/pdf_api.dart';
import 'package:resume_builder/model/code_letter_model.dart';
import 'package:resume_builder/widget/input_decorator.dart';
import 'package:resume_builder/widget/scale_animation_btn.dart';

class CoverLetterPage extends StatefulWidget {
  const CoverLetterPage({
    super.key,
    this.coverLetterModel,
  });

  final CoverLetterModel? coverLetterModel;

  @override
  State<CoverLetterPage> createState() => _CoverLetterPageState();
}

class _CoverLetterPageState extends State<CoverLetterPage> {
  final formKey = GlobalKey<FormState>();

  final _headerController = TextEditingController();
  final _bodyController = TextEditingController();
  final _footerController = TextEditingController();
  CoverLetterModel coverLetterModel = CoverLetterModel();
  @override
  void initState() {
    super.initState();
    if (widget.coverLetterModel != null) {
      coverLetterModel = widget.coverLetterModel!;

      _headerController.text = widget.coverLetterModel?.header ?? '';

      _bodyController.text = widget.coverLetterModel?.body ?? '';
      _footerController.text = widget.coverLetterModel?.footer ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover Letter'),
        actions: [
          ScaleAnimationBtn(
            onTap: () async {
              coverLetterModel.header = _headerController.text;
              coverLetterModel.body = _bodyController.text;
              coverLetterModel.footer = _footerController.text;

              final re = await CoverLetterTemplate(
                coverLetterModel: coverLetterModel,
              ).generatePdf();

              PdfApi.openFile(re.path);
              // Get.toNamed(AppRoutes.preview_pdf_page);
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              controller: _headerController,
              decoration: CommonDecorator.inputDecorator('Header'),
            ),
            SizedBox(height: kFieldSeparator),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              controller: _bodyController,
              decoration: CommonDecorator.inputDecorator('Body'),
            ),
            SizedBox(height: kFieldSeparator),
            TextFormField(
              controller: _footerController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              decoration: CommonDecorator.inputDecorator('Footer'),
            ),
            SizedBox(height: kFieldSeparator),
          ],
        ),
      ),
    );
  }
}
