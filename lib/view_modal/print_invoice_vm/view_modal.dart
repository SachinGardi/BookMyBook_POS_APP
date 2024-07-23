
import 'package:get/get.dart';
import '../../modal/print_invoice_modal/modal.dart';
import '../../repository/print_invoice_repo/repository.dart';



String? payment;
String? invoiceNo;
DateTime? invoiceDatee;
String? schoolName;
String? studentName;
String? standard;
String? items;
double? subTotal;
double? total;
double? discount;
String? remark;
int? totalQty;
String? customerMobileNo;


class PrintReceiptVm extends GetxController{
  List<PrintInvoiceModal> receiptListVm = [];
  List<ItemList> itemListVm = [];
  List<GstBreakUp> gstBreakUpVm = [];
  List<PendingItemList> pendingItemListVm = [];
  var isLoading = true.obs;

  getReceiptDetail(String invoiceId) async {
    var receiptDetail = await PrintReceiptRepo.getReceiptDetails(invoiceId);
    print(receiptDetail);
    if(receiptDetail != null){
      receiptListVm = receiptDetail;
      isLoading.value = false;
    }

    receiptListVm.forEach((element) {
      payment = element.payment;
      invoiceNo = element.invoiceNo;
      studentName = element.studentName;
      schoolName = element.schoolName;
      standard = element.standard;
      invoiceDatee = element.invoiceDate;
      subTotal = element.subTotal;
      total = element.totalAmount;
      remark = element.remark;
      totalQty = element.totalQty;
      discount = element.discount;
      customerMobileNo = element.customerMobileNo;
      itemListVm = element.itemList;
      gstBreakUpVm = element.gstBreakUp;
      pendingItemListVm = element.pendingItemList;
    });
    print(payment);
    // itemListVm.forEach((element) {
    //   items = element.item;
    // });

  }

}
