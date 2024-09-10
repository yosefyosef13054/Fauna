class ChatHistory {
  var id;
  var postId;
  var parentId;
  var fromUserId;
  var toUserId;
  var messages;
  var isRead;
  var status;
  var deletedBy;
  var createdAt;
  var updatedAt;
  var deletedAt;
  var channelName;
  var post_img;
  var post_name;
  var maleCount;
  var femaleCount;
  var price;
  var time;
  var type;

  ChatHistory(
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
      this.post_img,
      this.price,
      this.time,
      this.type,
      this.post_name,
      this.maleCount,
      this.femaleCount});

  ChatHistory.fromJson(Map<String, dynamic> json) {
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
    post_img = json['post_img'];
    price = json['price'];
    time = json["time"];
    type = json["type"];
    post_name = json["post_name"];
    maleCount = json["maleCount"];
    femaleCount = json["femaleCount"];
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
    data['post_img'] = this.post_img;
    data['price'] = this.price;
    data["time"] = this.time;
    data["type"] = this.type;
    data["post_name"] = this.post_name;
    data["maleCount"] = this.maleCount;
    data["femaleCount"] = this.femaleCount;
    return data;
  }
}
