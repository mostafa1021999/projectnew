import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/order/domain/models/invoice_model.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/features/order/domain/reposotories/order_repo.dart';

class OrderController extends GetxController implements GetxService{
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;


  Invoice? _invoice;
  Invoice? get invoice => _invoice;

  double _discountOnProduct = 0;
  double _subTotalProductAmount = 0;

  double get subTotalProductAmount => _subTotalProductAmount;
  double get discountOnProduct => _discountOnProduct;

  double _totalTaxAmount = 0;
  double get totalTaxAmount => _totalTaxAmount;



  Future<void> getOrderList(int? offset, {bool isUpdate = true}) async {

    if(offset == 1) {
      _orderModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await orderRepo.getOrderList(offset);

    if(response.statusCode == 200) {
      if(offset == 1) {
        _orderModel = OrderModel.fromJson(response.body);
      }else {
        _orderModel?.offset = OrderModel.fromJson(response.body).offset;
        _orderModel?.totalSize = OrderModel.fromJson(response.body).totalSize;
        _orderModel?.orderList?.addAll(OrderModel.fromJson(response.body).orderList ?? []);

      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> getInvoiceData(int? orderId) async {
    Response response = await orderRepo.getInvoiceData(orderId);
    if(response.statusCode == 200) {
      _discountOnProduct = 0;
      _totalTaxAmount = 0;
      _subTotalProductAmount = 0;

     _invoice = InvoiceModel.fromJson(response.body).invoice;

     for(int i = 0; i < (_invoice?.details?.length ?? 0); i++ ){
       _subTotalProductAmount += (invoice!.details![i].price!) * (invoice!.details![i].quantity!);
       _discountOnProduct += (invoice!.details![i].discountOnProduct!) * (invoice!.details![i].quantity!);
       _totalTaxAmount += (invoice!.details![i].taxAmount!) * (invoice!.details![i].quantity!);
     }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  String? getBluetoothMacAddress() => orderRepo.getBluetoothAddress();

  void setBluetoothMacAddress(String? address) => orderRepo.setBluetoothAddress(address);


}