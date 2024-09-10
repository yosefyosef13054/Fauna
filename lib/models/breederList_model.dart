class FeaturedBreederModel {
  int id;
  String email;
  String fullName;
  String description;
  String profileImg;
  String address;

  FeaturedBreederModel(
      {this.id,
      this.email,
      this.fullName,
      this.description,
      this.profileImg,
      this.address});

  FeaturedBreederModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    description = json['description'];
    profileImg = json['profile_img'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['description'] = this.description;
    data['profile_img'] = this.profileImg;
    data['address'] = this.address;
    return data;
  }
}
