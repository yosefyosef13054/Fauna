class ComplaintModel {
  int id;
  String title;
  String description;
  int status;
  String createdAt;
  String updatedAt;

  ComplaintModel(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  ComplaintModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
