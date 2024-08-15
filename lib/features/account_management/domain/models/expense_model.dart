class ExpenseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Expenses>? expensesList;

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total']}');
    limit = int.parse(json['limit'].toString());
    offset = int.parse(json['offset'].toString());
    if (json['expenses'] != null) {
      expensesList = <Expenses>[];
      json['expenses'].forEach((v) {
        expensesList!.add(Expenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (expensesList != null) {
      data['expenses'] = expensesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expenses {
  int? _id;
  String? _tranType;
  int? _accountId;
  double? _amount;
  String? _description;
  double? _debit;
  double? _credit;
  double? _balance;
  String? _date;
  String? _createdAt;
  String? _updatedAt;
  Account? _account;


  Expenses(
      {int? id,
        String? tranType,
        int? accountId,
        double? amount,
        String? description,
        double? debit,
        double? credit,
        double? balance,
        String? date,
        String? createdAt,
        String? updatedAt,
        Account? account
      }) {
    if (id != null) {
      _id = id;
    }
    if (tranType != null) {
      _tranType = tranType;
    }
    if (accountId != null) {
      _accountId = accountId;
    }
    if (amount != null) {
      _amount = amount;
    }
    if (description != null) {
      _description = description;
    }
    if (debit != null) {
      _debit = debit;
    }
    if (credit != null) {
      _credit = credit;
    }
    if (balance != null) {
      _balance = balance;
    }
    if (date != null) {
      _date = date;
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
  String? get tranType => _tranType;
  int? get accountId => _accountId;
  double? get amount => _amount;
  String? get description => _description;
  double? get debit => _debit;
  double? get credit => _credit;
  double? get balance => _balance;
  String? get date => _date;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Account? get account => _account;

  Expenses.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _tranType = json['tran_type'];
    if(json['account_id'] != null){
      _accountId = int.parse(json['account_id'].toString());
    }

    if(json['amount'] != null){
      try{
        _amount = json['amount'].toDouble();
      }catch(e){
        _amount = double.parse(json['amount'].toString());
      }

    }else{
      _amount = 0.0;
    }

    _description = json['description'];
    if(json['debit'] != null){
      try{
        _debit = json['debit'].toDouble();
      }catch(e){
        _debit = double.parse(json['debit'].toString());
      }

    }else{
      _debit =0.0;
    }
    if(json['credit'] != null){
      try{
        _credit = json['credit'].toDouble();
      }catch(e){
        _credit = double.parse(json['credit'].toString());
      }

    }else{
      _credit =0.0;
    }

    if(json['balance'] != null){
      try{
        _balance = json['balance'].toDouble();
      }catch(e){
        _balance = double.parse(json['balance'].toString());
      }

    }else{
      _balance = 0.0;
    }

    _date = json['date'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _account = json['account'] != null ? Account.fromJson(json['account']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['tran_type'] = _tranType;
    data['account_id'] = _accountId;
    data['amount'] = _amount;
    data['description'] = _description;
    data['debit'] = _debit;
    data['credit'] = _credit;
    data['balance'] = _balance;
    data['date'] = _date;
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