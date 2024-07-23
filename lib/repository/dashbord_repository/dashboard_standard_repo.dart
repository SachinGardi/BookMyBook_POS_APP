import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/dashboard_modal/dashboard_standard_modal.dart';
import '../../modal/pos_modal/standard_modal.dart';
import '../../utility/base_url.dart';



List<DashboardStandardModal> standardList = [];
class DashboardStandardRepo{
  static var queryParameters;
  static posStandardDetails(int schoolId) async {
    queryParameters = {
      "SchoolId" : "$schoolId",
    };
    Uri uri = Uri.http(baseUrl,
        "/tuckshop/api/CommonDropDown/GetStandardBySchool",queryParameters);
    try{
      print(uri);
      http.Response response =(await http.get(uri));
      if(response.statusCode == 200){
        print(response.body);
        Map temp = json.decode(response.body);

        temp["responseData"].forEach((v){
          standardList.add(DashboardStandardModal(
              id: v['id'],
              text: v['text']
          ));
        });
        return standardList;
      }

    }
    catch(e){
      if (kDebugMode) {
        print("Exception in Data $e");
      }
    }
  }
}