class CategoriesProduct {
  int? _id;
  String? _title;
  String? _productCode;
  int? _unitType;
  String? _unitValue;
  Brand? _brand;
  List<CategoryIds>? _categoryIds;
  double? _purchasePrice;
  double? _sellingPrice;
  String? _discountType;
  double? _discount;
  double? _tax;
  int? _quantity;
  String? _image;
  Supplier? _supplier;

  CategoriesProduct(
      {int? id,
        String? title,
        String? productCode,
        int? unitType,
        String? unitValue,
        Brand? brand,
        List<CategoryIds>? categoryIds,
        double? purchasePrice,
        double? sellingPrice,
        String? discountType,
        double? discount,
        double? tax,
        int? quantity,
        String? image,
        Supplier? supplier}) {
    if (id != null) {
      _id = id;
    }
    if (title != null) {
      _title = title;
    }
    if (productCode != null) {
      _productCode = productCode;
    }
    if (unitType != null) {
      _unitType = unitType;
    }
    if (unitValue != null) {
      _unitValue = unitValue;
    }
    if (brand != null) {
      _brand = brand;
    }
    if (categoryIds != null) {
      _categoryIds = categoryIds;
    }
    if (purchasePrice != null) {
      _purchasePrice = purchasePrice;
    }
    if (sellingPrice != null) {
      _sellingPrice = sellingPrice;
    }
    if (discountType != null) {
      _discountType = discountType;
    }
    if (discount != null) {
      _discount = discount;
    }
    if (tax != null) {
      _tax = tax;
    }
    if (quantity != null) {
      _quantity = quantity;
    }
    if (image != null) {
      _image = image;
    }
    if (supplier != null) {
      _supplier = supplier;
    }
  }

  int? get id => _id;
  String? get title => _title;
  String? get productCode => _productCode;
  int? get unitType => _unitType;
  String? get unitValue => _unitValue;
  Brand? get brand => _brand;
  List<CategoryIds>? get categoryIds => _categoryIds;
  double? get purchasePrice => _purchasePrice;
  double? get sellingPrice => _sellingPrice;
  String? get discountType => _discountType;
  double? get discount => _discount;
  double? get tax => _tax;
  // ignore: unnecessary_getters_setters
  int? get quantity => _quantity;
  set quantity(int? quantity) => _quantity = quantity;
  String? get image => _image;
  Supplier? get supplier => _supplier;


  CategoriesProduct.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _productCode = json['product_code'];
    if(json['unit_type'] != null){
      _unitType = int.parse(json['unit_type'].toString());
    }

    if(json['unit_value'] != null){
      _unitValue = json['unit_value'].toString();
    }

    _brand = json['brand'] != null?  Brand.fromJson(json['brand']) : null;
    if (json['category_ids'] != null) {
      _categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if(json['purchase_price'] != null){
      try{
        _purchasePrice = json['purchase_price'].toDouble();
      }catch(e){
        _purchasePrice = double.parse(json['purchase_price'].toString());
      }

    }else{
      _purchasePrice = 0.0;
    }

    if(json['selling_price'] != null){
      try{
        _sellingPrice = json['selling_price'].toDouble();
      }catch(e){
        _sellingPrice = double.parse(json['selling_price'].toString());
      }

    }else{
      _sellingPrice = 0.0;
    }

    _discountType = json['discount_type'];
    if(json['discount'] != null){
      try{
        _discount = json['discount'].toDouble();
      }catch(e){
        _discount = double.parse(json['discount'].toString());
      }

    }else{
      _discount = 0.0;
    }

    if(json['tax'] != null){
      try{
        _tax = json['tax'].toDouble();
      }catch(e){
        _tax = double.parse(json['tax'].toString());
      }

    }else{
      _tax = 0.0;
    }
    _quantity = int.parse(json['quantity'].toString());
    _image = json['image'];
    _supplier = json['supplier'] != null?
         Supplier.fromJson(json['supplier'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['product_code'] = _productCode;
    data['unit_type'] = _unitType;
    data['unit_value'] = _unitValue;
    if (_brand != null) {
      data['brand'] = _brand!.toJson();
    }
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    data['purchase_price'] = _purchasePrice;
    data['selling_price'] = _sellingPrice;
    data['discount_type'] = _discountType;
    data['discount'] = _discount;
    data['tax'] = _tax;
    data['quantity'] = _quantity;
    data['image'] = _image;
    if (_supplier != null) {
      data['supplier'] = _supplier!.toJson();
    }
    return data;
  }
}

class CategoryIds {
  String? _id;
  int? _position;

  CategoryIds({String? id, int? position}) {
    if (id != null) {
      _id = id;
    }
    if (position != null) {
      _position = position;
    }
  }

  String? get id => _id;
  int? get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['position'] = _position;
    return data;
  }
}

class Brand {
  int? _id;
  String? _name;
  String? _image;



  Brand(
      {int? id,
        String? name,
        String? image,

      }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (image != null) {
      _image = image;
    }


  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;



  Brand.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;

    return data;
  }
}

class Supplier {
  int? _id;
  String? _name;
  String? _mobile;
  String? _email;
  String? _image;
  String? _state;
  String? _city;
  String? _zipCode;
  String? _address;


  Supplier(
      {int? id,
        String? name,
        String? mobile,
        String? email,
        String? image,
        String? state,
        String? city,
        String? zipCode,
        String? address,
    }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (mobile != null) {
      _mobile = mobile;
    }
    if (email != null) {
      _email = email;
    }
    if (image != null) {
      _image = image;
    }
    if (state != null) {
      _state = state;
    }
    if (city != null) {
      _city = city;
    }
    if (zipCode != null) {
      _zipCode = zipCode;
    }
    if (address != null) {
      _address = address;
    }

  }

  int? get id => _id;
  String? get name => _name;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get image => _image;
  String? get state => _state;
  String? get city => _city;
  String? get zipCode => _zipCode;


  Supplier.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['mobile'] = _mobile;
    data['email'] = _email;
    data['image'] = _image;
    data['state'] = _state;
    data['city'] = _city;
    data['zip_code'] = _zipCode;
    data['address'] = _address;

    return data;
  }
}
