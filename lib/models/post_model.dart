class PostModelClass {
  var id;
  var name;
  var category;
  var address;
  var description;
  var type;
  var visits;
  var latitude;
  var longitude;
  var updatedAt;
  List<Filter> filter;
  List<Filename> filename;
  List<FeturedPost> feturedPost;
  Breeder breeder;
  var price;
  var isFavourite;
  var mainCategory;
  var subCategory;
  var postType;
  var femaleCount;
  var maleCount;
  var totalCount;
  var userId;
  var isReview;
  var created_at;
  var status;

  PostModelClass(
      {this.id,
      this.name,
      this.category,
      this.address,
      this.description,
      this.type,
      this.visits,
      this.updatedAt,
      this.filter,
      this.filename,
      this.feturedPost,
      this.breeder,
      this.price,
      this.isFavourite,
      this.latitude,
      this.longitude,
      this.mainCategory,
      this.subCategory,
      this.postType,
      this.maleCount,
      this.femaleCount,
      this.totalCount,
      this.userId,
      this.isReview,
      this.created_at,
      this.status});

  PostModelClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    address = json['address'];
    description = json['description'];
    type = json['type'];
    visits = json['visits'];
    updatedAt = json['updated_at'];
    isFavourite = json['isFavourite'];
    price = json["price"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    mainCategory = json["mainCategory"];
    subCategory = json["subCategory"];
    totalCount = json["totalCount"];
    maleCount = json["maleCount"];
    femaleCount = json["femaleCount"];
    postType = json["postType"];
    userId = json["userId"];
    isReview = json["isReview"];
    created_at = json["created_at"];
    status = json["status"];
    if (json['filter'] != null) {
      filter = new List<Filter>();
      json['filter'].forEach((v) {
        filter.add(new Filter.fromJson(v));
      });
    }
    if (json['filename'] != null) {
      filename = new List<Filename>();
      json['filename'].forEach((v) {
        filename.add(new Filename.fromJson(v));
      });
    }
    if (json['feturedPost'] != null) {
      feturedPost = new List<FeturedPost>();
      json['feturedPost'].forEach((v) {
        feturedPost.add(new FeturedPost.fromJson(v));
      });
    }
    breeder =
        json['breeder'] != null ? new Breeder.fromJson(json['breeder']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['address'] = this.address;
    data['description'] = this.description;
    data['type'] = this.type;
    data['visits'] = this.visits;
    data['updated_at'] = this.updatedAt;
    data['isFavourite'] = this.isFavourite;
    data['price'] = this.price;
    data["latitude"] = this.latitude;
    data["longitude"] = this.longitude;
    data["mainCategory"] = this.mainCategory;
    data["subCategory"] = this.subCategory;
    data["postType"] = this.postType;
    data["maleCount"] = this.maleCount;
    data["femaleCount"] = this.femaleCount;
    data["totalCount"] = this.totalCount;
    data["userId"] = this.userId;
    data["isReview"] = this.isReview;
    data["created_at"] = this.created_at;
    data["status"] = this.status;

    if (this.filter != null) {
      data['filter'] = this.filter.map((v) => v.toJson()).toList();
    }
    if (this.filename != null) {
      data['filename'] = this.filename.map((v) => v.toJson()).toList();
    }
    if (this.feturedPost != null) {
      data['feturedPost'] = this.feturedPost.map((v) => v.toJson()).toList();
    }
    if (this.breeder != null) {
      data['breeder'] = this.breeder.toJson();
    }
    return data;
  }
}

class Filter {
  var id;
  var value;
  var typeId;

  Filter({this.id, this.value, this.typeId});

  Filter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    typeId = json['typeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['typeId'] = this.typeId;
    return data;
  }
}

class Filename {
  var id;
  var filename;
  var fileType;

  Filename({this.id, this.filename, this.fileType});

  Filename.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['filename'] = this.filename;
    data['fileType'] = this.fileType;
    return data;
  }
}

class FeturedPost {
  var id;
  var name;
  var address;
  var description;
  var filename;

  FeturedPost(
      {this.id, this.name, this.address, this.description, this.filename});

  FeturedPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['description'] = this.description;
    data['filename'] = this.filename;
    return data;
  }
}

class Breeder {
  var id;
  var firstName;
  var lastName;
  var email;
  var profileImg;
  var rating;

  Breeder(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.profileImg,
      this.rating});

  Breeder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profileImg = json['profile_img'];
    rating = json["rating"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['profile_img'] = this.profileImg;
    data["rating"] = this.rating;
    return data;
  }
}
