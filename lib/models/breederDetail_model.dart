class BreederDetailModel {
  String description;
  int userId;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String address;
  String memberFrom;
  String profileImg;
  var rating;
  List<Post> post;

  BreederDetailModel(
      {this.description,
      this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.memberFrom,
      this.profileImg,
      this.rating,
      this.post,
      this.fullName});

  BreederDetailModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    address = json['address'];
    memberFrom = json['memberFrom'];
    profileImg = json['profile_img'];
    rating = json['rating'];
    fullName = json["fullName"];
    if (json['post'] != null) {
      post = new List<Post>();
      json['post'].forEach((v) {
        post.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['memberFrom'] = this.memberFrom;
    data['profile_img'] = this.profileImg;
    data["fullName"] = this.fullName;
    if (this.post != null) {
      data['post'] = this.post.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  int id;
  int userId;
  int breederId;
  String name;
  int category;
  int type;
  String address;
  String latitude;
  String longitude;
  String description;
  String age;
  String size;
  String hairType;
  String lifeSpan;
  String character;
  String care;
  String coatColour;
  String shelter;
  String breeder;
  String price;
  int reviewed;
  int visits;
  String status;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String filename;

  Post(
      {this.id,
      this.userId,
      this.breederId,
      this.name,
      this.category,
      this.type,
      this.address,
      this.latitude,
      this.longitude,
      this.description,
      this.age,
      this.size,
      this.hairType,
      this.lifeSpan,
      this.character,
      this.care,
      this.coatColour,
      this.shelter,
      this.breeder,
      this.price,
      this.reviewed,
      this.visits,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.filename});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    breederId = json['breederId'];
    name = json['name'];
    category = json['category'];
    type = json['type'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    age = json['age'];
    size = json['size'];
    hairType = json['hairType'];
    lifeSpan = json['lifeSpan'];
    character = json['character'];
    care = json['care'];
    coatColour = json['coatColour'];
    shelter = json['shelter'];
    breeder = json['breeder'];
    price = json['price'];
    reviewed = json['reviewed'];
    visits = json['visits'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['breederId'] = this.breederId;
    data['name'] = this.name;
    data['category'] = this.category;
    data['type'] = this.type;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    data['age'] = this.age;
    data['size'] = this.size;
    data['hairType'] = this.hairType;
    data['lifeSpan'] = this.lifeSpan;
    data['character'] = this.character;
    data['care'] = this.care;
    data['coatColour'] = this.coatColour;
    data['shelter'] = this.shelter;
    data['breeder'] = this.breeder;
    data['price'] = this.price;
    data['reviewed'] = this.reviewed;
    data['visits'] = this.visits;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['filename'] = this.filename;
    return data;
  }
}
