import 'package:get/get.dart';
import '../../repository/pos_repository/confirm_invoice_repo.dart';

class ConfirmInvoiceVm extends GetxController{
  var isLoading = true.obs;
   int? statusCode;
   int? invoiceId;
   String? statusMessage;

  confirmInvoice(int id, int orderId, int totalQty, double totalAmount, String paymentMode, String remark, bool isPrintReceipt, int createdBy) async {
    await ConfirmInvoiceRepo.confirmInvoiceData(
        id,
        orderId,
        totalQty,
        totalAmount,
        paymentMode,
        remark,
        isPrintReceipt,
        createdBy
    );
    statusCode = ConfirmInvoiceRepo.statusCode;
    statusMessage = ConfirmInvoiceRepo.statusMessage;
    invoiceId = ConfirmInvoiceRepo.invoiceId;
  }
}