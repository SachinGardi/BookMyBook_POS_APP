import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/utility/base_url.dart';

import '../../modal/order_history_modal/school_dropdown_modal.dart';

class OrderHistorySchoolDropdownRepo {
  
  
  static List<OrderHistorySchoolDropdown> ohSchoolDropList =[];
  
  static  getOrderHistoryFilterSchoolDropdown(int userId)async{
    var queryParams = {
    'UserId':'$userId'
    };
    Uri url = Uri.http(baseUrl,'tuckshop/api/Login/GetSchoolsByUserId',queryParams);

    try{
      http.Response response = await http.get(url);
      if(response.statusCode == 200){
        ohSchoolDropList.clear();
        print(response.body);
        Map res = jsonDecode(response.body);
        res['responseData'].forEach((school){
          ohSchoolDropList.add(
           OrderHistorySchoolDropdown(
               id: school['id'],
               schools: school['schools']
           )
          );
        });
        return ohSchoolDropList;
      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }

  }
  
}