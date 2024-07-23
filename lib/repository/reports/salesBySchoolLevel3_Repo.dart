import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/reports_modal/salesBySchool_Level3_modal.dart';
import '../../utility/base_url.dart';


class SchoolReportsLevel3repo {
  static List<SchoolReportsLevel3Modal> schoolList3 = [];
  static var queryParameters;
  static getSchoolL3(int userId,int schoolId,int stdId, int divId,String fromDate, String toDate) async {
    queryParameters = {
      "UserId" : "$userId",
      "SchoolId" : "$schoolId",
      "StdId" : "$stdId",
      "DivId" : "$divId",
      "FromDate" : fromDate,
      "ToDate" : toDate,
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/get-SchoolReport-Level3",SchoolReportsLevel3repo.queryParameters);

    try {
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        Map temp = jsonDecode(response.body);
        print(uri);
        print(temp);
        temp["responseData"].forEach((v){
          schoolList3.add(SchoolReportsLevel3Modal(
            srNo: v["srNo"],
            id: v["id"],
            division: v["division"],
            totalStudents: v["totalStudents"],
            students: v["students"],
            totalDivision: v["totalDivision"],
            date: DateTime.parse(v["date"]),
            totalSale: v["totalSale"],
          ));
        });
        return schoolList3;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}