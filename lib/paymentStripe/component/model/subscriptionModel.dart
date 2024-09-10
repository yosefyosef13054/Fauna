class subscriptionModel {
  var id;
  var title;
  var type;
  var amount;
  var value;
  var description;
  var status;
  var createdAt;
  var updatedAt;

  subscriptionModel(
      {this.id,
        this.title,
        this.type,
        this.amount,
        this.value,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt});

  subscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    amount = json['amount'];
    value = json['value'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['value'] = this.value;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}