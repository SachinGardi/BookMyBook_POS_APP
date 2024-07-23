import 'dart:async';
import 'package:get/get.dart';
import '../../modal/pos_modal/get_customerbyid_modal.dart';
import '../../repository/pos_repository/get_customerbyid_repo.dart';
String? updateParentName;
String? updateMobileNumber;
String? updateStudentName;
String? updateStandard;
String? updateDiv;
String? updateDivId;

class CustomerDetailVM extends GetxController{
  var isLoading = true.obs;
  List<CustomerDetailModal> customerDetailList = [];
  getCustomerInfo(String id) async {
    var customerData = await CustomerDetailRepo.getCustomerDetails(id);
    if(customerData != null){
      customerDetailList = customerData;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    customerDetailList.forEach((element) {
      updateParentName = element.parentName;
      updateMobileNumber = element.mobileNo;
      updateStudentName = element.studentName;
      updateStandard = element.standard;
      updateDivId = element.divisionId.toString();
      updateDiv = element.division.toString();
    });



  }

}