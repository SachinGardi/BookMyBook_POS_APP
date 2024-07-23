import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/division_modal.dart';
import '../../utility/base_url.dart';

List<DivisionModal> divisionList = [];

class DivisionRepository {
  static getDivisionDetails() async {
    Uri uri = Uri.http(baseUrl, "tuckshop/api/CommonDropDown/GetDivision");
    try {
      http.Response response = (await http.get(uri));
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);

        temp["responseData"].forEach((v) {
          divisionList.add(DivisionModal(id: v['id'], text: v['text']));
        });
        return divisionList;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Data $e");
      }
    }
  }
}
