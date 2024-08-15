import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/account_management/domain/models/expense_model.dart';
import 'package:six_pos/util/app_constants.dart';



class ExpenseRepo{
  ApiClient apiClient;
  ExpenseRepo({required this.apiClient});

  Future<Response> getExpenseList(int offset) async {
    return await apiClient.getData('${AppConstants.getExpenseListUri}?limit=10&offset=$offset');
  }

  Future<Response> getExpenseFilter(String startDate, String endDate) async {
    return await apiClient.getData('${AppConstants.expenseFilterByDate}?from=$startDate&to=$endDate');
  }

  Future<Response> deleteExpense(int expenseId) async {
    return await apiClient.getData('${AppConstants.deleteExpenseUri}?id=$expenseId');
  }

  Future<Response> addNewExpense(Expenses expense, { bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate? AppConstants.updateExpenseUri :AppConstants.addNewExpense,{
      'id': expense.id,
      'account_id': expense.accountId,
      'amount': expense.amount,
      'description': expense.description,
      'date': expense.date
    });
  }


}