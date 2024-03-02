class CommonInfoModel {
  String? header;
  String? title;
  String? startDate;
  String? ednDate;
  String? summary;

  CommonInfoModel(
      {this.header, this.title, this.startDate, this.ednDate, this.summary});

  CommonInfoModel.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    title = json['title'];
    startDate = json['startDate'];
    ednDate = json['ednDate'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['header'] = header;
    data['title'] = title;
    data['startDate'] = startDate;
    data['ednDate'] = ednDate;
    data['summary'] = summary;
    return data;
  }
}
