import 'package:get/get.dart';
import '../../../common/reposotories/report_repo.dart';
import '../../../data/api/api_checker.dart';

class ReportController extends GetxController implements GetxService{
  final ReportRepo reportRepo;
  ReportController({required this.reportRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> get reportList => [
    'log_activities'.tr,
    'sales_report'.tr,
    'performance_report'.tr,
    'client_report'.tr,
    'top_sale_report'.tr,
    'receipt_report'.tr,
    'inventory_report'.tr,
    'low_product_report'.tr,
    'expense_report'.tr,
    'earning_report'.tr,
    'purchasing_report'.tr,
    'income_report'.tr,
    'vat_report'.tr,
  ];

  Future<String?> getTopProductReport(String startDate, String endDate,String keyList,String lang) async {
    _isLoading = true;
    update(); // Notify listeners that loading has started

    try {
      Response response = await reportRepo.getLowProductReport(startDate, endDate,keyList,lang);

      if (response.statusCode == 200) {
        return response.body['url'];
      } else {
        Get.back();
        ApiChecker.checkApi(response);
        return null;
      }
    } catch (e) {

      return null;
    } finally {
      // Ensure loading is stopped in case of success or failure
      _isLoading = false;
      update(); // Notify listeners that loading has stopped
    }
  }
  Future<String?> getLowProductReport(String startDate, String endDate,String keyList,String lang) async {
    _isLoading = true;
    update(); // Notify listeners that loading has started

    try {
      Response response = await reportRepo.getLowProductReport(startDate, endDate,keyList,lang);

      if (response.statusCode == 200) {
        return response.body['url'];
      } else {
        Get.back();
        ApiChecker.checkApi(response);
        return null;
      }
    } catch (e) {

      return null;
    } finally {
      // Ensure loading is stopped in case of success or failure
      _isLoading = false;
      update(); // Notify listeners that loading has stopped
    }
  }
  Future<String?> getUserActivitiesReport(String startDate, String endDate,String lang,{String? userId}) async {
    _isLoading = true;
    update(); // Notify listeners that loading has started

    try {
      Response response = await reportRepo.getUserActivitiesReport(startDate, endDate,lang,filterId: userId ?? userId );
      if (response.statusCode == 200) {
        return response.body['pdf_url'];
      } else {
        Get.back();
        ApiChecker.checkApi(response);
        return null;
      }
    } catch (e) {

      return null;
    } finally {
      // Ensure loading is stopped in case of success or failure
      _isLoading = false;
      update(); // Notify listeners that loading has stopped
    }
  }
}