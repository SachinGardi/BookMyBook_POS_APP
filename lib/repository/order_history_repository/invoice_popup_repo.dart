import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/utility/base_url.dart';

import '../../modal/order_history_modal/invoice_popup_modal.dart';

class InvoicePopupRepo{

  static List<InvoicePopupModal> invoiceDataList = [];

  static getInvoicePopupData(int invoiceId)async{
    var queryParams = {
      'InvoiceId':'$invoiceId'
    };
    
    Uri url = Uri.http(baseUrl,'tuckshop/api/PointOfSale/get-OrderDetailsById',queryParams);

    try{
      http.Response response = (await http.get(url));
      if(response.statusCode == 200){
        invoiceDataList.clear();
        print(response.body);
        Map res = jsonDecode(response.body);
        res['responseData'].forEach((data){
          invoiceDataList.add(
              InvoicePopupModal(
                  id: data['id'],
                  orderId: data['orderId'],
                  invoiceId: data['invoiceId'],
                  mobileNo: data['mobileNo'],
                  date: data['date'],
                  standard: data['standard'],
                  division: data['division'],
                  orderValue: data['orderValue'],
                  bookLlist: data['bookLlist'] == null ? []:List<BookLlistElementModal>.from(data['bookLlist']!.map((x)=>BookLlistElementModal.fromJson(x))),
                  pendingBooklist: data['pendingBooklist'] == null ? []:List<BookLlistElementModal>.from(data['pendingBooklist']!.map((x)=>BookLlistElementModal.fromJson(x)))
              ),
          );

        });
        return invoiceDataList;
      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }

}