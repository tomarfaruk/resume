import 'dart:developer';
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    log(directory.path, name: 'directory');
    final filePath = "${directory.path}/$name";
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<OpenResult> openFile(String path) async {
    return OpenFile.open(path);
  }
}
