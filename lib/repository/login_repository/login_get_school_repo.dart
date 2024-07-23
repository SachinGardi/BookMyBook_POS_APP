
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import '../../modal/login_modal/login_get_school_modal.dart';
import 'package:http/http.dart' as http;

import '../../utility/base_url.dart';

class GetSchoolRepo{

  static List<GetLoginSchoolModal> getLoginSchool = [];

  static getLoginSchoolList(BuildContext context,String userName)async{
    final queryParams = {
      'Username':userName
    };
    Uri url = Uri.http(baseUrl,'tuckshop/api/Login/GetSchools',queryParams);
    try{
      http.Response response = (await http.get(url));
      if(response.statusCode == 200){
        getLoginSchool.clear();
        print(response.body);
        Map res = jsonDecode(response.body);
        if(res['responseData'] != null){
          res['responseData'].forEach((school){
            getLoginSchool.add(
                GetLoginSchoolModal(
                    id: school['id'],
                    schools: school['schools']
                )
            );
          });
          return getLoginSchool;
        }
        else if(res['statusMessage'] == 'School list is not available.'){
            toastMessage(context, 'School list is not available.');
        }

      }

    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }


}