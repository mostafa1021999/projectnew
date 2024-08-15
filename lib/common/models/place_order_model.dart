
class PlaceOrderModel {
  List<Cart>? _cart;
  double? _couponDiscountAmount;
  double? _orderAmount;
  String? _couponCode;
  int? _userId;
  double? _collectedCash;
  double? _extraDiscount;
  double? _returnedAmount;
  int? _type;
  String? _transactionRef;
  String? _extraDiscountType;



  PlaceOrderModel(
      {required List<Cart> cart,
        double? couponDiscountAmount,
        String? couponCode,
        double? orderAmount,
        int? userId,
        double? collectedCash,
        double? extraDiscount,
        double? returnedAmount,
        int? type,
        String? transactionRef,
        String? extraDiscountType,


       }) {
    _cart = cart;
    _couponDiscountAmount = couponDiscountAmount;
    _orderAmount = orderAmount;
    _couponCode = couponCode;
    _userId = userId;
    _collectedCash = collectedCash;
    _extraDiscount = extraDiscount;
    _returnedAmount = returnedAmount;
    _type =type;
    _transactionRef = transactionRef;
    _extraDiscountType = extraDiscountType;

  }

  List<Cart>? get cart => _cart;
  double? get couponDiscountAmount => _couponDiscountAmount;
  double? get orderAmount => _orderAmount;
  int? get userId => _userId;
  double? get collectedCash => _collectedCash;
  double? get extraDiscount => _extraDiscount;
  double? get returnedAmount => _returnedAmount;
  int? get type => _type;
  String? get transactionRef => _transactionRef;
  String? get extraDiscountType => _extraDiscountType;


  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount'];
    _orderAmount = json['order_amount'];
    _userId = json['user_id'];
    _collectedCash = json['collected_cash'];
    _extraDiscount = json['extra_discount'];
    _returnedAmount = json['remaining_balance'];
    _type = json ['type'];
    _transactionRef = json ['transaction_reference'];
    _extraDiscountType = json ['extra_discount_type'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['coupon_discount'] = _couponDiscountAmount;
    data['order_amount'] = _orderAmount;
    data['coupon_code'] = _couponCode;
    data['user_id'] = _userId;
    data['collected_cash'] = _collectedCash;
    data['extra_discount'] = _extraDiscount;
    data['remaining_balance'] = _returnedAmount;
    data['type'] = _type;
    data['transaction_reference'] = _transactionRef;
    data['extra_discount_type'] = _extraDiscountType;

    return data;
  }
}

class Cart {
  String? _productId;
  String? _price;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;


  Cart(
      String productId,
        String price,
        double discountAmount,
        int? quantity,
        double taxAmount,
      ) {
    _productId = productId;
    _price = price;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;

  }

  String? get productId => _productId;
  String? get price => _price;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;


  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['id'];
    _price = json['price'];
    _discountAmount = json['discount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _productId;
    data['price'] = _price;
    data['discount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax'] = _taxAmount;
    return data;
  }
}
