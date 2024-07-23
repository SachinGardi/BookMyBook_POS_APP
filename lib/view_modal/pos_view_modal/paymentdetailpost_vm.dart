import 'dart:async';
import 'package:get/get.dart';

import '../../modal/pos_modal/paymentdetailpost_modal.dart';
import '../../repository/pos_repository/paymentdetailpost_repo.dart';

class PaymentDetailPostVm extends GetxController{
  var isLoading = true.obs;
  int? statusCode;
  String? statusMessage;
  addPaymentDetails(
      int id,
      String customerId,
      double subTotal,
      String discountType,
      double discount,
      String tax,
      int status,
      int createdBy,
      double totalAmount,
      double totalCGST,
      double totalSGST,
      List<BookDetail>bookDetails,
      ) async{
    var data =await PaymentDetailsRepo.postPaymentData(
      id,
      customerId,
      subTotal,
      discountType,
      discount,
      tax,
      status,
      createdBy,
      totalAmount,
        totalCGST,
        totalSGST,
        bookDetails
    );
    if(data!= null){
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    statusCode = PaymentDetailsRepo.statusCode;
    statusMessage = PaymentDetailsRepo.statusMessage;
  }
}