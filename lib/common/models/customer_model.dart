class CustomerModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Customers>? customerList;

  CustomerModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total']}');
    limit = int.parse(json['limit'].toString());
    offset = int.parse(json['offset'].toString());
    if (json['customers'] != null) {
      customerList = <Customers>[];
      json['customers'].forEach((v) {
        customerList!.add(Customers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (customerList != null) {
      data['customers'] = customerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customers {
  int? _id;
  String? _name;
  String? _mobile;
  String? _email;
  String? _image;
  String? _state;
  String? _city;
  String? _zipCode;
  String? _address;
  double? _balance;
  String? _createdAt;
  String? _updatedAt;
  int? _ordersCount;


  Customers(
      {int? id,
        String? name,
        String? mobile,
        String? email,
        String? image,
        String? state,
        String? city,
        String? zipCode,
        String? address,
        double? balance,
        String? createdAt,
        String? updatedAt,
        int? ordersCount,
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
    if (balance != null) {
      _balance = balance;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }

    if (ordersCount != null) {
      _ordersCount = ordersCount;
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
  double? get balance => _balance;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get orderCount => _ordersCount;


  Customers.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];
    if(json['balance'] != null){
     try{
       _balance = (json['balance']).toDouble();
     }catch(e){
       _balance = double.parse(json['balance'].toString());
     }
    }else{
      _balance = 0.0;
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if(json['orders_count'] != null){
      _ordersCount = int.parse(json['orders_count'].toString());
    }else{
      _ordersCount = 0;
    }


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
    data['balance'] = _balance;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['orders_count'] = _ordersCount;

    return data;
  }
}
