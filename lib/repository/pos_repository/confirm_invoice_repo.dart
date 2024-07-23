import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/confirm_invoice_modal.dart';
import '../../utility/base_url.dart';

class ConfirmInvoiceRepo {
  static List<ConfirmInvoiceModal> confirmInvoiceList = [];
  static int? statusCode;
  static int? invoiceId;
  static String? statusMessage;

  static confirmInvoiceData(
    int id,
    int orderId,
    int totalQty,
    double totalAmount,
    String paymentMode,
    String remark,
    bool isPrintReceipt,
    int createdBy,
  ) async {
    Uri uri = Uri.http(baseUrl, "/tuckshop/api/PointOfSale/Confirm-Invoice");

    var data = jsonEncode({
      "id": id,
      "orderId": orderId,
      "totalQty": totalQty,
      "totalAmount": totalAmount,
      "paymentMode": paymentMode,
      "remark": remark,
      "isPrintReceipt": isPrintReceipt,
      "createdBy": createdBy,
    });
    try {
      var request = await http.post(uri, body: data, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (request.statusCode == 200) {
        Map temp = jsonDecode(utf8.decode(request.bodyBytes));
        statusCode = temp['statusCode'];
        invoiceId = temp['responseData'];
        statusMessage = temp['statusMessage'];
      }
    } catch (e) {
      print(e);
    }
  }
}
