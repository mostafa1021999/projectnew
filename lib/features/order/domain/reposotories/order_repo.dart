import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';

class OrderRepo{
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getOrderList(int? offset) async {
    return await apiClient.getData('${AppConstants.orderListUri}?limit=10&offset=$offset');
  }

  Future<Response> getInvoiceData(int? orderId) async {
    return await apiClient.getData('${AppConstants.invoice}?order_id=$orderId');
  }

  Future<void> setBluetoothAddress(String? address) async {
    await sharedPreferences.setString(AppConstants.bluetoothMacAddress, address ?? '');
  }
  String? getBluetoothAddress() => sharedPreferences.getString(AppConstants.bluetoothMacAddress);
}