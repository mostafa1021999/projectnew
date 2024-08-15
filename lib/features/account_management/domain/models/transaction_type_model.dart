class TransactionTypeModel {
  List<Types>? typeList;

  TransactionTypeModel({List<Types>? types}) {
    if (types != null) {
      typeList = types;
    }
  }

  List<Types>? get types => typeList;


  TransactionTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      typeList = <Types>[];
      json['types'].forEach((v) {
        typeList!.add(Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (typeList != null) {
      data['types'] = typeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Types {
  int? _id;
  String? _tranType;

  Types({int? id, String? tranType}) {
    if (id != null) {
      _id = id;
    }
    if (tranType != null) {
      _tranType = tranType;
    }
  }

  int? get id => _id;
  String? get tranType => _tranType;

  Types.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _tranType = json['tran_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['tran_type'] = _tranType;
    return data;
  }
}
