import 'dart:convert';


class ProfileModel {
  int? _id;
  String? _fName;
  String? _lName;
  String? _email;
  String? _phone;
  String? _password;
  String? _image;
  Role? _role;



  ProfileModel(
      {int? id,
        String? fName,
        String? lName,
        String? email,
        String? phone,
        String? password,
        String? image,
        Role? role,
       }) {
    if (id != null) {
      _id = id;
    }
    if (fName != null) {
      _fName = fName;
    }
    if (lName != null) {
      _lName = lName;
    }
    if (email != null) {
      _email = email;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (password != null) {
      _password = password;
    }
    if (image != null) {
      _image = image;
    }
    if (role != null) {
      _role = role;
    }
 
  }

  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get email => _email;
  String? get phone => _phone;
  String? get password => _password;
  String? get image => _image;
  Role? get role => _role;

  

  ProfileModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _email = json['email'];
    _phone = json['phone'];
    _password = json['password'];
    _image = json['image'];
    _role = json["role"] == null ? null : Role.fromMap(json["role"]);


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['email'] = _email;
    data['phone'] = _phone;
    data['password'] = _password;
    data['image'] = _image;
    data['role'] = _role;
    return data;
  }
}

class Role {
  final String? name;
  final int? status;
  final List<String>? modules;

  Role({
    this.name,
    this.status,
    this.modules,
  });

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json)=>  Role(
    name: json["name"],
    status: int.tryParse('${json["status"]}'),
    modules: json["modules"] == null ? null : List<String>.from(json["modules"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "status": status,
    "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x)),

  };
}

class ModulePermission {
  final bool pos;
  final bool product;
  final bool employee;
  final bool customer;
  final bool supplier;
  final bool setting;
  final bool coupon;
  final bool limitedStock;
  final bool account;
  final bool unit;
  final bool brand;
  final bool category;
  final bool employeeRole;
  final bool dashboard;

  ModulePermission({
    required this.pos,
    required this.product,
    required this.employee,
    required this.customer,
    required this.supplier,
    required this.setting,
    required this.coupon,
    required this.limitedStock,
    required this.account,
    required this.unit,
    required this.brand,
    required this.category,
    required this.employeeRole,
    required this.dashboard
  });
}

