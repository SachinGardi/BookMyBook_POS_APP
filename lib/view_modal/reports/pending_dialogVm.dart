import 'package:get/get.dart';
import '../../modal/reports_modal/pending_dialog_modal.dart';
import '../../repository/reports/pending_dialog_repo.dart';


int? pendingOrderId;
double? pendingOrderValue;



class PendingDialogVm extends GetxController{
  List<PendingDialogModal> pendingDialogListVm = [];
  List<PendingBooklist> pendingBookListVm = [];
  var isLoading = true.obs;

  getPendingBookDetail(int orderId) async {
    var bookDetails = await PendingDialogRepo.getPendingDialogDetails(orderId);
    print(bookDetails);
    if(bookDetails != null){
      pendingDialogListVm = bookDetails;
      isLoading.value = false;
    }
    pendingDialogListVm.forEach((element) {
      pendingOrderValue = element.orderValue;
      pendingBookListVm = element.pendingBooklist;
    });
  }
}