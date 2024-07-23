import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/login_screen/login_screen.dart';
import '../../utility/base_url.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepo{

  static var headers = {
    'Content-Type': 'application/json',
  };

  static forgotPassword(BuildContext context,String newPass,String confirmPass,String userEmail)async{
    var queryParams = {
      'NewPassword':newPass,
      'ConfirmPassword':confirmPass,
      'UserName':userEmail
    };

    Uri url = Uri.http(
        baseUrl,'tuckshop/api/Login/ForgotPassword',queryParams);

    try{
      http.Response response = (await http.put(url,headers: headers));
      if(response.statusCode == 200){
        print(response.body);
       Map res = jsonDecode(response.body);
       if(res['statusMessage'] == 'New password must not be same as old password.'){
         toastMessage(context, 'New password must not be same as old password.');
       }
       else if(res['statusMessage'] == 'Wrong confirm password.'){
         toastMessage(context, 'New password and Confirm password should be same!');
       }
       else if(res['statusMessage'] == 'Password updated successfully'){
         newPassCtr.clear();
         confirmPassCtr.clear();
         forgotPassCtr.clear();
         isSubmitClick = false;
         forgotPass = false;
         userNameCtr.clear();
         userPassCtr.clear();
         getOtp1.value = false;
         fieldOne1.clear();
         fieldTwo1.clear();
         fieldThree1.clear();
         fieldFour1.clear();
         toastMessage(context, 'Password updated successfully');
       }
      }

    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }

}