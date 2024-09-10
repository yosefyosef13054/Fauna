class RateModelClass {
  int userId;
  String postId;
  String rating;
  String breederId;
  int status;
  String updatedAt;
  String createdAt;
  int id;

  RateModelClass(
      {this.userId,
      this.postId,
      this.rating,
      this.breederId,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.id});

  RateModelClass.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    postId = json['postId'];
    rating = json['rating'];
    breederId = json['breederId'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['rating'] = this.rating;
    data['breederId'] = this.breederId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
