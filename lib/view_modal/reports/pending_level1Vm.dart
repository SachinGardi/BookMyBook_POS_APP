import 'dart:async';

import 'package:get/get.dart';

import '../../modal/reports_modal/pending_Level1_modal.dart';
import '../../repository/reports/pending_level1_repo.dart';



int? pendingL1Pages;
int? pendingL1Count;
class PendingLevel1Vm extends GetxController{
  var isLoading = true.obs;
  List<PendingLevel1Modal> pendingLevel1List = [];
  getPendingLevel1Detail(String pageNo,String pageSize,int userId,int schoolId,int stdId,int divId,String fromDate,String toDate) async {
    var data = await PendingRepoLevel1.getPendingLevel1(pageNo, pageSize, userId,schoolId,stdId,divId,fromDate,toDate);
    print("!!!!!!!!!!!!!!!!!!!!$data");
    if(data != null){
      pendingLevel1List = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    pendingLevel1List.forEach((element) {
      for(var pageDetails in element.pendingL1PageModalList!){
        pendingL1Pages = pageDetails.totalPages;
        pendingL1Count = pageDetails.totalCount;
      }
    });
  }
}