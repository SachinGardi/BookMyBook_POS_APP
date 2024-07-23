import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../repository/login_repository/email_reset_password_repo.dart';


class EmailResetPasswordVm extends GetxController{

  var isLoading = true.obs;

  emailResetPassword(BuildContext context,String emailId)async{
    await EmailResetPasswordRepo.emailResetPassword(context,emailId);
    Timer(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }
}