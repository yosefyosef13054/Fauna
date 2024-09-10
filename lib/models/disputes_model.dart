class DisputesModel {
  int id;
  int userId;
  String name;
  int complainAs;
  String phone;
  String complaint;
  int type;
  int status;
  String address;
  String createdAt;
  String updatedAt;
  String complainName;

  DisputesModel(
      {this.id,
      this.userId,
      this.name,
      this.complainAs,
      this.phone,
      this.complaint,
      this.type,
      this.status,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.complainName});

  DisputesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    complainAs = json['complainAs'];
    phone = json['phone'];
    complaint = json['complaint'];
    type = json['type'];
    status = json['status'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    complainName = json['complainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['complainAs'] = this.complainAs;
    data['phone'] = this.phone;
    data['complaint'] = this.complaint;
    data['type'] = this.type;
    data['status'] = this.status;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['complainName'] = this.complainName;
    return data;
  }
}
