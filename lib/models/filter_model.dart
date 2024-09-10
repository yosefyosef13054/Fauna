class FilterModelClass {
  int id;
  String name;
  String type;
  int parentId;
  int status;
  String createdAt;
  String updatedAt;
  String key_name;
  List<Option> option;
  int selectedIndex;

  FilterModelClass({
    this.id,
    this.name,
    this.type,
    this.parentId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.option,
    this.key_name,
    this.selectedIndex,
  });

  FilterModelClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    parentId = json['parent_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    key_name = json['key_name'];

    if (json['option'] != null) {
      option = new List<Option>();
      json['option'].forEach((v) {
        option.add(new Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['key_name'] = this.key_name;

    if (this.option != null) {
      data['option'] = this.option.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Option {
  int id;
  String name;
  String type;
  int parentId;
  int status;
  String createdAt;
  String updatedAt;
  var value;

  Option(
      {this.id,
      this.name,
      this.type,
      this.parentId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.value});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    parentId = json['parent_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['value'] = this.value;
    return data;
  }
}
