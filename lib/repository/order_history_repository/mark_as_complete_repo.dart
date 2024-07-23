import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import '../../modal/order_history_modal/mark_as_complete_modal.dart';
import 'package:http/http.dart' as http;

class MarkAsCompleteRepo {
  static var headers = {
    'Content-Type': 'application/json',
  };

  static markAsCompleted(
      int id, int orderId, List<SaveboolList> saveboolList) async {
    var data = jsonEncode(
        {'id': id, 'orderId': orderId, 'saveboolList': saveboolList});

    Uri url = Uri.http(baseUrl,'tuckshop/api/PointOfSale/Save-MarkAsComplete');
    
    try{
      http.Response response = (await http.post(url,body: data,headers: headers));
      if(response.statusCode == 200){
        print(response.body);
      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }
}
