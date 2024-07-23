import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/utility/base_url.dart';
import '../../modal/reports_modal/time_filter_modal.dart';


List<TimeFilterModal> timeFilterList = [];
class TimeFilterRepo {
  static gettimeFilter() async {
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/CommonDropDown/GetTimeFilter");

    try{
      http.Response response =(await http.get(uri));
      if(response.statusCode == 200) {
        Map temp = json.decode(response.body);
        temp["responseData"].forEach((v){
          timeFilterList.add(TimeFilterModal(
              id: v['id'],
              text: v['text']
          ));
        });
        return timeFilterList;
      }
    }catch(e){
      if(kDebugMode){
        print(e);
      }
    }
  }
}