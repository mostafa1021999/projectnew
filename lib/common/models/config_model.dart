class ConfigModel {
  BusinessInfo? _businessInfo;
  BaseUrls? _baseUrls;
  String? _currencySymbol;
  List<String>? _timeZones;
  List<String>? _permissionModule;

  ConfigModel({BusinessInfo? businessInfo, BaseUrls? baseUrls, String? currencySymbol,List<String>? timeZone, List<String>? permissionModule}) {
    if (businessInfo != null) {
      _businessInfo = businessInfo;
    }
    if (baseUrls != null) {
      _baseUrls = baseUrls;
    }
    if (currencySymbol != null) {
      _currencySymbol = currencySymbol;
    }
    if (timeZone != null) {
      _timeZones = timeZone;
    }
    if (permissionModule != null) {
      _permissionModule = permissionModule;
    }
  }

  BusinessInfo? get businessInfo => _businessInfo;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  List<String>? get timeZone => _timeZones;
  List<String>? get permissionModule => _permissionModule;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _businessInfo = json['business_info'] != null
        ? BusinessInfo.fromJson(json['business_info'])
        : null;
    _baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _timeZones =  json["time_zone"] == null ? [] : List<String>.from(json["time_zone"]!.map((x) => x));
    _permissionModule =  json["role"] == null ? [] : List<String>.from(json["role"]!.map((x) => x));
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_businessInfo != null) {
      data['business_info'] = _businessInfo!.toJson();
    }
    if (_baseUrls != null) {
      data['base_urls'] = _baseUrls!.toJson();
    }
    data['currency_symbol'] = _currencySymbol;
    data['time_zone'] = _timeZones;
    data['role'] = _permissionModule;
    return data;
  }
}

class BusinessInfo {
  String? _shopLogo;
  String? _paginationLimit;
  String? _currency;
  String? _shopName;
  String? _shopAddress;
  String? _shopPhone;
  String? _shopEmail;
  String? _footerText;
  String? _country;
  String? _stockLimit;
  String? _timeZone;
  String? _vat;


  BusinessInfo(
      {String? shopLogo,
        String? paginationLimit,
        String? currency,
        String? shopName,
        String? shopAddress,
        String? shopPhone,
        String? shopEmail,
        String? footerText,
        String? country,
        String? stockLimit,
        String? timeZone,
        String? vat,

      }) {
    if (shopLogo != null) {
      _shopLogo = shopLogo;
    }
    if (paginationLimit != null) {
      _paginationLimit = paginationLimit;
    }
    if (currency != null) {
      _currency = currency;
    }
    if (shopName != null) {
      _shopName = shopName;
    }
    if (shopAddress != null) {
      _shopAddress = shopAddress;
    }
    if (shopPhone != null) {
      _shopPhone = shopPhone;
    }
    if (shopEmail != null) {
      _shopEmail = shopEmail;
    }
    if (footerText != null) {
      _footerText = footerText;
    }
    if (country != null) {
      _country = country;
    }
    if (stockLimit != null) {
      _stockLimit = stockLimit;
    }
    if (timeZone != null) {
      _timeZone = timeZone;
    }
    if (vat != null) {
      _vat = vat;
    }

  }

  String? get shopLogo => _shopLogo;
  String? get paginationLimit => _paginationLimit;
  String? get currency => _currency;
  String? get shopName => _shopName;
  String? get shopAddress => _shopAddress;
  String? get shopPhone => _shopPhone;
  String? get shopEmail => _shopEmail;
  String? get footerText => _footerText;
  String? get country => _country;
  String? get stockLimit => _stockLimit;
  String? get timeZone => _timeZone;
  String? get vat => _vat;


  BusinessInfo.fromJson(Map<String, dynamic> json) {
    _shopLogo = json['shop_logo'];
    _paginationLimit = json['pagination_limit'];
    _currency = json['currency'];
    _shopName = json['shop_name'];
    _shopAddress = json['shop_address'];
    _shopPhone = json['shop_phone'];
    _shopEmail = json['shop_email'];
    _footerText = json['footer_text'];
    _country = json['country'];
    _stockLimit = json['stock_limit'];
    _timeZone = json['time_zone'];
    _vat = json['vat_reg_no'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop_logo'] = _shopLogo;
    data['pagination_limit'] = _paginationLimit;
    data['currency'] = _currency;
    data['shop_name'] = _shopName;
    data['shop_address'] = _shopAddress;
    data['shop_phone'] = _shopPhone;
    data['shop_email'] = _shopEmail;
    data['footer_text'] = _footerText;
    data['country'] = _country;
    data['stock_limit'] = _stockLimit;
    data['time_zone'] = _timeZone;
    data['vat_reg_no'] = _vat;

    return data;
  }
}

class BaseUrls {
  String? _categoryImageUrl;
  String? _brandImageUrl;
  String? _productImageUrl;
  String? _supplierImageUrl;
  String? _shopImageUrl;
  String? _adminImageUrl;
  String? _customerImageUrl;

  BaseUrls(
      {String? categoryImageUrl,
        String? brandImageUrl,
        String? productImageUrl,
        String? supplierImageUrl,
        String? shopImageUrl,
        String? adminImageUrl,
        String? customerImageUrl,
      }) {
    if (categoryImageUrl != null) {
      _categoryImageUrl = categoryImageUrl;
    }
    if (brandImageUrl != null) {
      _brandImageUrl = brandImageUrl;
    }
    if (productImageUrl != null) {
      _productImageUrl = productImageUrl;
    }
    if (supplierImageUrl != null) {
      _supplierImageUrl = supplierImageUrl;
    }
    if (shopImageUrl != null) {
      _shopImageUrl = shopImageUrl;
    }
    if(adminImageUrl != null){
      _adminImageUrl = adminImageUrl;
    }
    if(customerImageUrl != null){
      _customerImageUrl = customerImageUrl;
    }
  }

  String? get categoryImageUrl => _categoryImageUrl;
  String? get brandImageUrl => _brandImageUrl;
  String? get productImageUrl => _productImageUrl;
  String? get supplierImageUrl => _supplierImageUrl;
  String? get shopImageUrl => _shopImageUrl;
  String? get adminImageUrl => _adminImageUrl;
  String? get customerImageUrl => _customerImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _categoryImageUrl = json['category_image_url'];
    _brandImageUrl = json['brand_image_url'];
    _productImageUrl = json['product_image_url'];
    _supplierImageUrl = json['supplier_image_url'];
    _shopImageUrl = json['shop_image_url'];
    _adminImageUrl = json['admin_image_url'];
    _customerImageUrl = json['customer_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_image_url'] = _categoryImageUrl;
    data['brand_image_url'] = _brandImageUrl;
    data['product_image_url'] = _productImageUrl;
    data['supplier_image_url'] = _supplierImageUrl;
    data['shop_image_url'] = _shopImageUrl;
    data['admin_image_url'] = _adminImageUrl;
    data['admin_image_url'] = _customerImageUrl;
    return data;
  }
}
