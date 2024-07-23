import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../repository/login_repository/forgot_password_repo.dart';

class ForgotPasswordVm extends GetxController{

  var isLoading = true.obs;

  forgotPassVm(BuildContext context,String newPass,String confirmPass,String userEmail)async{

    await ForgotPasswordRepo.forgotPassword(context,newPass, confirmPass, userEmail);
    Timer(const Duration(seconds: 2),(){
    isLoading.value = false;
    });

  }

}