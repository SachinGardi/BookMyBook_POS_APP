import 'dart:async';
import 'package:get/get.dart';
import 'package:tuck_shop/modal/pos_modal/division_modal.dart';
import '../../repository/pos_repository/division_repo.dart';

class DivisionVM extends GetxController{
  var isLoading = true.obs;
  List<DivisionModal> divisionList = [];

  getDivisionInfo() async {
    var divisionData = await DivisionRepository.getDivisionDetails();
    if(divisionData != null){
      divisionList = divisionData;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }


  }

}