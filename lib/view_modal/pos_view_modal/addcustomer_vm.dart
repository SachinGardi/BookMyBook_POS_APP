

import 'dart:async';

import 'package:get/get.dart';

import '../../modal/pos_modal/addcustomer_response_modal.dart';
import '../../repository/pos_repository/addcustomer_repo.dart';

var posCustomerId =''.obs;
var posParentName =''.obs;
var posMobileNumber =''.obs;
var posStudentName =''.obs;
var posStdDiv =''.obs;
var posCustId =''.obs;

class AddCustomerVm extends GetxController{
  var isLoading = true.obs;
   List<AddCustomerResponseModal> customerResponseList = [];
    int? statusCode;
    String? statusMessage;

  addCustomer(int id, String parentName, String mobileNo, String studentName, int schoolId, int standardId, int divisionId, int createdBy) async{
    var data = await AddCustomerRepo.addCustomerData(
        id,
        parentName,
        mobileNo,
        studentName,
        schoolId,
        standardId,
        divisionId,
        createdBy
    );
    if(data!= null){
      customerResponseList = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
      statusCode = AddCustomerRepo.statusCode;
      statusMessage = AddCustomerRepo.statusMessage;

    customerResponseList.forEach((element) {
      posCustomerId.value= element.id!.toString();
      posParentName.value= element.parentName!;
      posMobileNumber.value = element.mobileNo!;
      posStudentName.value = element.studentName!;
      posStdDiv.value = "${element.standard} ( ${element.division} )";
      posCustId.value = element.id.toString();

    });

  }
}