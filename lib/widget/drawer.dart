import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resume_builder/config/strings.dart';
import 'package:resume_builder/controller/pdf_setting.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    PdfSetting pdfSetting = Get.find();

    return Drawer(
      child: Obx(() => ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: CheckboxListTile(
                      value: pdfSetting.isSign.value,
                      onChanged: (value) {
                        pdfSetting.isSign(value);
                      },
                      title: const Text('add signature'),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Font setting',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting.updateFontFamily(Strings.fontRobotoPath);
                  },
                  selected:
                      Strings.fontRobotoPath == pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontRobotoRegular),
                  ),
                  subtitle: const Text(Strings.fontRobotoRegular),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting.updateFontFamily(Strings.fontFiraSansPath);
                  },
                  selected:
                      Strings.fontFiraSansPath == pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontFiraSans),
                  ),
                  subtitle: const Text(Strings.fontFiraSans),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting.updateFontFamily(Strings.fontMontserratPath);
                  },
                  selected:
                      Strings.fontMontserratPath == pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontMontserrat),
                  ),
                  subtitle: const Text(Strings.fontMontserrat),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting.updateFontFamily(Strings.fontOpenSansPath);
                  },
                  selected:
                      Strings.fontOpenSansPath == pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontOpenSans),
                  ),
                  subtitle: const Text(Strings.fontOpenSans),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting.updateFontFamily(Strings.fontOpenSansItaliPath);
                  },
                  selected: Strings.fontOpenSansItaliPath ==
                      pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontOpenSansItalic),
                  ),
                  subtitle: const Text(Strings.fontOpenSansItalic),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting.updateFontFamily(Strings.fontOswaldPath);
                  },
                  selected:
                      Strings.fontOswaldPath == pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontOswald),
                  ),
                  subtitle: const Text(Strings.fontOswald),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    pdfSetting
                        .updateFontFamily(Strings.fontRobotoCondensedPath);
                  },
                  selected: Strings.fontRobotoCondensedPath ==
                      pdfSetting.fontFamily.value,
                  dense: true,
                  title: const Text(
                    'Press here to change the font family',
                    style: TextStyle(fontFamily: Strings.fontRobotoCondensed),
                  ),
                  subtitle: const Text(Strings.fontRobotoCondensed),
                ),
              ),
            ],
          )),
    );
  }
}
