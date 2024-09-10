class UserModelClass {
  var id;
  var firstName;
  var lastName;
  var email;
  var phone;
  var userType;
  var isBreeder;
  var stripeCustomerId;
  var country;
  var countryCode;
  var address;
  var latitude;
  var longitude;
  var profileImg;
  var verifiedEmail;
  var verifiedPhone;
  var status;
  var lastLoginAt;
  var createdAt;
  var updatedAt;
  var token;

  UserModelClass(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.userType,
      this.isBreeder,
      this.stripeCustomerId,
      this.country,
      this.countryCode,
      this.address,
      this.latitude,
      this.longitude,
      this.profileImg,
      this.verifiedEmail,
      this.verifiedPhone,
      this.status,
      this.lastLoginAt,
      this.createdAt,
      this.updatedAt,
      this.token});

  UserModelClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    userType = json['user_type'];
    isBreeder = json['isBreeder'];
    stripeCustomerId = json['stripeCustomerId'];
    country = json['country'];
    countryCode = json['countryCode'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    profileImg = json['profile_img'];
    verifiedEmail = json['verified_email'];
    verifiedPhone = json['verified_phone'];
    status = json['status'];
    lastLoginAt = json['last_login_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['user_type'] = this.userType;
    data['isBreeder'] = this.isBreeder;
    data['stripeCustomerId'] = this.stripeCustomerId;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['profile_img'] = this.profileImg;
    data['verified_email'] = this.verifiedEmail;
    data['verified_phone'] = this.verifiedPhone;
    data['status'] = this.status;
    data['last_login_at'] = this.lastLoginAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token'] = this.token;
    return data;
  }
}

class ResendModelClass {
  String message;

  ResendModelClass({this.message});

  ResendModelClass.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
