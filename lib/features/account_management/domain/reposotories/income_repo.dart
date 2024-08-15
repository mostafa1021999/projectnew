import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/account_management/domain/models/income_model.dart';
import 'package:six_pos/util/app_constants.dart';

class IncomeRepo{
  ApiClient apiClient;
  IncomeRepo({required this.apiClient});

  Future<Response> getIncomeList(int offset) async {
    return await apiClient.getData('${AppConstants.getInvoiceList}?limit=10&offset=$offset');
  }

  Future<Response> getIncomesFilter(String startDate, String endDate) async {
    return await apiClient.getData('${AppConstants.filterIncomeList}?from=$startDate&to=$endDate');
  }


  Future<Response> addNewIncome(Incomes income) async {
    return await apiClient.postData(AppConstants.addNewIncome,{
      'account_id': income.accountId,
      'amount': income.amount,
      'description': income.description,
      'date': income.date
    });
  }


}