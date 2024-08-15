import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/common/models/account_model.dart';
import 'package:six_pos/util/app_constants.dart';



class AccountRepo{
  ApiClient apiClient;
  AccountRepo({required this.apiClient});

  Future<Response> getAccountList(int offset) async {
    return await apiClient.getData('${AppConstants.getAccountListUri}?limit=10&offset=$offset');
  }

  Future<Response> searchAccount(String search) async {
    return await apiClient.getData('${AppConstants.searchAccountUri}?name=$search');
  }

  Future<Response> deleteAccountId(int? accountId) async {
    return await apiClient.getData('${AppConstants.deleteAccountUri}?id=$accountId');
  }

  Future<Response> addAccount(Accounts account, {bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate ? AppConstants.updateAccountUri : AppConstants.addNewAccount,{
      'id': account.id,
      'account': account.account,
      'description': account.description,
      'balance': account.balance,
      'account_number': account.accountNumber,


    });
  }

  Future<Response> getRevenueChartData() async {
    return await apiClient.getData(AppConstants.getRevenueChartData);
  }


}