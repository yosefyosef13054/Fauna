class ShowAllBreedsModel {
  List<AllBreeds> allBreeds;
  int currentPage;
  int lastPage;
  int totalRecord;
  int perPage;

  ShowAllBreedsModel(
      {this.allBreeds,
      this.currentPage,
      this.lastPage,
      this.totalRecord,
      this.perPage});

  ShowAllBreedsModel.fromJson(Map<String, dynamic> json) {
    if (json['allBreeds'] != null) {
      allBreeds = new List<AllBreeds>();
      json['allBreeds'].forEach((v) {
        allBreeds.add(new AllBreeds.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    lastPage = json['last_page'];
    totalRecord = json['total_record'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allBreeds != null) {
      data['allBreeds'] = this.allBreeds.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['total_record'] = this.totalRecord;
    data['per_page'] = this.perPage;
    return data;
  }
}

class AllBreeds {
  var id;
  var userId;
  var breederId;
  var name;
  var category;
  var type;
  var address;
  var latitude;
  var longitude;
  var description;
  var age;
  var size;
  var hairType;
  var lifeSpan;
  var character;
  var care;
  var coatColour;
  var shelter;
  var breeder;
  var price;
  var reviewed;
  var visits;
  var status;
  var review;
  var createdAt;
  var updatedAt;
  var deletedAt;
  var gender;
  var postType;
  var femaleCount;
  var maleCount;
  var totalCount;
  var featuredPostAvailable;
  var isFavourite;
  var filename;

  AllBreeds(
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
      this.review,
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
      this.filename});

  AllBreeds.fromJson(Map<String, dynamic> json) {
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
    review = json['review'];
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
    data['review'] = this.review;
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
    return data;
  }
}
