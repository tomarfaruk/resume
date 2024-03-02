class PersonalInfoModel {
  String? firstName;

  String? image;

  String? lastName;

  String? phone;

  String? email;

  String? country;

  String? city;

  String? street;

  String? birthdate;

  String? profession;

  String? aboutYourself;

  PersonalInfoModel({
    this.firstName,
    this.lastName,
    this.image,
    this.phone,
    this.email,
    this.country,
    this.city,
    this.street,
    this.birthdate,
    this.profession,
    this.aboutYourself,
  });

  PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    phone = json['phone'];
    email = json['email'];
    country = json['country'];
    city = json['city'];
    street = json['street'];
    birthdate = json['birthdate'];
    profession = json['profession'];
    aboutYourself = json['aboutYourself'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['firstName'] = firstName;
    data['image'] = image;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['country'] = country;
    data['city'] = city;
    data['street'] = street;
    data['birthdate'] = birthdate;
    data['profession'] = profession;
    data['aboutYourself'] = aboutYourself;

    return data;
  }
}
