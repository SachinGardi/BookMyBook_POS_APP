import 'dart:convert';

import 'package:tuck_shop/utility/base_url.dart';

import '../../modal/dashboard_modal/bargraphdata_modal.dart';
import 'package:http/http.dart' as http;

class BarGraphRepo{
 static List<BarGraphModal> barList=[];
 static String? barLabelName ;
 static barData(String userId,String fromDate, String toDate,String schoolId,String standardId ,String divisionId) async {
    var queryParameters = {
      "UserId":userId,
    "FromDate" : fromDate,
    "ToDate" : toDate,
    "SchoolId" : schoolId,
    "StandardId" : standardId,
    "DivisionId" : divisionId,

    };
    Uri uri = Uri.http(baseUrl,"/tuckshop/api/Reports/GetDashboardGraphData",queryParameters);
    try{
      print(uri);
      http.Response  response = await http.get(uri);
      if(response.statusCode == 200){
        Map temp = json.decode(response.body);
        print("temp$temp");
        barLabelName = temp["responseData1"];
        print(barLabelName);

        temp["responseData"].forEach((v){
          barList.add(BarGraphModal(
            label: v["label"],
            totalsale: v["totalsale"],
          ));
        });
        return barList;
      }
    }
    catch(e){
      print(e);
    }


  }
}