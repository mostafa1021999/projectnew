class InvoiceModel {
  bool? _success;
  Invoice? _invoice;

  InvoiceModel({bool? success, Invoice? invoice}) {
    if (success != null) {
      _success = success;
    }
    if (invoice != null) {
      _invoice = invoice;
    }
  }

  bool? get success => _success;
  Invoice? get invoice => _invoice;


  InvoiceModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _invoice =
    json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = _success;
    if (_invoice != null) {
      data['invoice'] = _invoice!.toJson();
    }
    return data;
  }
}

class Invoice {
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
  List<Details>? _details;
  Account? _account;

  Invoice(
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
        List<Details>? details,
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
    if (details != null) {
      _details = details;
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
  List<Details>? get details => _details;
  Account? get account => _account;





  Invoice.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = int.parse(json['user_id'].toString());
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
        _collectedCash = double.parse(json['collected_cash'].toString());
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
    if(json['coupon_code'] != null){
      _couponCode = json['coupon_code'];
    }else{
      _couponCode = '';
    }

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
    _paymentId = int.parse(json['payment_id'].toString());
    _transactionReference = json['transaction_reference'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['details'] != null) {
      _details = <Details>[];
      json['details'].forEach((v) {
        _details!.add(Details.fromJson(v));
      });
    }
    _account = json['account'] != null ? Account.fromJson(json['account']) : null;
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
    if (_details != null) {
      data['details'] = _details!.map((v) => v.toJson()).toList();
    }
    if (_account != null) {
      data['account'] = _account!.toJson();
    }
    return data;
  }
}

class Details {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  String? _productDetails;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;

  Details(
      {int? id,
        int? productId,
        int? orderId,
        double? price,
        String? productDetails,
        double? discountOnProduct,
        String? discountType,
        int? quantity,
        double? taxAmount,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (productId != null) {
      _productId = productId;
    }
    if (orderId != null) {
      _orderId = orderId;
    }
    if (price != null) {
      _price = price;
    }
    if (productDetails != null) {
      _productDetails = productDetails;
    }
    if (discountOnProduct != null) {
      _discountOnProduct = discountOnProduct;
    }
    if (discountType != null) {
      _discountType = discountType;
    }
    if (quantity != null) {
      _quantity = quantity;
    }
    if (taxAmount != null) {
      _taxAmount = taxAmount;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  String? get productDetails => _productDetails;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = int.parse(json['product_id'].toString());
    _orderId = int.parse(json['order_id'].toString());
    if(json['price'] != null){
      try{
        _price = json['price'].toDouble();
      }catch(e){
        _price = double.parse(json['price'].toString());
      }
    }

    _productDetails = json['product_details'];
    if(json['discount_on_product'] != null){
      try{
        _discountOnProduct = json['discount_on_product'].toDouble();
      }catch(e){
        _discountOnProduct = double.parse(json['discount_on_product'].toString());
      }

    }else{
      _discountOnProduct = 0.0;
    }

    _discountType = json['discount_type'];
    _quantity = int.parse(json['quantity'].toString());
    if(json['tax_amount'] != null){
      try{
        _taxAmount = json['tax_amount'].toDouble();
      }catch(e){
        _taxAmount = double.parse(json['tax_amount'].toString());
      }

    }else{
      _taxAmount =0.0;
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    data['product_details'] = _productDetails;
    data['discount_on_product'] = _discountOnProduct;
    data['discount_type'] = _discountType;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
class Account {
  int? _id;
  String? _account;
  Account(
      {int? id,
        String? account,
      }) {
    if (id != null) {
      _id = id;
    }
    if (account != null) {
      _account = account;
    }

  }

  int? get id => _id;
  String? get account => _account;


  Account.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _account = json['account'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['account'] = _account;
    return data;
  }
}