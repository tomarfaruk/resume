import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'get_storate_controller.dart';
import 'pdf_setting.dart';

class SignatureWidget extends StatelessWidget {
  GetStateController getStateController = Get.find();
  PdfSetting pdfSetting = Get.find();

  @override
  Widget build(Context context) {
    List<int> userSign = getStateController.sign;
    if (pdfSetting.isSign.value && userSign.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 42),
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.7 * PdfPageFormat.cm),
            Image(MemoryImage(Uint8List.fromList(userSign)),
                height: 50, width: 100),
            SizedBox(height: 0.3 * PdfPageFormat.cm),
            Container(height: 1, color: PdfColors.black, width: 100),
            Text('Omar faruk')
          ],
        ),
      );
    }
    return Container();
  }
}
