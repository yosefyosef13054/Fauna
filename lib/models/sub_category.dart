class SubCategoryModelClass {
  int id;
  String name;
  String description;
  String picture;

  SubCategoryModelClass({this.id, this.name, this.description, this.picture});

  SubCategoryModelClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['picture'] = this.picture;
    return data;
  }
}
