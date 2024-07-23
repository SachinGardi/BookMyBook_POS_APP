

import 'package:get/get.dart';
import '../../modal/pos_modal/payment_summary_modal.dart';
import '../../repository/pos_repository/getpayment_summary_repo.dart';

String? payStudentsName;
String? pStandards ;
String? pDivisions;
String? pTotalQtys;
String? pTotalAmounts;
class GetPaymentSummaryVm extends GetxController {
  List<PaymentSummaryModal> getPaymentSummaryList = [];

  var isLoading = true.obs;

  getPaymentSummaryDetails(String id) async {
    var paymentDetail = await PaymentSummaryRepo.getSummary(id);
    print("------------$paymentDetail");
    if (paymentDetail != null) {
      getPaymentSummaryList = paymentDetail;
      isLoading.value = false;
    }
    print(getPaymentSummaryList);
    getPaymentSummaryList.forEach((element) {
      payStudentsName = element.studentName;
      pStandards = element.standard;
      pDivisions = element.division;
      pTotalQtys = element.totalQty.toString();
      pTotalAmounts = element.totalAmount.toString();
    });
    print("studentsName : $payStudentsName");
  }
}
