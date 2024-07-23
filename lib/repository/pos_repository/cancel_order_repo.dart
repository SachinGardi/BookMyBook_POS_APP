import 'dart:convert';

import 'package:tuck_shop/utility/base_url.dart';
import 'package:http/http.dart' as http;

class CancelOrderRepo {
  static int? statusCode;
  static String? statusMessage;

  static cancelOrder(String orderId, String remark) async {
    var queryParameter = {"OrderId": orderId, "Remark": remark};
    Uri uri = Uri.http(
        baseUrl, "/tuckshop/api/PointOfSale/CancleOrder", queryParameter);

    try {
      http.Response response = await http.put(uri);
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);
        statusCode = temp['statusCode'];
        statusMessage = temp['statusMessage'];
      }
    } catch (e) {
      print(e);
    }
  }
}
