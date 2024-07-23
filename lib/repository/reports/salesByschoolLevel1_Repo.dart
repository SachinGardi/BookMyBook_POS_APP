import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import '../../modal/reports_modal/salesBySchool_Level1_modal.dart';
import 'package:http/http.dart' as http;


class SalesSchoolLevel1Repo {
  static List<SchoolSalesLevel1Modal> getSalesLevel1List = [];
  static var queryParameters;

  static getSalesLevel1(int userId,int schoolId,int stdId,int divId,String fromDate, String toDate,String textSearch) async {
    queryParameters = {
      "UserId": "$userId",
      "SchoolId": "$schoolId",
      "StdId": "$stdId",
      "DivId": "$divId",
      "FromDate": fromDate,
      "ToDate": toDate,
      "TextSearch": textSearch
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/get-SchoolReport-Level1",SalesSchoolLevel1Repo.queryParameters);

    try{
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        Map temp = jsonDecode(response.body);
        print(uri);
        print(temp);
        temp["responseData"].forEach((v){
          getSalesLevel1List.add(SchoolSalesLevel1Modal(
              srNo : v["srNo"],
            id : v["id"],
            schoolName : v["schoolName"],
            location : v["location"],
            date : v["date"],
            totalSale : v["totalSale"],
          ));
        });
        return getSalesLevel1List;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}