import 'dart:async';
import 'package:get/get.dart';
import '../../modal/order_history_modal/invoice_popup_modal.dart';
import '../../repository/order_history_repository/invoice_popup_repo.dart';


int? orderId;
class InvoicePopupVm extends GetxController{
  List<InvoicePopupModal> invoiceDataListVm = [];
  var isLoading = true.obs;

  getInvoicePopupDataVm(int invoiceId)async{
    var invoiceData = await InvoicePopupRepo.getInvoicePopupData(invoiceId);
    if(invoiceData != null){
      invoiceDataListVm = invoiceData;
      isLoading.value = false;

    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    invoiceDataListVm.forEach((element) {
      orderId = element.orderId;
    });
    print(orderId);
    print(orderId);
    print(orderId);
    print(orderId);
  }

}