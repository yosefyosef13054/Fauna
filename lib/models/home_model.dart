class HomeModelClass {
  List<FeaturedPost> featuredPost;
  List<TopCategories> topCategories;
  List<Explore> explore;
  List<TopRatedBreeder> topRatedBreeder;
  var counter;
  var isBreeder;

  HomeModelClass(
      {this.featuredPost,
      this.topCategories,
      this.explore,
      this.topRatedBreeder,
      this.counter,
      this.isBreeder});

  HomeModelClass.fromJson(Map<String, dynamic> json) {
    counter = json["counter"];
    isBreeder = json["isBreeder"];
    if (json['featuredPost'] != null) {
      featuredPost = new List<FeaturedPost>();
      json['featuredPost'].forEach((v) {
        featuredPost.add(new FeaturedPost.fromJson(v));
      });
    }
    if (json['topCategories'] != null) {
      topCategories = new List<TopCategories>();
      json['topCategories'].forEach((v) {
        topCategories.add(new TopCategories.fromJson(v));
      });
    }
    if (json['explore'] != null) {
      explore = new List<Explore>();
      json['explore'].forEach((v) {
        explore.add(new Explore.fromJson(v));
      });
    }
    if (json['topRatedBreeder'] != null) {
      topRatedBreeder = new List<TopRatedBreeder>();
      json['topRatedBreeder'].forEach((v) {
        topRatedBreeder.add(new TopRatedBreeder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['counter'] = this.counter;
    data['isBreeder'] = this.isBreeder;
    if (this.featuredPost != null) {
      data['featuredPost'] = this.featuredPost.map((v) => v.toJson()).toList();
    }
    if (this.topCategories != null) {
      data['topCategories'] =
          this.topCategories.map((v) => v.toJson()).toList();
    }
    if (this.explore != null) {
      data['explore'] = this.explore.map((v) => v.toJson()).toList();
    }
    if (this.topRatedBreeder != null) {
      data['topRatedBreeder'] =
          this.topRatedBreeder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeaturedPost {
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
  var breeder;
  int price;
  int reviewed;
  int visits;
  String status;
  String createdAt;
  String updatedAt;
  var deletedAt;
  String gender;
  int postType;
  int femaleCount;
  int maleCount;
  var totalCount;
  String featuredPostAvailable;
  int isFavourite;
  String filename;
  String categoryName;
  String todayDate;

  FeaturedPost(
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
      this.gender,
      this.postType,
      this.femaleCount,
      this.maleCount,
      this.totalCount,
      this.featuredPostAvailable,
      this.isFavourite,
      this.filename,
      this.categoryName,
      this.todayDate});

  FeaturedPost.fromJson(Map<String, dynamic> json) {
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
    gender = json['gender'];
    postType = json['postType'];
    femaleCount = json['femaleCount'];
    maleCount = json['maleCount'];
    totalCount = json['totalCount'];
    featuredPostAvailable = json['featured_post_available'];
    isFavourite = json['isFavourite'];
    filename = json['filename'];
    categoryName = json['categoryName'];
    todayDate = json['today_date'];
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
    data['gender'] = this.gender;
    data['postType'] = this.postType;
    data['femaleCount'] = this.femaleCount;
    data['maleCount'] = this.maleCount;
    data['totalCount'] = this.totalCount;
    data['featured_post_available'] = this.featuredPostAvailable;
    data['isFavourite'] = this.isFavourite;
    data['filename'] = this.filename;
    data['categoryName'] = this.categoryName;
    data['today_date'] = this.todayDate;
    return data;
  }
}

class TopCategories {
  int id;
  String name;
  String description;
  String picture;

  TopCategories({this.id, this.name, this.description, this.picture});

  TopCategories.fromJson(Map<String, dynamic> json) {
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

class Explore {
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
  var breeder;
  int price;
  int reviewed;
  int visits;
  String status;
  String createdAt;
  String updatedAt;
  var deletedAt;
  String gender;
  int postType;
  int femaleCount;
  int maleCount;
  var totalCount;
  String featuredPostAvailable;
  int isFavourite;
  String filename;
  String categoryName;

  Explore(
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
      this.gender,
      this.postType,
      this.femaleCount,
      this.maleCount,
      this.totalCount,
      this.featuredPostAvailable,
      this.isFavourite,
      this.filename,
      this.categoryName});

  Explore.fromJson(Map<String, dynamic> json) {
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
    gender = json['gender'];
    postType = json['postType'];
    femaleCount = json['femaleCount'];
    maleCount = json['maleCount'];
    totalCount = json['totalCount'];
    featuredPostAvailable = json['featured_post_available'];
    isFavourite = json['isFavourite'];
    filename = json['filename'];
    categoryName = json['categoryName'];
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
    data['gender'] = this.gender;
    data['postType'] = this.postType;
    data['femaleCount'] = this.femaleCount;
    data['maleCount'] = this.maleCount;
    data['totalCount'] = this.totalCount;
    data['featured_post_available'] = this.featuredPostAvailable;
    data['isFavourite'] = this.isFavourite;
    data['filename'] = this.filename;
    data['categoryName'] = this.categoryName;
    return data;
  }
}

class TopRatedBreeder {
  int id;
  String phone;
  String fullName;
  String description;
  String profileImg;
  String email;
  String address;

  TopRatedBreeder(
      {this.id,
      this.phone,
      this.fullName,
      this.description,
      this.profileImg,
      this.email,
      this.address});

  TopRatedBreeder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    fullName = json['fullName'];
    description = json['description'];
    profileImg = json['profile_img'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['fullName'] = this.fullName;
    data['description'] = this.description;
    data['profile_img'] = this.profileImg;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}
