import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/common/models/place_order_model.dart';
import 'package:six_pos/util/app_constants.dart';

class CartRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CartRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getCouponDiscount(String couponCode, int? userId, double orderAmount) async {
    return await apiClient.getData('${AppConstants.getCouponDiscount}?code=$couponCode&user_id=$userId&order_amount=$orderAmount');
  }

  Future<Response> placeOrder(PlaceOrderModel placeOrderBody) async {
    return await apiClient.postData(AppConstants.placeOrderUri, placeOrderBody.toJson());
  }

  Future<Response> getProductByCode(String? productCode) async {
    return await apiClient.getData('${AppConstants.getProductFromProduceCodeUri}?product_code=$productCode');
  }

  Future<Response> getCustomerByName(String name) async {
    return await apiClient.getData('${AppConstants.customerSearchUri}?name=$name');
  }

}