import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../modal/login_modal/login_modal.dart';
import '../../repository/login_repository/login_repo.dart';

class LoginVM extends GetxController {

  static LoginModal loginVmData = LoginModal();
  var isLoading = true.obs;

  postLoginDetail(BuildContext context,String userName, String password,int schoolId, String fcmId) async {
 await LoginRepo.postLoginInfo(
        context,
        userName,
        password,
        schoolId,
        fcmId,
        'V1.0',
         1
    );

   loginVmData  = LoginRepo.loginData;


   Timer(const Duration(seconds: 2),(){
     isLoading.value = false;
   });

  }
}