class CouponModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Coupons>? couponList;

  CouponModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    if (json['coupons'] != null) {
      couponList = <Coupons>[];
      json['coupons'].forEach((v) {
        couponList!.add(Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (couponList != null) {
      data['coupons'] = couponList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  int? _id;
  String? _title;
  String? _couponType;
  int? _userLimit;
  String? _couponCode;
  String? _startDate;
  String? _expireDate;
  String? _minPurchase;
  String? _maxDiscount;
  String? _discount;
  String? _discountType;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  Coupons(
      {int? id,
        String? title,
        String? couponType,
        int? userLimit,
        String? couponCode,
        String? startDate,
        String? expireDate,
        String? minPurchase,
        String? maxDiscount,
        String? discount,
        String? discountType,
        int? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (title != null) {
      _title = title;
    }
    if (couponType != null) {
      _couponType = couponType;
    }
    if (userLimit != null) {
      _userLimit = userLimit;
    }
    if (couponCode != null) {
      _couponCode = couponCode;
    }
    if (startDate != null) {
      _startDate = startDate;
    }
    if (expireDate != null) {
      _expireDate = expireDate;
    }
    if (minPurchase != null) {
      _minPurchase = minPurchase;
    }
    if (maxDiscount != null) {
      _maxDiscount = maxDiscount;
    }
    if (discount != null) {
      _discount = discount;
    }
    if (discountType != null) {
      _discountType = discountType;
    }
    if (status != null) {
      _status = status;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  String? get title => _title;
  String? get couponType => _couponType;
  int? get userLimit => _userLimit;
  String? get couponCode => _couponCode;
  String? get startDate => _startDate;
  String? get expireDate => _expireDate;
  String? get minPurchase => _minPurchase;
  String? get maxDiscount => _maxDiscount;
  String? get discount => _discount;
  String? get discountType => _discountType;
  // ignore: unnecessary_getters_setters
  int? get status => _status;

  set status(int? value) {
    _status = value;
  }

  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Coupons.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _couponType = json['coupon_type'];
    if(json['user_limit'] != null){
      _userLimit = int.parse(json['user_limit'].toString());
    }

    _couponCode = json['code'];
    _startDate = json['start_date'];
    _expireDate = json['expire_date'];
    _minPurchase = json['min_purchase'];
    _maxDiscount = json['max_discount'];
    _discount = json['discount'];
    _discountType = json['discount_type'];
    if(json['status'] != null){
      _status = int.parse(json['status'].toString());
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['coupon_type'] = _couponType;
    data['user_limit'] = _userLimit;
    data['code'] = _couponCode;
    data['start_date'] = _startDate;
    data['expire_date'] = _expireDate;
    data['min_purchase'] = _minPurchase;
    data['max_discount'] = _maxDiscount;
    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
