import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/payment_summary_modal.dart';
import '../../utility/base_url.dart';

class PaymentSummaryRepo {
  static List<PaymentSummaryModal> getsummaryList = [];
  static var queryParameters;

  static getSummary(String orderId) async {
    queryParameters = {"OrderId": orderId};
    Uri uri = Uri.http(baseUrl, "/tuckshop/api/PointOfSale/get-PaymentSummary",
        PaymentSummaryRepo.queryParameters);

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        Map temp = jsonDecode(response.body);
        temp["responseData"].forEach((v) {
          getsummaryList.add(PaymentSummaryModal(
            studentName: v["studentName"],
            standard: v["standard"],
            division: v["division"],
            totalQty: v["totalQty"],
            totalAmount: v["totalAmount"],
          ));
        });
        return getsummaryList;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
