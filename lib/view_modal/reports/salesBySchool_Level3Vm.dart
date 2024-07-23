import 'dart:async';
import 'package:get/get.dart';
import '../../modal/reports_modal/salesBySchool_Level3_modal.dart';
import '../../repository/reports/salesBySchoolLevel3_Repo.dart';



int? totalDivisionCount;
int? totalDivStudentCount;
class SalesBySchoolL3Vm extends GetxController{
  var isLoading = true.obs;
  List<SchoolReportsLevel3Modal> getSchoolSales3List = [];
  getSchoolSalesDetails2(int userId,int schoolId,int stdId,int divId,String fromDate, String toDate) async {
    var data = await SchoolReportsLevel3repo.getSchoolL3(userId, schoolId, stdId,divId,fromDate, toDate);
    print("!!!!!!!!!!!!!!!!!!!3$data");
    if(data != null){
      getSchoolSales3List = data;
      isLoading.value = false;
    } else {
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    getSchoolSales3List.forEach((element) {
      totalDivStudentCount = element.totalStudents;
      totalDivisionCount = element.totalDivision;
    });
  }
}