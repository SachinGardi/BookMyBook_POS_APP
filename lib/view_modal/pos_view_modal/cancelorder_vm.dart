import 'package:get/get.dart';

import '../../repository/pos_repository/cancel_order_repo.dart';

class  CancelOrderVm extends GetxController{
  int? statusCode;
  String? statusMessage;
  cancelOrderVmFunction(String orderId,String remark) async {
     await CancelOrderRepo.cancelOrder(orderId,remark);
    statusCode = CancelOrderRepo.statusCode;
    statusMessage = CancelOrderRepo.statusMessage;
  }

}