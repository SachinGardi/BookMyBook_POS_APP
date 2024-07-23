import 'dart:async';
import 'package:get/get.dart';
import '../../modal/reports_modal/salesBySchool_Level2_modal.dart';
import '../../repository/reports/salesBySchoolLevel2_Repo.dart';


int? totalStandardCount;
class SalesBySchoolL2Vm extends GetxController{
  var isLoading = true.obs;
  List<SchoolReportsLevel2Modal> getSchoolSales2List = [];
  getSchoolSalesDetails2(int userId,int schoolId,int stdId,int divId,String fromDate, String toDate) async {
    var data = await SchoolReportsLevel2.getSchoolL2(userId, schoolId,stdId,divId,fromDate,toDate);
    print("!!!!!!!!!!!!!!!!!!!2$data");
    if(data != null){
      getSchoolSales2List = data;
      isLoading.value = false;
    } else {
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    getSchoolSales2List.forEach((element) {
      totalStandardCount = element.totalStandard;
    });
  }
}