import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import '../../modal/reports_modal/pending_Level2_modal.dart';
import 'package:http/http.dart' as http;

class PendingLevel2Repo {
  static List<PendingReportsLevel2Modal> level2List = [];
  static var queryParametes;

  static getPendingLevel2(String pageNo,String pageSize,int userId,int schoolId,int stdId,int booksetId,int divId,String fromDate,String toDate) async{
    queryParametes = {
      "PageNo": pageNo,
      "PageSize": pageSize,
      "UserId": "$userId",
      "SchoolId": "$schoolId",
      "StdId": "$stdId",
      "BooksetId": "$booksetId",
      "DivId": "$divId",
      "FromDate": fromDate,
      "ToDate": toDate,
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/get-PendingBooksReport-Level2",PendingLevel2Repo.queryParametes);

    try{
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        Map temp = jsonDecode(response.body);
        print(uri);
        print(temp);
        temp["responseData"].forEach((v){
          level2List.add(PendingReportsLevel2Modal(
            srNo: v["srNo"],
            oId: v["oId"],
            orderId: v["orderId"],
            studentName: v["studentName"],
            division: v["division"],
            date: DateTime.parse(v["date"]),
            mobileNo: v["mobileNo"],
            qtyPending: v["qtyPending"],
          ));
        });
        return level2List;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}