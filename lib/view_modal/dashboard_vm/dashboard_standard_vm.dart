import 'dart:async';
import 'package:get/get.dart';
import '../../modal/dashboard_modal/dashboard_standard_modal.dart';
import '../../repository/dashbord_repository/dashboard_standard_repo.dart';

class DashboardStandardVM extends GetxController {
  var isLoading = true.obs;
  List<DashboardStandardModal> dashboardStandardList = [];
  getDashboardStandardInfo(int schoolId) async {
    var standardData = await DashboardStandardRepo.posStandardDetails(schoolId);
    if(standardData != null){
      dashboardStandardList = standardData;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
  }
}