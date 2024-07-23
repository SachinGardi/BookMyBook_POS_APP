import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modal/print_invoice_modal/modal.dart';
import '../../utility/base_url.dart';



class PrintReceiptRepo{
  static List<PrintInvoiceModal> receiptList= [];

  static var queryParameters;
  static getReceiptDetails(String invoiceId) async {
    queryParameters = {
      "InvoiceId": invoiceId,
    };
    Uri uri = Uri.http(baseUrl,
        "/tuckshop/api/PointOfSale/get-InvoiceData",
        PrintReceiptRepo.queryParameters);

    try{
      print(uri);
      http.Response response = (await http.get(uri));
      if(response.statusCode == 200){
        Map temp = json.decode(response.body);
        print(temp);
        temp['responseData'].forEach((v){
          receiptList.add(PrintInvoiceModal(
            id: v["id"],
            invoiceDate: DateTime.parse(v["invoiceDate"]),
            invoiceNo: v["invoiceNo"],
            payment: v["payment"],
            customerMobileNo: v["customerMobileNo"],
            schoolName: v["schoolName"],
            studentName: v["studentName"],
            standard: v["standard"],
            subTotal: v["subTotal"],
            discountType: v["discountType"],
            discount: v["discount"],
            totalAmount: v["totalAmount"],
            remark: v["remark"],
            totalQty: v["totalQty"],
            itemList: v["itemList"] == null ? [] : List<ItemList>.from(v["itemList"]!.map((x) => ItemList.fromJson(x))),
            gstBreakUp: v["gstBreakUp"] == null ? [] : List<GstBreakUp>.from(v["gstBreakUp"]!.map((x) => GstBreakUp.fromJson(x))),
            pendingItemList: v["pendingItemList"] == null ? [] : List<PendingItemList>.from(v["pendingItemList"]!.map((x) => PendingItemList.fromJson(x))),
          ));
        });
        return receiptList;
      }
    }
    catch (e) {
      print('Exception in Data $e');
    }
  }
}