import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuck_shop/repository/login_repository/login_get_school_repo.dart';
import '../../modal/login_modal/login_get_school_modal.dart';

class LoginSchoolVM extends GetxController{
  List<GetLoginSchoolModal> getLoginSchools = [];
  var isLoading = true.obs;
  int? selectedSchoolId;
  String? selectedSchoolName;

  getLoginSchoolVM(BuildContext context,String userName)async{
    var schools = await GetSchoolRepo.getLoginSchoolList(context,userName);
    if(schools != null){
      getLoginSchools = schools;
      print(getLoginSchools.length);
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
  }

}