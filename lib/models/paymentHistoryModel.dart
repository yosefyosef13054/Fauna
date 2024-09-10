class PaymentHistoryModel {
  String type;
  int amount;
  String status;
  String paymentMethodId;
  int postId;
  int id;
  String createdAt;
  String postName;
  String filename;
  var totalCount;
  var maleCount;
  var femaleCount;
  String date;
  var payment_type;

  PaymentHistoryModel(
      {this.type,
      this.amount,
      this.status,
      this.paymentMethodId,
      this.postId,
      this.id,
      this.createdAt,
      this.postName,
      this.filename,
      this.totalCount,
      this.maleCount,
      this.femaleCount,
      this.date,
      this.payment_type});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
    status = json['status'];
    paymentMethodId = json['payment_method_id'];
    postId = json['postId'];
    id = json['id'];
    createdAt = json['created_at'];
    postName = json['post_name'];
    filename = json['filename'];
    totalCount = json['totalCount'];
    maleCount = json['maleCount'];
    femaleCount = json['femaleCount'];
    date = json['date'];
    payment_type = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['payment_method_id'] = this.paymentMethodId;
    data['postId'] = this.postId;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['post_name'] = this.postName;
    data['filename'] = this.filename;
    data['totalCount'] = this.totalCount;
    data['maleCount'] = this.maleCount;
    data['femaleCount'] = this.femaleCount;
    data['date'] = this.date;
    data['payment_type'] = this.payment_type;
    return data;
  }
}


class MarkModel {
  String success;

  MarkModel({this.success});

  MarkModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  }
}
