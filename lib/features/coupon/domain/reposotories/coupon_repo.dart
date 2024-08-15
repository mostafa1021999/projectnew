import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/coupon/domain/models/coupon_model.dart';
import 'package:six_pos/util/app_constants.dart';



class CouponRepo{
  ApiClient apiClient;
  CouponRepo({required this.apiClient});

  Future<Response> getCouponList(int offset) async {
    return await apiClient.getData('${AppConstants.getCouponListUri}?limit=10&offset=$offset');
  }

  Future<Response> addNewCoupon(Coupons coupon, {bool update = false}) async {

    return await apiClient.postData(update ? AppConstants.updateCouponUri : AppConstants.addNewCoupon,{
      'id':coupon.id,
      'title': coupon.title,
      'coupon_type': coupon.couponType,
      'user_limit': coupon.userLimit,
      'code': coupon.couponCode,
      'start_date': coupon.startDate,
      'expire_date': coupon.expireDate,
      'min_purchase': coupon.minPurchase,
      'max_discount': coupon.maxDiscount,
      'discount': coupon.discount,
      'discount_type': coupon.discountType,
      '_method': update?'put' : 'post'
    });

  }

  Future<Response> toggleCouponStatus(int? couponId, int status) async {
    return await apiClient.getData('${AppConstants.updateCouponStatus}?id=$couponId&status=$status');
  }

  Future<Response> deleteCoupon(int? couponId) async {
    return await apiClient.getData('${AppConstants.deleteCouponUri}?id=$couponId');
  }

}