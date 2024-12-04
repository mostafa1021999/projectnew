
import 'dart:convert';

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
  String? _qrCode;


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
        String? qrCode,

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
    _qrCode=qrCode;

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
  String? get qrcode => _qrCode;

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
    _qrCode = json ['qrcode'];

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
    data['qrcode'] = _qrCode;
    return data;
  }
}

class Cart {
  String? _productId;
  String? _price;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  String? _productName; // Ensure you handle the product name

  Cart(
      String productId,
      String price,
      double discountAmount,
      int? quantity,
      double taxAmount,
      String productName, // Add product name to the constructor
      ) {
    _productId = productId;
    _price = price;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _productName = productName; // Initialize product name
  }

  // Add a getter for product name
  String? get productName => _productName;
  String? get productId => _productId;
  String? get price => _price;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  // Update the fromJson method to include product name if needed
  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['id'];
    _price = json['price'];
    _discountAmount = json['discount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax'];
    final Map<String, dynamic> productDetails = jsonDecode(json['product_details']);
    _productName = productDetails['name']; // Decode and set product name
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _productId;
    data['price'] = _price;
    data['discount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax'] = _taxAmount;
    // Include product name in JSON output if needed
    data['product_name'] = _productName;
    return data;
  }
}
