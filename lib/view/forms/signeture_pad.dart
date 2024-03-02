import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:resume_builder/controller/get_storate_controller.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({Key? key}) : super(key: key);

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  GetStateController getStateController = Get.find();

  @override
  void initState() {
    super.initState();
    // getStateController.readSign();
  }

  Uint8List? uint8list;
  Widget image = Container();

  final control = HandSignatureControl(
    threshold: 0.10,
    smoothRatio: 0.65,
    velocityRange: 0.20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            _drawSign(),
            _buildBtns(),
            const SizedBox(height: 30),
            _signatureView(),
          ],
        ),
      ),
    );
  }

  Container _drawSign() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Center(
        child: AspectRatio(
          aspectRatio: 2.0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.4)),
            ),
            height: 200,
            child: Stack(
              children: <Widget>[
                Container(
                  constraints: const BoxConstraints.expand(),
                  color: Colors.white,
                  child: HandSignature(
                    control: control,
                    type: SignatureDrawType.shape,
                  ),
                ),
                CustomPaint(
                  painter: DebugSignaturePainterCP(
                    control: control,
                    cp: false,
                    cpStart: false,
                    cpEnd: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _signatureView() {
    if (getStateController.sign.isEmpty) return Container();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Center(
        child: Image.memory(
          Uint8List.fromList(getStateController.sign),
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Padding _buildBtns() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            onPressed: loadImagedata,
            child: const SizedBox(
              width: 100,
              height: 45,
              child: Center(child: Text('Save')),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffededed)),
            onPressed: () {
              control.clear();
              image = Container();
              setState(() {});
            },
            child: const SizedBox(
              width: 100,
              height: 45,
              child: Center(
                child: Text(
                  'Clear',
                  style: TextStyle(color: Color(0xff0e046a)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadImagedata() async {
    if (control.isFilled) {
      uint8list = (await control.toImage())!.buffer.asUint8List();
      getStateController.saveSignd(uint8list!);
    }
    setState(() {});
  }

  @override
  Future<void> dispose() async {
    super.dispose();

    if (control.isFilled) {
      uint8list = (await control.toImage())!.buffer.asUint8List();
      getStateController.saveSignd(uint8list!);
    }

    if (control.isFilled) control.clear();
  }
}
