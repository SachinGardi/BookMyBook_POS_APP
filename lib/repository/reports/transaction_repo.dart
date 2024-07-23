import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import 'package:http/http.dart' as http;
import '../../modal/reports_modal/transaction_modal.dart';



class TransactionRepo{
  static List<TransactionReportModal> getTransactionRepoList = [];
  static List<TransactionPageModal> transactionPageData = [];
  static var queryParameters;

  static getTransaction(String pageNo,String pageSize,String fromDate, String toDate,int userId,int schoolId,int stdId,int divId,String mobileNo,String textSearch) async {
    queryParameters = {
      "PageNo": pageNo,
      "PageSize": pageSize,
      "FromDate": fromDate,
      "ToDate": toDate,
      "UserId": "$userId",
      "SchoolId": "$schoolId",
      "StdId": "$stdId",
      "DivId": "$divId",
      "MobileNo": mobileNo,
      "TextSearch": textSearch,
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/get-TransactionReport-Level1",TransactionRepo.queryParameters);

    try{
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){

        Map temp = jsonDecode(response.body);
        print(uri);
        print(temp);


        final value = TransactionPageModal.fromJson(temp['responseData1']);
        print(value.pageNo);
        transactionPageData.add(value);

        temp["responseData"].forEach((v){
          getTransactionRepoList.add(TransactionReportModal(
            srNo: v["srNo"],
            id: v["id"],
            schoolName: v["schoolName"],
            orderId: v["orderId"],
            paymentType: v["paymentType"],
            date: DateTime.parse(v["date"]),
            totalAmount: v["totalAmount"],
            studentName: v["studentName"],
            transactionPageList: transactionPageData,
          ));
        });
        return getTransactionRepoList;
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}