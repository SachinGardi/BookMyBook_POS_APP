import 'dart:async';
import 'package:get/get.dart';
import '../../modal/reports_modal/pending_Level2_modal.dart';
import '../../repository/reports/pending_level2_repo.dart';

class PendingLevel2ReportVm extends GetxController {
  var isLoading = true.obs;
  List<PendingReportsLevel2Modal> pendingLevel2List = [];
  getReportLevel2Detail(String pageNo,String pageSize,int userId,int schoolId,int stdId,int booksetId,int divId,String fromDate,String toDate) async {
    var data = await PendingLevel2Repo.getPendingLevel2(pageNo,pageSize,userId, schoolId,stdId,booksetId,divId,fromDate,toDate);
    print("!!!!!!!!!!!!!!!!!!!!$data");
    if(data != null){
      pendingLevel2List = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
  }
}