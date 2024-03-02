import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:resume_builder/config/extension.dart';

import 'pdf_api.dart';

class CntcPdf {
  static Future<File> generateImagePdf() async {
    final doc = Document();

    ByteData bytes = await rootBundle.load('assets/location.png');

    const pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      // buildBackground: (Context context) => FullPage(
      //   ignoreMargins: true,
      //   child: Watermark.text('DRAFT'),
      // ),
      // buildForeground: (Context context) => Align(
      //   alignment: Alignment.bottomLeft,
      //   child: SizedBox(
      //     width: 100,
      //     height: 100,
      //     child: PdfLogo(),
      //   ),
      // ),
      // pageFormat: PdfPageFormat.a4,
      // margin: EdgeInsets.all(0),
    );

    doc.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (ctx) {
          return [
            // Container(
            //     height: PdfPageFormat.a4.availableHeight - 50,
            //     child: Stack(
            //       children: [
            //         Positioned(
            //           bottom: 0,
            //           right: 0,
            //           child: Image(
            //             MemoryImage(byteData!.buffer.asUint8List()),
            //             height: 40,
            //             width: 100,
            //           ),
            //         )
            //       ],
            //     )),
            Header(
              level: 0,
              text: 'Your Name',
              textStyle: const TextStyle(fontSize: 28),
              decoration: const BoxDecoration(),
              margin: EdgeInsets.zero,
            ),
            Text('Profession'),

            SizedBox(height: 0.5 * PdfPageFormat.cm),

            Row(
              children: [
                Container(
                  child: Image(MemoryImage(bytes.buffer.asUint8List()),
                      height: 28),
                ),
                SizedBox(width: 8),
                Text("Rajshahi, 54, 6000")
              ],
            ),
            SizedBox(height: 0.5 * PdfPageFormat.cm),

            Lorem(maxLines: 3),
            Row(
              children: [
                Container(
                  child: Image(MemoryImage(bytes.buffer.asUint8List()),
                      height: 28),
                ),
                Header(
                  level: 1,
                  text: 'Skills',
                  textStyle: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: kLeftindentation),
              child: Column(
                children: buildBulletPoints(),
              ),
            ),
            buildWorkDetails(bytes.buffer.asUint8List()),
            buildEducation(bytes),
          ];
        },
        // footer: (ctx) => buildEducation(bytes),
      ),
    );

    return PdfApi.saveDocument(name: 'imagepdf.pdf', pdf: doc);
  }

  static Widget buildWorkDetails(Uint8List bytes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomHeadline('Work History', bytes),
        buildSingleWork(),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildSingleWork(),
      ],
    );
  }

  static Row buildSingleWork() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("03/15 - Current"),
        SizedBox(width: 1 * PdfPageFormat.cm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerNoBorder("App Developer"),
              Text('Salah.software, inc. Sylhet, Bangladesh'),
              ...buildBulletPointsWithourMargin(),
            ],
          ),
        )
      ],
    );
  }

  static Column buildEducation(ByteData bytes) {
    return Column(
      children: [
        buildCustomHeadline('Education', bytes.buffer.asUint8List()),
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bachelor of arts: Business Administrator',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Paragraph(
                text: 'Daffodil International University',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildCustomHeadline(String text, Uint8List bytes) => Header(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(child: Image(MemoryImage(bytes), height: 28)),
            headerNoBorder(text)
          ],
        ),
        padding: const EdgeInsets.all(4),
        // decoration: BoxDecoration(color: PdfColors.red),
      );

  static Text headerNoBorder(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        height: 1,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static List<Widget> buildBulletPoints() => [
        Bullet(text: 'First Bullet'),
        Bullet(text: 'Second Bullet'),
        Bullet(text: 'Third Bullet'),
      ];
  static List<Widget> buildBulletPointsWithourMargin() => [
        Bullet(
          text:
              'We use cookies and similar tools that are necessary to enable you to make purchases.',
          bulletMargin: const EdgeInsets.only(
            top: 1.5 * PdfPageFormat.mm,
            left: 0.0 * PdfPageFormat.mm,
            right: 2.0 * PdfPageFormat.mm,
          ),
        ),
        Bullet(
          text:
              'We use cookies and similar tools that are necessary to enable you to make purchases.',
          bulletMargin: const EdgeInsets.only(
            top: 1.5 * PdfPageFormat.mm,
            left: 0.0 * PdfPageFormat.mm,
            right: 2.0 * PdfPageFormat.mm,
          ),
        ),
        Bullet(
          text:
              'We use cookies and similar tools that are necessary to enable you to make purchases.',
          bulletMargin: const EdgeInsets.only(
            top: 1.5 * PdfPageFormat.mm,
            left: 0.0 * PdfPageFormat.mm,
            right: 2.0 * PdfPageFormat.mm,
          ),
        ),
      ];
}
