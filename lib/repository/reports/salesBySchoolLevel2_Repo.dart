import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/reports_modal/salesBySchool_Level2_modal.dart';
import '../../utility/base_url.dart';

class SchoolReportsLevel2 {
  static List<SchoolReportsLevel2Modal> schoolL2List = [];
  static var queryParameters;

  static getSchoolL2(int userId,int schoolId,int stdId,int divId,String fromDate, String toDate) async {
    queryParameters = {
      "UserId" : "$userId",
      "SchoolId" : "$schoolId",
      "StdId": "$stdId",
      "DivId": "$divId",
      "FromDate": fromDate,
      "ToDate": toDate
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/get-SchoolReport-Level2",SchoolReportsLevel2.queryParameters);

    try {
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        Map temp = jsonDecode(response.body);
        print(uri);
        print(temp);
        temp["responseData"].forEach((v){
          schoolL2List.add(SchoolReportsLevel2Modal(
            srNo: v["srNo"],
            id: v["id"],
            standard: v["standard"],
            totalStudent: v["totalStudent"],
            totalStandard: v["totalStandard"],
            date: DateTime.parse(v["date"]),
            totalSale: v["totalSale"],
          ));
        });
        return schoolL2List;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}