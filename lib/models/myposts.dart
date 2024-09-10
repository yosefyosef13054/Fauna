class my_posts {
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
  var createdAt;
  var updatedAt;
  var deletedAt;
  var filename;
  var isOwner;

  my_posts(
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
        this.filename,
      this.isOwner});

  my_posts.fromJson(Map<String, dynamic> json) {
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
    isOwner = json['isOwner'];
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
    data['isOwner'] = this.isOwner;
    return data;
  }
}