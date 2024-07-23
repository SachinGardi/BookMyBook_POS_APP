import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import '../../modal/order_history_modal/timer_filter_modal.dart';
import 'package:http/http.dart' as http;

class OrderHistoryTimerFilterRepo{
  static List<OrderHistoryTimerFilterDropdown> ohTimerFilterDropList =[];

  static getTimerFilter()async{
  Uri url = Uri.http(baseUrl,'tuckshop/api/CommonDropDown/GetTimeFilter');

  try{
    http.Response response = (await http.get(url));
    if(response.statusCode == 200){
      ohTimerFilterDropList.clear();
      print(response.body);
      Map res = jsonDecode(response.body);
      res['responseData'].forEach((time){
        ohTimerFilterDropList.add(
            OrderHistoryTimerFilterDropdown(
                id: time['id'],
                text: time['text']
            )
        );
      });
      return ohTimerFilterDropList;
    }
  }catch(err){
    if(kDebugMode){
      print("Exception in Data $err");
    }
  }
  }

}