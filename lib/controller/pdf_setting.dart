import 'package:get/get.dart';
import 'package:resume_builder/config/strings.dart';

class PdfSetting extends GetxController {
  var color = ''.obs;
  var isSign = false.obs;
  var fontFamily = Strings.fontRobotoPath.obs;
  var headerFontSize = 18.0.obs;
  var subHeaderFontSize = 14.0.obs;

  void updateSign(bool? value) {
    if (value != null) isSign(value);
  }

  void updateFontFamily(String value) {
    fontFamily(value);
  }

  void updateColor(String value) {
    color.value = value;
  }
}
