import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/paymentdetailpost_modal.dart';
import '../../utility/base_url.dart';

int? posOrderId;

class PaymentDetailsRepo {
  static int? statusCode;
  static String? statusMessage;

  static postPaymentData(
    int id,
    String customerId,
    double subTotal,
    String discountType,
    double discount,
    String tax,
    int status,
    int createdBy,
    double totalAmount,
    double totalCGST,
    double totalSGST,
    List<BookDetail> bookDetails,
  ) async {
    Uri uri = Uri.http(baseUrl, "/tuckshop/api/PointOfSale/Insert-PointOfSale");

    var data = jsonEncode({
      "id": id,
      "customerId": customerId,
      "subTotal": subTotal,
      "discountType": discountType,
      "discount": discount,
      "tax": tax,
      "status": status,
      "createdBy": createdBy,
      "totalAmount": totalAmount,
      "totalCGST": totalCGST,
      "totalSGST": totalSGST,
      "bookDetails": bookDetails,
    });

    try {
      var request = await http.post(uri, body: data, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (request.statusCode == 200) {
        Map temp = jsonDecode(utf8.decode(request.bodyBytes));
        statusCode = temp['statusCode'];
        statusMessage = temp['statusMessage'];
        posOrderId = temp['responseData'];
      }
    } catch (e) {
      print(e);
    }
  }
}
