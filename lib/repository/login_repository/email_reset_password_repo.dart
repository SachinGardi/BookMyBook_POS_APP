import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import '../../utility/base_url.dart';
import 'package:http/http.dart' as http;

import '../../view/login_screen/login_screen.dart';


class EmailResetPasswordRepo{


  static var headers = {
    'Content-Type': 'application/json',
  };
  static var isSelected  =  false.obs;

  static emailResetPassword(BuildContext context,String emailId)async{

    var queryParams = {
    'email':emailId
    };
    Uri url = Uri.http(
        baseUrl,'/tuckshop/api/AppLogin/AppEmailResetPassword',queryParams);

    try{
      http.Response response = (await http.post(url,headers: headers));
      if(response.statusCode == 200){
        print(response.body);
        Map res =  jsonDecode(response.body);
        if(res['statusMessage'] == 'Email sent successfully'){
          isSelected.value = true;
          fieldOne1.clear();
          fieldTwo1.clear();
          fieldThree1.clear();
          fieldFour1.clear();
          isShowResendBtn1.value = false;
          getOtp1.value = true;
          resendOtpbtn1 = true;
          toastMessage(context, 'Email sent successfully');


        }
        else if(res['statusMessage'] == 'Please enter valid sales person emailid.'){
          toastMessage(context, 'Please enter the valid email');
        }
        else{
          isSubmitClick = false;
        }
      }

    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }


  }

}