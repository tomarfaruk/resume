import 'package:resume_builder/config/strings.dart';
import 'package:resume_builder/model/code_letter_model.dart';

import 'pdf_api.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class CoverLetterTemplate {
  CoverLetterModel coverLetterModel;
  CoverLetterTemplate({required this.coverLetterModel});
  Future<File> generatePdf() async {
    final doc = Document(deflate: zlib.encode);

    final font = await rootBundle.load(Strings.fontOpenSansPath);
    final ttf = Font.ttf(font);

    final fontBold = await rootBundle.load(Strings.fontOpenSansBoldPath);
    final ttfBold = Font.ttf(fontBold);

    final fontItalic = await rootBundle.load(Strings.fontOpenSansItaliPath);
    final ttfItalic = Font.ttf(fontItalic);

    final fontBoldItalic =
        await rootBundle.load(Strings.fontOpenSansItaliBoldPath);
    final ttfBoldItalic = Font.ttf(fontBoldItalic);

    final pageTheme = PageTheme(
        pageFormat: PdfPageFormat.a3,
        theme: ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
          italic: ttfItalic,
          boldItalic: ttfBoldItalic,
        ));

    doc.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (ctx) {
          return [
            Text(coverLetterModel.header ?? ''),
            SizedBox(height: 2 * PdfPageFormat.cm),
            Text(coverLetterModel.body ?? ''),
            SizedBox(height: 2 * PdfPageFormat.cm),
            Paragraph(text: coverLetterModel.footer ?? ''),
          ];
        },
      ),
    );
    return PdfApi.saveDocument(name: 'imagepdf.pdf', pdf: doc);
  }
}
