import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../repository/login_repository/verify_login_otp_repo.dart';
import '../../view/login_screen/login_screen.dart';

class VerifyLoginOtpVm extends GetxController{

  var isLoading = true.obs;

  verifyLoginOtpVm(BuildContext context,String emailId)async{
    await VerifyLoginOtpRepo.verifyLoginOtp(
        context,
        emailId,
        fieldOne1.text+fieldTwo1.text+fieldThree1.text+fieldFour1.text,
    );
    isLoading.value = false;
  }


}