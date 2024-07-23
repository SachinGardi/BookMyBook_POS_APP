import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../modal/pos_modal/addcustomer_response_modal.dart';
import '../../utility/base_url.dart';

class AddCustomerRepo {
  static List<AddCustomerResponseModal> customerResponseList = [];
  static int? statusCode;
  static String? statusMessage;

  static addCustomerData(
    int id,
    String parentName,
    String mobileNo,
    String studentName,
    int schoolId,
    int standardId,
    int divisionId,
    int createdBy,
  ) async {
    Uri uri =
        Uri.http(baseUrl, "/tuckshop/api/PointOfSale/Insert-Update-Customer");

    var data = jsonEncode({
      "id": id,
      "parentName": parentName,
      "mobileNo": mobileNo,
      "studentName": studentName,
      "schoolId": schoolId,
      "standardId": standardId,
      "divisionId": divisionId,
      "createdBy": createdBy,
    });

    try {
      var request = await http.post(uri, body: data, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (request.statusCode == 200) {
        Map temp = jsonDecode(utf8.decode(request.bodyBytes));

        statusCode = temp['statusCode'];
        statusMessage = temp['statusMessage'];

        temp['responseData1'].forEach((v) {
          customerResponseList.add(AddCustomerResponseModal(
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
        return customerResponseList;
      }
    } catch (e) {
      print(e);
    }
  }
}
