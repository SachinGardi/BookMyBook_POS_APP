
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import 'package:http/http.dart' as http;

import '../../modal/dashboard_modal/dashboard_data_modal.dart';

class DashboardRepo{


 static var queryParameter;
 static List<DashboardDataModal> dashboardDataList= [];
  static getDashboardData(String userId, String schoolId, String stdId, String divId, String fromdate, String todate,) async {
    queryParameter={
      "UserId" :userId,
      "SchoolId" :schoolId,
      "StdId" :stdId,
      "DivId" :divId,
      "Fromdate" :fromdate,
      "Todate" :todate,
    };

    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/GetDashBoardData",queryParameter);
    try{
      http.Response response = await http.get(uri);
      print(uri);
      if(response.statusCode == 200){
        Map temp = json.decode(response.body);
        final value = DashboardDataModal.fromJson(temp['responseData']);
       dashboardDataList.add(value);
       return dashboardDataList;
     }
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
        }

  }


}