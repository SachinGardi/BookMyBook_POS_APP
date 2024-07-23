import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/modal/pos_modal/get_schoolby_user_modal.dart';
import '../../utility/base_url.dart';

class GetSchoolByUserRepo {
  static List<GetSchoolByUserIdModal> schoolDetail = [];

  static getSchoolDetails(String userId) async {
    var queryParams = {
      "UserId": userId,
    };

    Uri uri =
        Uri.http(baseUrl, "tuckshop/api/Login/GetSchoolsByUserId", queryParams);
    try {
      http.Response response = (await http.get(uri));
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);
        temp['responseData'].forEach((v) {
          schoolDetail.add(GetSchoolByUserIdModal(
            id: v["id"],
            schools: v["schools"],
          ));
        });
        return schoolDetail;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
