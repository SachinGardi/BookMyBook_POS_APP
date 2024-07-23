// To parse this JSON data, do
//
//     final addCustomerResponseModal = addCustomerResponseModalFromJson(jsonString);

import 'dart:convert';

AddCustomerResponseModal addCustomerResponseModalFromJson(String str) => AddCustomerResponseModal.fromJson(json.decode(str));

String addCustomerResponseModalToJson(AddCustomerResponseModal data) => json.encode(data.toJson());

class AddCustomerResponseModal {
  int? id;
  String? parentName;
  String? mobileNo;
  String? studentName;
  int? schoolId;
  String? schoolName;
  int? standardId;
  String? standard;
  int? divisionId;
  String? division;
  int? createdBy;

  AddCustomerResponseModal({
    this.id,
    this.parentName,
    this.mobileNo,
    this.studentName,
    this.schoolId,
    this.schoolName,
    this.standardId,
    this.standard,
    this.divisionId,
    this.division,
    this.createdBy,
  });

  factory AddCustomerResponseModal.fromJson(Map<String, dynamic> json) => AddCustomerResponseModal(
    id: json["id"],
    parentName: json["parentName"],
    mobileNo: json["mobileNo"],
    studentName: json["studentName"],
    schoolId: json["schoolId"],
    schoolName: json["schoolName"],
    standardId: json["standardId"],
    standard: json["standard"],
    divisionId: json["divisionId"],
    division: json["division"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parentName": parentName,
    "mobileNo": mobileNo,
    "studentName": studentName,
    "schoolId": schoolId,
    "schoolName": schoolName,
    "standardId": standardId,
    "standard": standard,
    "divisionId": divisionId,
    "division": division,
    "createdBy": createdBy,
  };
}
