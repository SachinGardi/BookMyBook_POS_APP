import 'dart:async';
import 'package:get/get.dart';
import '../../modal/pos_modal/get_schoolby_user_modal.dart';
import '../../repository/pos_repository/getschoolbyuser_repo.dart';

class GetSchoolByUserVM  extends GetxController{
  List<GetSchoolByUserIdModal>  schoolDetailList = [];
  List<GetSchoolByUserIdModal>  dashboardSchoolDetailList = [];
  var isLoading = true.obs;

  getSchoolByUser(String userId)async{
    var data = await GetSchoolByUserRepo.getSchoolDetails(userId);
    if(data!= null){
      schoolDetailList = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 1), () {
        isLoading.value = false;
      });
    }


  }

}