import 'dart:convert';

AddCustomerModal addCustomerModalFromJson(String str) => AddCustomerModal.fromJson(json.decode(str));

String addCustomerModalToJson(AddCustomerModal data) => json.encode(data.toJson());

class AddCustomerModal {
  int id;
  String parentName;
  String mobileNo;
  String studentName;
  int schoolId;
  int standardId;
  int divisionId;
  int createdBy;

  AddCustomerModal({
    required this.id,
    required this.parentName,
    required this.mobileNo,
    required this.studentName,
    required this.schoolId,
    required this.standardId,
    required this.divisionId,
    required this.createdBy,
  });

  factory AddCustomerModal.fromJson(Map<String, dynamic> json) => AddCustomerModal(
    id: json["id"],
    parentName: json["parentName"],
    mobileNo: json["mobileNo"],
    studentName: json["studentName"],
    schoolId: json["schoolId"],
    standardId: json["standardId"],
    divisionId: json["divisionId"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parentName": parentName,
    "mobileNo": mobileNo,
    "studentName": studentName,
    "schoolId": schoolId,
    "standardId": standardId,
    "divisionId": divisionId,
    "createdBy": createdBy,
  };
}
