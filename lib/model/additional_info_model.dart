class AdditionalInfoModel {
  String? skills;
  String? languages;
  String? interest;
  String? linked;
  String? facebook;
  String? twitter;
  String? blogsite;
  String? other;
  String? reference;
  String? awards;

  AdditionalInfoModel(
      {this.skills,
      this.languages,
      this.interest,
      this.linked,
      this.facebook,
      this.twitter,
      this.blogsite,
      this.other,
      this.reference,
      this.awards});

  AdditionalInfoModel.fromJson(Map<String, dynamic> json) {
    skills = json['skills'];
    languages = json['languages'];
    interest = json['interest'];
    linked = json['linked'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    blogsite = json['blogsite'];
    other = json['other'];
    reference = json['reference'];
    awards = json['awards'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skills'] = skills;
    data['languages'] = languages;
    data['interest'] = interest;
    data['linked'] = linked;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['blogsite'] = blogsite;
    data['other'] = other;
    data['reference'] = reference;
    data['awards'] = awards;
    return data;
  }
}
