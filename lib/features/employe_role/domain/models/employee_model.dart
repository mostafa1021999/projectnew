import 'dart:convert';

class EmployeeModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Employee>? employees;

  EmployeeModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.employees,
  });

  factory EmployeeModel.fromJson(String str) => EmployeeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromMap(Map<String, dynamic> json) => EmployeeModel(
    totalSize: int.tryParse('${json["total"]}'),
    limit: int.tryParse('${json["limit"]}'),
    offset: int.tryParse('${json["offset"]}'),
    employees: json["employees"] == null ? [] : List<Employee>.from(json["employees"]!.map((x) => Employee.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "total": totalSize,
    "limit": limit,
    "offset": offset,
    "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toMap())),
  };
}

class Employee {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? password;
  dynamic rememberToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  dynamic companyId;
  int? roleId;
  String? imageFullpath;
  Role? role;

  Employee({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.password,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.companyId,
    this.roleId,
    this.imageFullpath,
    this.role,
  });

  factory Employee.fromJson(String str) => Employee.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
    id: json["id"],
    fName: json["f_name"],
    lName: json["l_name"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    rememberToken: json["remember_token"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    image: json["image"],
    companyId: json["company_id"],
    roleId: int.tryParse('${json["role_id"]}'),
    imageFullpath: json["image_fullpath"],
    role: json["role"] == null ? null : Role.fromMap(json["role"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "f_name": fName,
    "l_name": lName,
    "email": email,
    "phone": phone,
    "password": password,
    "remember_token": rememberToken,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image": image,
    "company_id": companyId,
    "role_id": roleId,
    "image_fullpath": imageFullpath,
    "role": role?.toMap(),
  };
}

class Role {
  int? id;
  String? name;
  List<String>? modules;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Role({
    this.id,
    this.name,
    this.modules,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
    modules: json["modules"] == null ? [] : List<String>.from(json["modules"]!.map((x) => x)),
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x)),
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
