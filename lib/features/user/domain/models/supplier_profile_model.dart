class SupplierProfileModel {
  bool? _success;
  String? _message;
  Supplier? _supplier;

  SupplierProfileModel({bool? success, String? message, Supplier? supplier}) {
    if (success != null) {
      _success = success;
    }
    if (message != null) {
      _message = message;
    }
    if (supplier != null) {
      _supplier = supplier;
    }
  }

  bool? get success => _success;
  String? get message => _message;
  Supplier? get supplier => _supplier;


  SupplierProfileModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _supplier = json['supplier'] != null?
         Supplier.fromJson(json['supplier'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = _success;
    data['message'] = _message;
    if (_supplier != null) {
      data['supplier'] = _supplier!.toJson();
    }
    return data;
  }
}

class Supplier {
  int? _id;
  String? _name;
  String? _mobile;
  String? _email;
  String? _image;
  String? _state;
  String? _city;
  String? _zipCode;
  String? _address;
  double? _dueAmount;
  String? _createdAt;
  String? _updatedAt;


  Supplier(
      {int? id,
        String? name,
        String? mobile,
        String? email,
        String? image,
        String? state,
        String? city,
        String? zipCode,
        String? address,
        double? dueAmount,
        String? createdAt,
        String? updatedAt,
       }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (mobile != null) {
      _mobile = mobile;
    }
    if (email != null) {
      _email = email;
    }
    if (image != null) {
      _image = image;
    }
    if (state != null) {
      _state = state;
    }
    if (city != null) {
      _city = city;
    }
    if (zipCode != null) {
      _zipCode = zipCode;
    }
    if (address != null) {
      _address = address;
    }
    if (dueAmount != null) {
      _dueAmount = dueAmount;
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
  String? get mobile => _mobile;
  String? get email => _email;
  String? get image => _image;
  String? get state => _state;
  String? get city => _city;
  String? get zipCode => _zipCode;
  String? get address => _address;
  double? get dueAmount => _dueAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Supplier.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];
    if(json['due_amount'] != null){
      try{
        _dueAmount = json['due_amount'].toDouble();
      }catch(e){
        _dueAmount = double.parse(json['due_amount'].toString());
      }

    }else{
      _dueAmount = 0.0;
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['mobile'] = _mobile;
    data['email'] = _email;
    data['image'] = _image;
    data['state'] = _state;
    data['city'] = _city;
    data['zip_code'] = _zipCode;
    data['address'] = _address;
    data['due_amount'] = _dueAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;

    return data;
  }
}
