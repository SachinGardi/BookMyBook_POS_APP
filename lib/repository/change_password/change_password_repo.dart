import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import '../../modal/change_password/change_password_modal.dart';
import '../../utility/base_url.dart';


class ChangePasswordRepo {
  static List<ChangePasswordModal> changePassData = [];
  static changePasswordData(
      int userId,
      String currentPassword,
      String newPassword,
      BuildContext context
      ) async {
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Login/change-password");

    var data = jsonEncode({
      "userId": userId,
      "currentPassword": currentPassword,
      "newPassword": newPassword,
    });

    try {
      print(uri);
      print("--$data");

      var request = await http.post(uri,
          body: data,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          });
      print(request.statusCode);
      Map temp = jsonDecode(utf8.decode(request.bodyBytes));
      print("--$temp");
      if (request.statusCode == 200) {
        print(request.statusCode);
        if (temp["statusMessage"] == "Password changed successfully...") {
          toastMessage(context, "Password changed successfully.");
          Get.toNamed("/");
        } else if(temp["statusMessage"] == "Old password and new password should not be same"){
          toastMessage(context, "Old password and new password should not be same");
          return;
        } else if (temp["statusMessage"] == "Please enter valid current password"){
          toastMessage(context, "Please enter valid current password");
          return;
        }
      }
    } catch (e){
      print(e);
    }
  }
}

