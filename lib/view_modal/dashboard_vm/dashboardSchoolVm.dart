import 'dart:async';
import 'package:get/get.dart';
import '../../modal/dashboard_modal/dashboard_school_modal.dart';
import '../../modal/pos_modal/get_schoolby_user_modal.dart';
import '../../repository/dashbord_repository/dashboard_school_repo.dart';
import '../../repository/pos_repository/getschoolbyuser_repo.dart';

class DashboardSchoolByUserVM  extends GetxController{
  List<DashboardSchoolModal>  dashboardSchoolDetailList = [];
  var isLoading = true.obs;
  getDashboardSchoolByUser(String userId)async{
    var data = await DashboardSchoolRepo.getSchoolDetails(userId);
    if(data!= null){
      dashboardSchoolDetailList = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 1), () {
        isLoading.value = false;
      });
    }


  }


}