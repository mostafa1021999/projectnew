class OrderModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Orders>? orderList;


  OrderModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse(json['offset']);
    if (json['orders'] != null) {
      orderList = <Orders>[];
      json['orders'].forEach((v) {
        orderList!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (orderList != null) {
      data['orders'] = orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? _id;
  int? _userId;
  double? _orderAmount;
  double? _totalTax;
  double? _collectedCash;
  double? _extraDiscount;
  String? _couponCode;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  int? _paymentId;
  String? _transactionReference;
  String? _createdAt;
  String? _updatedAt;
  Account? _account;

  Orders(
      {int? id,
        int? userId,
        double? orderAmount,
        double? totalTax,
        double? collectedCash,
        double? extraDiscount,
        String? couponCode,
        double? couponDiscountAmount,
        String? couponDiscountTitle,
        int? paymentId,
        String? transactionReference,
        String? createdAt,
        String? updatedAt,
        Account? account

      }) {
    if (id != null) {
      _id = id;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (orderAmount != null) {
      _orderAmount = orderAmount;
    }
    if (totalTax != null) {
      _totalTax = totalTax;
    }
    if (collectedCash != null) {
      _collectedCash = collectedCash;
    }
    if (extraDiscount != null) {
      _extraDiscount = extraDiscount;
    }
    if (couponCode != null) {
      _couponCode = couponCode;
    }
    if (couponDiscountAmount != null) {
      _couponDiscountAmount = couponDiscountAmount;
    }
    if (couponDiscountTitle != null) {
      _couponDiscountTitle = couponDiscountTitle;
    }
    if (paymentId != null) {
      _paymentId = paymentId;
    }
    if (transactionReference != null) {
      _transactionReference = transactionReference;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (account != null) {
      _account = account;
    }
  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get totalTax => _totalTax;
  double? get collectedCash => _collectedCash;
  double? get extraDiscount => _extraDiscount;
  String? get couponCode => _couponCode;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  int? get paymentId => _paymentId;
  String? get transactionReference => _transactionReference;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Account? get account => _account;


  Orders.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    if(json['user_id'] != null){
      _userId = int.parse(json['user_id'].toString());
    }

    if(json['order_amount'] != null){
      try{
        _orderAmount = json['order_amount'].toDouble();
      }catch(e){
        _orderAmount = double.parse(json['order_amount'].toString());
      }
    }

    if(json['total_tax'] != null){
      try{
        _totalTax = json['total_tax'].toDouble();
      }catch(e){
        _totalTax = double.parse(json['total_tax'].toString());
      }

    }else{
      _totalTax = 0.0;
    }
    if(json['collected_cash'] != null){
      try{
        _collectedCash = json['collected_cash'].toDouble();
      }catch(e){
        _collectedCash =double.parse(json['collected_cash'].toString());
      }

    }else{
      _collectedCash = 0.0;
    }

    if(json['extra_discount'] != null){
      try{
        _extraDiscount = json['extra_discount'].toDouble();
      }catch(e){
        _extraDiscount = double.parse(json['extra_discount'].toString());
      }

    }else{
      _extraDiscount = 0.0;
    }

    _couponCode = json['coupon_code'];
    if(json['coupon_discount_amount'] != null){
      try{
        _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
      }catch(e){
        _couponDiscountAmount = double.parse(json['coupon_discount_amount'].toString());
      }

    }else{
      _couponDiscountAmount = 0.0;
    }

    _couponDiscountTitle = json['coupon_discount_title'];
    if(json['payment_id'] != null){
      _paymentId = int.parse(json['payment_id'].toString());
    }

    _transactionReference = json['transaction_reference'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _account = json['account'] != null?  Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['order_amount'] = _orderAmount;
    data['total_tax'] = _totalTax;
    data['collected_cash'] = _collectedCash;
    data['extra_discount'] = _extraDiscount;
    data['coupon_code'] = _couponCode;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['payment_id'] = _paymentId;
    data['transaction_reference'] = _transactionReference;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_account != null) {
      data['account'] = _account!.toJson();
    }
    return data;
  }
}

class Account {
  int? _id;
  String? _account;
  String? _description;
  double? _balance;



  Account(
      {int? id,
        String? account,
        String? description,
        double? balance,
      }) {
    if (id != null) {
      _id = id;
    }
    if (account != null) {
      _account = account;
    }
    if (description != null) {
      _description = description;
    }
    if (balance != null) {
      _balance = balance;
    }


  }

  int? get id => _id;
  String? get account => _account;
  String? get description => _description;
  double? get balance => _balance;


  Account.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _account = json['account'];
    _description = json['description'];
    if(json['balance'] != null){
      try{
        _balance = json['balance'].toDouble();
      }catch(e){
        _balance = double.parse(json['balance'].toString());
      }
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['account'] = _account;
    data['description'] = _description;
    data['balance'] = _balance;
    return data;
  }
}
