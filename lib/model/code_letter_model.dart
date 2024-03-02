class CoverLetterModel {
  String? header, body, footer;
  CoverLetterModel({this.header, this.body, this.footer});

  CoverLetterModel.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    body = json['body'];
    footer = json['footer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['header'] = header;
    data['body'] = body;
    data['footer'] = footer;
    return data;
  }
}
