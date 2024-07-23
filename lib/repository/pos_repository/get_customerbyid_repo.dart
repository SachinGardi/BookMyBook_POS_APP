import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/get_customerbyid_modal.dart';
import '../../utility/base_url.dart';

List<CustomerDetailModal> customerDetailList = [];

class CustomerDetailRepo {
  static var queryParameter;

  static getCustomerDetails(String id) async {
    queryParameter = {
      "Id": id,
    };
    Uri uri = Uri.http(
        baseUrl, "/tuckshop/api/PointOfSale/get-CustomerById", queryParameter);
    try {
      http.Response response = (await http.get(uri));
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);
        temp["responseData"].forEach((v) {
          customerDetailList.add(CustomerDetailModal(
            id: v["id"],
            parentName: v["parentName"],
            mobileNo: v["mobileNo"],
            studentName: v["studentName"],
            schoolId: v["schoolId"],
            schoolName: v["schoolName"],
            standardId: v["standardId"],
            standard: v["standard"],
            divisionId: v["divisionId"],
            division: v["division"],
            createdBy: v["createdBy"],
          ));
        });
        return customerDetailList;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Data $e");
      }
    }
  }
}
