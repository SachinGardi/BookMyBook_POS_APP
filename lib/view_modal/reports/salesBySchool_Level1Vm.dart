import 'dart:async';

import 'package:get/get.dart';
import '../../modal/reports_modal/salesBySchool_Level1_modal.dart';
import '../../repository/reports/salesByschoolLevel1_Repo.dart';

class SalesBySchoolLevel1Vm extends GetxController{
  var isLoading = true.obs;
  List<SchoolSalesLevel1Modal> getSchoolSalesLevel1List = [];
  getSchoolSalesDetails(int userId,int schoolId,int stdId,int divId,String fromDate, String toDate,String textSearch) async {
    var data = await SalesSchoolLevel1Repo.getSalesLevel1(userId,schoolId,stdId,divId,fromDate,toDate,textSearch);
    print("!!!!!!!!!!!!!!!!!!!!$data");
    if(data != null){
      getSchoolSalesLevel1List = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
  }
}