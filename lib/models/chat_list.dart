class ChatList {
  int id;
  var postId;
  int parentId;
  int fromUserId;
  int toUserId;
  String messages;
  var isRead;
  int status;
  Null deletedBy;
  String createdAt;
  String updatedAt;
  var deletedAt;
  String channelName;
  String firstName;
  String lastName;
  String profileImg;
  var post_name;
  var breederId;
  var price;
  var commitment_fee;
  var unread;
  var isBreeder;
  var type;
  var postType;
  var totalCount;
  var femaleCount;
  var maleCount;

  ChatList(
      {this.id,
      this.postId,
      this.parentId,
      this.fromUserId,
      this.toUserId,
      this.messages,
      this.isRead,
      this.status,
      this.deletedBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.channelName,
      this.firstName,
      this.lastName,
      this.profileImg,
      this.post_name,
      this.breederId,
      this.price,
      this.commitment_fee,
      this.unread,
      this.isBreeder,
      this.type,
      this.postType,
      this.totalCount,
      this.femaleCount,
      this.maleCount});

  ChatList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    parentId = json['parent_id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    messages = json['messages'];
    isRead = json['isRead'];
    status = json['status'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    channelName = json['channel_name'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profileImg = json['profile_img'];
    post_name = json["post_name"];
    breederId = json["breederId"];
    price = json["price"];
    commitment_fee = json["commitment_fee"];
    unread = json["unread"];
    isBreeder = json["isBreeder"];
    type = json["type"];
    postType = json["postType"];
    totalCount = json["totalCount"];
    femaleCount = json["femaleCount"];
    maleCount = json["maleCount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['parent_id'] = this.parentId;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['messages'] = this.messages;
    data['isRead'] = this.isRead;
    data['status'] = this.status;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['channel_name'] = this.channelName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profile_img'] = this.profileImg;
    data["post_name"] = this.post_name;
    data["breederId"] = this.breederId;
    data["unread"] = this.unread;
    data["isBreeder"] = this.isBreeder;
    data["type"] = this.type;
    data["postType"] = this.postType;
    data["totalCount"] = this.totalCount;
    data["femaleCount"] = this.femaleCount;
    data["maleCount"] = this.maleCount;
    return data;
  }
}
