import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/dashboard_modal/dashboard_school_modal.dart';
import '../../utility/base_url.dart';
class DashboardSchoolRepo {

  static List<DashboardSchoolModal> schoolDetail= [];

  static getSchoolDetails(String userId)async{
    var queryParams ={
      "UserId":userId,
    };

    Uri uri = Uri.http(baseUrl,"tuckshop/api/Login/GetSchoolsByUserId",queryParams);
    try{
      http.Response response =(await http.get(uri));
      if(response.statusCode == 200){

        Map temp  = json.decode(response.body);
        print(uri);
        print(temp);
        temp['responseData'].forEach((v){
          schoolDetail.add(
              DashboardSchoolModal(
                id: v["id"],
                schools: v["schools"],
              )
          );
        });
        return schoolDetail;

      }
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

}