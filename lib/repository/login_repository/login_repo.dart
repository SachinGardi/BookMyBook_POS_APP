import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import '../../modal/login_modal/login_modal.dart';
import '../../utility/base_url.dart';
import 'package:http/http.dart' as http;
class LoginRepo{
  static LoginModal loginData = LoginModal();


  static var headers = {
    'Content-Type': 'application/json',
  };
  static postLoginInfo(
      BuildContext context,
      String userName,
      String password,
      int schoolId,
      String fcmId,
      String version,
      int loginDeviceTypeId
      ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var data = jsonEncode({
      'userName': userName,
      'password': password,
      'schoolId':schoolId,
      'fcmId': fcmId,
      'version': version,
      'loginDeviceTypeId': loginDeviceTypeId,
    });
    Uri url = Uri.http(
        baseUrl,'tuckshop/api/AppLogin/Applogin');

    try{
      http.Response response = (await http.post(url, body: data, headers: headers));

      if(response.statusCode == 200){
        print(response.body);


       Map res =  jsonDecode(response.body);

     if(res['statusMessage']== 'Invalid username or password'){
       toastMessage(context, 'Invalid username or password');
     }
     else if(res['statusMessage'] == 'Logged in successfully'){
       toastMessage(context, 'Logged in successfully');
       var resSet1 = ResponseData.fromJson(res["responseData"]);
       var resSet2 = ResponseData1.fromJson(res["responseData1"]);
       pref.setInt('userId', resSet1.id!);
       loginData.responseData = resSet1;
       loginData.responseData1 = resSet2;
       print(loginData.responseData!.id);
       Get.offAllNamed('/dashboard');
     }
     else if(res['statusMessage'] == 'This user is blocked'){
       toastMessage(context, 'This user is blocked');

     }

      }

    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }

  }

}