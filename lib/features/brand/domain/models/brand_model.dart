class BrandModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Brands>? brandList;


  BrandModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total'];
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    if (json['brands'] != null) {
      brandList = <Brands>[];
      json['brands'].forEach((v) {
        brandList?.add(Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (brandList != null) {
      data['brands'] = brandList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int? _id;
  String? _name;
  String? _image;
  String? _createdAt;
  String? _updatedAt;

  Brands(
      {int? id,
        String? name,
        String? image,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (image != null) {
      _image = image;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Brands.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
