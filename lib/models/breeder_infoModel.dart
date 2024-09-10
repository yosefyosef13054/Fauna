class BreederInfoModelClass {
  var fullName;
  var businessLicense;
  var kennelLicense;
  var email;
  var userId;
  var status;
  var updatedAt;
  var createdAt;
  var id;
  var otp;

  BreederInfoModelClass(
      {this.fullName,
      this.businessLicense,
      this.kennelLicense,
      this.email,
      this.userId,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.otp});

  BreederInfoModelClass.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    businessLicense = json['businessLicense'];
    kennelLicense = json['kennelLicense'];
    email = json['email'];
    userId = json['userId'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['businessLicense'] = this.businessLicense;
    data['kennelLicense'] = this.kennelLicense;
    data['email'] = this.email;
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['otp'] = this.otp;
    return data;
  }
}
