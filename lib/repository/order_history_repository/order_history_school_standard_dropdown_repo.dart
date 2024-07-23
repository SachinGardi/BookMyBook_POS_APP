import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuck_shop/utility/base_url.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';

import '../../modal/order_history_modal/standard_dropdown_modal.dart';
import 'package:http/http.dart' as http;
class OrderHistorySchoolStandardDropdownRepo{

  static List<OrderHistorySchoolStandardDropdown> ohSchoolStdList = [];

  static getOhSchoolStd(BuildContext context,int schoolId)async{
    var queryParams = {
    'SchoolId':'$schoolId'
    };
    Uri url = Uri.http(baseUrl,'tuckshop/api/CommonDropDown/GetStandardBySchoolForOrderHistory',queryParams);
    try{
      http.Response response = (await http.get(url));
      if(response.statusCode == 200){
        ohSchoolStdList.clear();
        print(response.body);
        Map res = jsonDecode(response.body);
        if(res['statusMessage'] == 'Standard details not found..'){
          toastMessage(context, 'Standard details not found');
        }
        res['responseData'].forEach((std){
          ohSchoolStdList.add(
              OrderHistorySchoolStandardDropdown(
                  id: std['id'],
                  text: std['text']
              )
          );
        });
        return ohSchoolStdList;
      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }

}