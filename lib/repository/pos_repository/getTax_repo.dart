import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../modal/pos_modal/getTax_modal.dart';
import '../../utility/base_url.dart';
import 'package:http/http.dart' as http;

List<GetTaxModal> getTaxRepoList = [];

class GetTaxRepository {
  static getTaxDetails() async {
    Uri uri = Uri.http(baseUrl, "/tuckshop/api/CommonDropDown/GetTax");

    try {
      http.Response response = (await http.get(uri));
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);
        temp["responseData"].forEach((v) {
          getTaxRepoList.add(GetTaxModal(id: v['id'], text: v['text']));
        });
        return getTaxRepoList;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in Data $e");
      }
    }
  }
}
