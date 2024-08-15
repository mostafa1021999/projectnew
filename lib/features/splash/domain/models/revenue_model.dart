class RevenueModel {
  RevenueSummary? _revenueSummary;

  RevenueModel({RevenueSummary? revenueSummary}) {
    if (revenueSummary != null) {
      _revenueSummary = revenueSummary;
    }
  }

  RevenueSummary? get revenueSummary => _revenueSummary;

  RevenueModel.fromJson(Map<String, dynamic> json) {
    _revenueSummary = json['revenueSummary'] != null?
         RevenueSummary.fromJson(json['revenueSummary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_revenueSummary != null) {
      data['revenueSummary'] = _revenueSummary!.toJson();
    }
    return data;
  }
}

class RevenueSummary {
  double? _totalIncome;
  double? _totalExpense;
  double? _totalPayable;
  double? _totalReceivable;

  RevenueSummary(
      {double? totalIncome,
        double? totalExpense,
        double? totalPayable,
        double? totalReceivable}) {
    if (totalIncome != null) {
      _totalIncome = totalIncome;
    }
    if (totalExpense != null) {
      _totalExpense = totalExpense;
    }
    if (totalPayable != null) {
      _totalPayable = totalPayable;
    }
    if (totalReceivable != null) {
      _totalReceivable = totalReceivable;
    }
  }

  double? get totalIncome => _totalIncome;
  double? get totalExpense => _totalExpense;
  double? get totalPayable => _totalPayable;
  double? get totalReceivable => _totalReceivable;

  RevenueSummary.fromJson(Map<String, dynamic> json) {
    if(json['totalIncome'] != null){
      try{
        _totalIncome = json['totalIncome'].toDouble();
      }catch(e){
        _totalIncome = double.parse(json['totalIncome'].toString());
      }

    }
    if(json['totalExpense'] != null){
      try{
        _totalExpense = json['totalExpense'].toDouble();
      }catch(e){
        _totalExpense = double.parse(json['totalExpense'].toString());
      }
    }

    if(json['totalPayable'] != null){
      try{
        _totalPayable = json['totalPayable'].toDouble();
      }catch(e){
        _totalPayable = double.parse(json['totalPayable'].toString());
      }
    }
    if(json['totalReceivable'] != null){
      try{
        _totalReceivable = json['totalReceivable'].toDouble();
      }catch(e){
        _totalReceivable = double.parse(json['totalReceivable'].toString());
      }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalIncome'] = _totalIncome;
    data['totalExpense'] = _totalExpense;
    data['totalPayable'] = _totalPayable;
    data['totalReceivable'] = _totalReceivable;
    return data;
  }
}
