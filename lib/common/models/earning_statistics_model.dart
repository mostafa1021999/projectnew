class RevenueChartModel {
  List<YearWiseExpense>? _yearWiseExpense;
  List<YearWiseIncome>? _yearWiseIncome;

  RevenueChartModel(
      {List<YearWiseExpense>? yearWiseExpense,
        List<YearWiseIncome>? yearWiseIncome}) {
    if (yearWiseExpense != null) {
      _yearWiseExpense = yearWiseExpense;
    }
    if (yearWiseIncome != null) {
      _yearWiseIncome = yearWiseIncome;
    }
  }

  List<YearWiseExpense>? get yearWiseExpense => _yearWiseExpense;
  List<YearWiseIncome>? get yearWiseIncome => _yearWiseIncome;

  RevenueChartModel.fromJson(Map<String, dynamic> json) {
    if (json['year_wise_expense'] != null) {
      _yearWiseExpense = <YearWiseExpense>[];
      json['year_wise_expense'].forEach((v) {
        _yearWiseExpense!.add(YearWiseExpense.fromJson(v));
      });
    }
    if (json['year_wise_income'] != null) {
      _yearWiseIncome = <YearWiseIncome>[];
      json['year_wise_income'].forEach((v) {
        _yearWiseIncome!.add(YearWiseIncome.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_yearWiseExpense != null) {
      data['year_wise_expense'] =
          _yearWiseExpense!.map((v) => v.toJson()).toList();
    }
    if (_yearWiseIncome != null) {
      data['year_wise_income'] =
          _yearWiseIncome!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YearWiseExpense {
  double? _totalAmount;
  int? _year;
  int? _month;

  YearWiseExpense({double? totalAmount, int? year, int? month}) {
    if (totalAmount != null) {
      _totalAmount = totalAmount;
    }
    if (year != null) {
      _year = year;
    }
    if (month != null) {
      _month = month;
    }
  }

  double? get totalAmount => _totalAmount;
  int? get year => _year;
  int? get month => _month;


  YearWiseExpense.fromJson(Map<String, dynamic> json) {
    if(json['total_amount'] != null){
      try{
        _totalAmount = json['total_amount'].toDouble();
      }catch(e){
        _totalAmount = double.parse(json['total_amount'].toString());
      }
    }

    if(json['year'] != null){
      _year = int.parse(json['year'].toString());
    }
    if(json['month'] != null){
      _month = int.parse(json['month'].toString());
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_amount'] = _totalAmount;
    data['year'] = _year;
    data['month'] = _month;
    return data;
  }
}

class YearWiseIncome {
  double? _totalAmount;
  int? _year;
  int? _month;

  YearWiseIncome({double? totalAmount, int? year, int? month}) {
    if (totalAmount != null) {
      _totalAmount = totalAmount;
    }
    if (year != null) {
      _year = year;
    }
    if (month != null) {
      _month = month;
    }
  }

  double? get totalAmount => _totalAmount;
  int? get year => _year;
  int? get month => _month;

  YearWiseIncome.fromJson(Map<String, dynamic> json) {
    if(json['total_amount'] != null){
      try{
        _totalAmount = json['total_amount'].toDouble();
      }catch(e){
        _totalAmount = double.parse(json['total_amount'].toString());
      }
    }

    if(json['year'] != null){
      _year = int.parse(json['year'].toString());
    }
    if(json['month'] != null){
      _month = int.parse(json['month'].toString());
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_amount'] = _totalAmount;
    data['year'] = _year;
    data['month'] = _month;
    return data;
  }
}
