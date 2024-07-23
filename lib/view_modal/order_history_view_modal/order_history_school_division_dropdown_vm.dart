import 'dart:async';
import 'package:get/get.dart';
import '../../modal/order_history_modal/school_division_modal.dart';
import '../../repository/order_history_repository/order_history_school_division_repo.dart';

class OrderHistorySchoolDivisionVm extends GetxController{

   List<OrderHistorySchoolDivisionDropdown> ohSchoolDivisionDropListVm =[];
   var isLoading = true.obs;
   getOhSchoolDivisionDropdown(int stdId)async{
     var divisionData = await OrderHistorySchoolDivisionRepo.ohGetSchoolDivision(stdId);
     if(divisionData != null){
       ohSchoolDivisionDropListVm = divisionData;
       isLoading.value = false;
     }
     else{
       Timer(const Duration(seconds: 2),(){
         isLoading.value = false;
       });
     }
   }
}