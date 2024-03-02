import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';

class ImageForm extends StatefulWidget {
  const ImageForm({Key? key}) : super(key: key);

  @override
  State<ImageForm> createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  File? file;

  GetStateController getStateController = Get.find();

  @override
  void initState() {
    super.initState();
    // getStateController.readImage();
  }

  @override
  void dispose() {
    super.dispose();

    if (file != null) getStateController.saveImage(file!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 10),
            child: Row(
              children: [
                const Text('Image',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (file != null) getStateController.saveImage(file!);
                  },
                  icon: const Icon(Icons.check),
                )
              ],
            ),
          ),
          const Spacer(),
          _imageView(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _imageView() {
    if (file != null) {
      return Center(
        child: InkWell(
          onTap: _pickFile,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:
                Image.file(file!, height: 200, width: 200, fit: BoxFit.cover),
          ),
        ),
      );
    }
    if (getStateController.image.isNotEmpty) {
      return Center(
        child: InkWell(
          onTap: _pickFile,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.memory(
              Uint8List.fromList(getStateController.image),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return Center(
      child: InkWell(
        onTap: _pickFile,
        child: SvgPicture.asset('assets/adduser.svg',
            height: 150, width: 150, fit: BoxFit.cover),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) file = File(result.files.single.path!);
    setState(() {});
  }
}
