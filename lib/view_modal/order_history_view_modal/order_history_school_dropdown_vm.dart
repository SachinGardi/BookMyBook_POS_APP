
import 'dart:async';

import 'package:get/get.dart';
import '../../modal/order_history_modal/school_dropdown_modal.dart';
import '../../repository/order_history_repository/order_history_school_dropdown_repo.dart';

class OrderHistorySchoolDropdownVM extends GetxController{

   List<OrderHistorySchoolDropdown> ohSchoolDropListVm =[];
  var isLoading = true.obs;
  getSchoolDropdown(int userId)async{
    var schoolData = await OrderHistorySchoolDropdownRepo.getOrderHistoryFilterSchoolDropdown(userId);

    if(schoolData != null){
      ohSchoolDropListVm = schoolData;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }

  }


}