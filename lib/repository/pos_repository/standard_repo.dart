import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/standard_modal.dart';
import '../../utility/base_url.dart';

List<PosStandardModal> standardList = [];

class PosStandardRepository {
  static var queryParameters;
  static posStandardDetails(int schoolId) async {
    queryParameters = {
      "SchoolId": "$schoolId",
    };
    Uri uri = Uri.http(baseUrl,
        "/tuckshop/api/CommonDropDown/GetStandardBySchool", queryParameters);
    try {
      http.Response response = (await http.get(uri));
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);
        temp["responseData"].forEach((v) {
          standardList.add(PosStandardModal(id: v['id'], text: v['text']));
        });
        return standardList;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Data $e");
      }
    }
  }
}
