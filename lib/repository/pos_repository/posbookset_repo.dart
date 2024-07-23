import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/bookset_modal.dart';
import '../../utility/base_url.dart';

class PosBookSetRepo {
  static List<PosBookSetModal> bookSetInformation = [];

  static bookSetDetails(String pageNo, String pageSize, String textSearch,
      String schoolId, String standardId, String type) async {
    var queryParams = {
      "PageNo": pageNo,
      "PageSize": pageSize,
      "TextSearch": textSearch,
      "SchoolId": schoolId,
      "StandardId": standardId,
      "Type": type,
    };

    Uri uri = Uri.http(
        baseUrl, "/tuckshop/api/PointOfSale/get-BookList", queryParams);
    try {
      http.Response response = (await http.get(uri));
      if (response.statusCode == 200) {
        Map temp = json.decode(response.body);
        temp['responseData'].forEach((v) {
          bookSetInformation.add(PosBookSetModal(
            srNo: v["srNo"],
            id: v["id"],
            bookName: v["bookName"],
            schoolId: v["schoolId"],
            schoolName: v["schoolName"],
            standardId: v["standardId"],
            standard: v["standard"],
            sellingPrice: v["sellingPrice"],
            pulicationName: v["pulicationName"],
            type: v["type"],
            qty: v['qty'],
            taxRate: v["taxRate"],
            isPending: v["isPending"],
          ));
        });
        return bookSetInformation;
      }
    } catch (e) {
      print(e);
    }
  }
}
