import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modal/order_history_modal/standard_dropdown_modal.dart';
import '../../repository/order_history_repository/order_history_school_standard_dropdown_repo.dart';

class OrderHistorySchoolStandardDropdownVM extends GetxController{
   List<OrderHistorySchoolStandardDropdown> ohSchoolStdListVm = [];
   var isLoading = true.obs;
   getOhSchoolStandardDropdown(BuildContext context,int schoolId)async{
     var stdData = await OrderHistorySchoolStandardDropdownRepo.getOhSchoolStd(context,schoolId);
     if(stdData != null){
       ohSchoolStdListVm = stdData;
       isLoading.value = false;
     }
     else{
       Timer(const Duration(seconds: 2),(){
         isLoading.value = false;
       });
     }
   }
}