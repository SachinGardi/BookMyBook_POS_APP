import '../../modal/reports_modal/pending_dialog_modal.dart';
import '../../utility/base_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PendingDialogRepo {
  static List<PendingDialogModal> pendingDialogList = [];
  static var queryParameters;
  static getPendingDialogDetails(int orderId) async {
    queryParameters = {
      "OrderId": "$orderId",
    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/PointOfSale/get-CounterSalesDetailsById",PendingDialogRepo.queryParameters);

    try{
      print(uri);
      http.Response response = (await http.get(uri));
      if(response.statusCode == 200){
        Map temp = json.decode(response.body);
        print(temp);
        temp["responseData"].forEach((v){
          pendingDialogList.add(PendingDialogModal(
            id: v["id"],
            orderId: v["orderId"],
            invoiceId: v["invoiceId"],
            mobileNo: v["mobileNo"],
            date: DateTime.parse(v["date"]),
            schoolName: v["schoolName"],
            standard: v["standard"],
            division: v["division"],
            parentName: v["parentName"],
            studentName: v["studentName"],
            transactionID: v["transactionID"],
            paymentType: v["paymentType"],
            orderValue: v["orderValue"],
            pendingBooklist: v["pendingBooklist"] == null ? [] : List<PendingBooklist>.from(v["pendingBooklist"]!.map((x) => PendingBooklist.fromJson(x))),
          ));
        });
        return pendingDialogList;
      }
    }
    catch (e) {
      print('Exception in Data $e');
    }
  }
}