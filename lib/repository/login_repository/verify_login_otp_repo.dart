import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/login_screen/login_screen.dart';

class VerifyLoginOtpRepo {


  static verifyLoginOtp(BuildContext context,String emailId, String otp) async {
    var queryParams = {'EmailId': emailId, 'OTP': otp};
    Uri url = Uri.http(baseUrl,'tuckshop/api/User/VerifyOTP',queryParams);

    try{
      http.Response response = (await http.get(url));
      if(response.statusCode == 200){
        print(response.body);
        Map res = jsonDecode(response.body);

        if(res['statusMessage'] == 'Please enter valid OTP'){
          toastMessage(context, 'Please enter valid OTP');
        }
        else if(res['statusMessage'] == 'OTP verified successfully'){
          isSubmitClick = true;
          toastMessage(context, 'OTP verified successfully');
        }
      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }
}
