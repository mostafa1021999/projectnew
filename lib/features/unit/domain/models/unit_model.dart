class UnitModel {
  int? _total;
  String? _limit;
  String? _offset;
  List<Units>? _units;

  UnitModel({int? total, String? limit, String? offset, List<Units>? units}) {
    if (total != null) {
      _total = total;
    }
    if (limit != null) {
      _limit = limit;
    }
    if (offset != null) {
      _offset = offset;
    }
    if (units != null) {
      _units = units;
    }
  }

  int? get total => _total;
  String? get limit => _limit;
  String? get offset => _offset;
  List<Units>? get units => _units;

  UnitModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['units'] != null) {
      _units = <Units>[];
      json['units'].forEach((v) {
        _units!.add(Units.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = _total;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_units != null) {
      data['units'] = _units!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Units {
  int? _id;
  String? _unitType;
  String? _createdAt;
  String? _updatedAt;


  Units(
      {int? id,
        String? unitType,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (unitType != null) {
      _unitType = unitType;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }

  }

  int? get id => _id;
  String? get unitType => _unitType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Units.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _unitType = json['unit_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['unit_type'] = _unitType;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
