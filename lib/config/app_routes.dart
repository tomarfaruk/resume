import 'package:get/get.dart';
import 'package:resume_builder/view/coverLetter/cover_letter_page.dart';
import 'package:resume_builder/view/forms/additional_info_form_page.dart';
import 'package:resume_builder/view/forms/education_info_form_page.dart';
import 'package:resume_builder/view/forms/experience_info_form_page.dart';
import 'package:resume_builder/view/forms/main_form.dart';
import 'package:resume_builder/view/forms/personal_info_form_page.dart';
import 'package:resume_builder/view/home_page.dart';
import 'package:resume_builder/view/preview_pdf_page.dart';

class AppRoutes {
  static const homePage = '/';
  static const personalInfoFormPage = '/personal_info_form_page';
  static const educationInfoFormPage = '/education_info_form_page';
  static const experienceInfoFormPage = '/experience_info_form_page';
  static const additionalInfoFormPage = '/additional_info_form_page';
  static const mainFormPage = '/main_form_page';
  static const previewPdfPage = '/preview_pdf_page';
  static const coverLetterPage = '/cover_letter_page';

  static const notFoundPage = '/notfound';

  static final routes = [
    GetPage(name: homePage, page: () => HomePage()),
    GetPage(
        name: educationInfoFormPage, page: () => const EducationInfoFormPage()),
    GetPage(
        name: personalInfoFormPage, page: () => const PersonalInfoFormPage()),
    GetPage(
        name: experienceInfoFormPage,
        page: () => const ExperienceInfoFormPage()),
    GetPage(
        name: additionalInfoFormPage,
        page: () => const AdditionalInfoFormPage()),
    GetPage(name: mainFormPage, page: () => const MainForm()),
    GetPage(name: previewPdfPage, page: () => const PreviewPdfPage()),
    GetPage(name: coverLetterPage, page: () => const CoverLetterPage()),
  ];
}
