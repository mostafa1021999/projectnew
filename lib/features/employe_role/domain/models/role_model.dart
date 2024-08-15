import 'dart:convert';

class RoleModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<RoleItemModel>? roleList;

  RoleModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.roleList,
  });

  factory RoleModel.fromJson(String str) => RoleModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RoleModel.fromMap(Map<String, dynamic> json) => RoleModel(
    totalSize: int.tryParse('${json["total"]}'),
    limit: int.tryParse('${json["limit"]}'),
    offset: int.tryParse('${json["offset"]}'),
    roleList: json["role"] == null ? [] : List<RoleItemModel>.from(json["role"]?.map((x) => RoleItemModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "total": totalSize,
    "limit": limit,
    "offset": offset,
    "role": roleList == null ? [] : List<dynamic>.from(roleList!.map((x) => x.toMap())),
  };
}

class RoleItemModel {
  int? id;
  String? name;
  List<String>? modules;
  int? status;

  RoleItemModel({
    this.id,
    this.name,
    this.modules,
    this.status,
  });

  factory RoleItemModel.fromJson(String str) => RoleItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RoleItemModel.fromMap(Map<String, dynamic> json) => RoleItemModel(
    id: json["id"],
    name: json["name"],
    modules: json["modules"] == null ? [] : List<String>.from(json["modules"]?.map((x) => x)),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x)),
    "status": status,
  };
}
