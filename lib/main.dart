import 'dart:develope';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config/app_routes.dart';
import 'config/extension.dart';
import 'view/unknown_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Build Resume',
      enableLog: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColor),
      ),
      // logWriterCallback: localLogWriter,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      // home: MainForm(),
      initialRoute: AppRoutes.homePage,
      getPages: AppRoutes.routes,
      unknownRoute: GetPage(
        name: AppRoutes.notFoundPage,
        page: () => const UnknownRoutePage(),
      ),
      routingCallback: (routing) {
        if (routing == null) return;

        if (routing.current == '/second') {
          log('this is second page');
        }
      },
    );
  }
}
