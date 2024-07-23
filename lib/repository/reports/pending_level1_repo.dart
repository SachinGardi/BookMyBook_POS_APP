import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../modal/reports_modal/pending_Level1_modal.dart';
import '../../utility/base_url.dart';
import 'package:http/http.dart' as http;

class PendingRepoLevel1 {
  static List<PendingLevel1Modal> getPendingL1List = [];
  static List<PendingL1PageModal> pendingL1PageData = [];
  static var queryParameters;
  static getPendingLevel1(String pageNo,String pageSize,int userId,int schoolId,int stdId,int divId,String fromDate,String toDate) async {
    queryParameters = {
      "PageNo": pageNo,
      "PageSize": pageSize,
      "UserId": "$userId",
      "SchoolId": "$schoolId",
      "StdId": "$stdId",
      "DivId": "$divId",
      "FromDate": fromDate,
      "ToDate": toDate,
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/get-PendingBooksReport-Level1",PendingRepoLevel1.queryParameters);
    try{
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        Map temp = jsonDecode(response.body);
        print(uri);
        print(temp);


        final value = PendingL1PageModal.fromJson(temp['responseData1']);
        print(value.pageNo);
        pendingL1PageData.add(value);

        temp['responseData'].forEach((v){
          getPendingL1List.add(PendingLevel1Modal(
            srNo: v["srNo"],
            id: v["id"],
            schoolId: v["schoolId"],
            schoolName: v["schoolName"],
            location: v["location"],
            standardId: v["standardId"],
            standard: v["standard"],
            bookSetId: v["bookSetId"],
            bookSetName: v["bookSetName"],
            qtyPending: v["qtyPending"],
            pendingL1PageModalList: pendingL1PageData,
          ));
        });
        return getPendingL1List;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}