import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/account_management/domain/models/transaction_model.dart';
import 'package:six_pos/util/app_constants.dart';



class TransactionRepo{
  ApiClient apiClient;
  TransactionRepo({required this.apiClient});


  Future<Response> getTransactionAccountList(int offset) async {
    return await apiClient.getData('${AppConstants.transactionAccountListUri}?limit=10&offset=$offset');
  }

  Future<Response> getCustomerWiseTransactionList(int? customerId ,int offset) async {
    return await apiClient.getData('${AppConstants.customerWiseTransactionListUri}?customer_id=$customerId&limit=10&offset=$offset');
  }



  Future<Response> getTransactionTypeList() async {
    return await apiClient.getData(AppConstants.transactionTypeListUri);
  }

  Future<Response> getTransactionList(int offset) async {
    return await apiClient.getData('${AppConstants.transactionListUri}?limit=10&offset=$offset');
  }

  Future<Response> exportTransactionList(String startDate, String endDate, int accountId, String transactionType) async {
    return await apiClient.getData('${AppConstants.transactionListExportUri}?from=$startDate&to=$endDate&account_id=$accountId&transaction_type=$transactionType');
  }

  Future<Response> getTransactionFilter(String startDate, String endDate, int? accountId, String? transactionType,int offset) async {

    String? params = 'limit=10&offset=$offset';

    if(startDate.isNotEmpty) {
      params = '$params${'&from=$startDate&to=$endDate'}';
    }

    if(accountId != null) {
      params = '$params${'&account_id=$accountId'}';

    }

    if(transactionType != null) {
      params = '$params${'&tran_type=$transactionType'}';

    }

    return await apiClient.getData('${AppConstants.transactionFilterUri}?$params');
  }


  Future<Response> addNewTransaction(Transfers transfer, int? fromAccountId, int? toAccountId) async {
    return await apiClient.postData(AppConstants.transactionAddUri,{
      'account_from_id': fromAccountId,
      'account_to_id': toAccountId,
      'amount': transfer.amount,
      'description': transfer.description,
      'date' : transfer.date
    });
  }


}