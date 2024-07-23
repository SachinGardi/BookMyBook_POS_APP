import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tuck_shop/utility/base_url.dart';
import '../../modal/order_history_modal/school_division_modal.dart';
import 'package:http/http.dart' as http;
class OrderHistorySchoolDivisionRepo{

  static List<OrderHistorySchoolDivisionDropdown> ohSchoolDivisionDropList =[];
  static ohGetSchoolDivision(int stdId)async{
    var queryParams = {
    'StandardId':'$stdId'
    };
    Uri url = Uri.http(baseUrl,'tuckshop/api/CommonDropDown/GetDivisionByStandardForOrderHistory',queryParams);
    try{
      http.Response response = (await http.get(url));
      if(response.statusCode == 200){
        ohSchoolDivisionDropList.clear();
        print(response.body);
        Map res = jsonDecode(response.body);
        res['responseData'].forEach((div){
          ohSchoolDivisionDropList.add(
              OrderHistorySchoolDivisionDropdown(
                  id: div['id'],
                  text: div['text']
              ));
        });
        return ohSchoolDivisionDropList;
      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }

}