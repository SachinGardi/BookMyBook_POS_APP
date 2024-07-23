import 'dart:async';
import 'package:get/get.dart';
import '../../modal/reports_modal/transaction_modal.dart';
import '../../repository/reports/transaction_repo.dart';


int? transactionPages;
int? transactionPageCount;
class TransactionHistoryVm extends GetxController {
  var isLoading = true.obs;
  List<TransactionReportModal> transactionHistoryList =[];
  List<TransactionPageModal> transactionPaginationList =[];
  getTransactionDetail(String pageNo,String pageSize,String fromDate,String toDate,int userId,int schoolId,int stdId,int divId,String mobileNo,textSearch) async {
    var data = await TransactionRepo.getTransaction(pageNo,pageSize,fromDate,toDate,userId,schoolId,stdId,divId,mobileNo,textSearch);
    print("!!!!!!!!!!!!!!!!!!!!$data");
    if(data != null){
      transactionHistoryList = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 1),(){
        isLoading.value = false;
      });
    }
    transactionHistoryList.forEach((element) {
      for (var pageDetail in element.transactionPageList!) {
        transactionPages = pageDetail.totalPages;
        transactionPageCount = pageDetail.totalCount;
      }
      print(transactionPageCount);
    });
  }
}