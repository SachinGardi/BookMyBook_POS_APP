

import 'dart:convert';

CustomerDetailModal getCustomerDetailsFromJson(String str) => CustomerDetailModal.fromJson(json.decode(str));

String getCustomerDetailsToJson(CustomerDetailModal data) => json.encode(data.toJson());

class CustomerDetailModal {
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

  CustomerDetailModal({
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

  factory CustomerDetailModal.fromJson(Map<String, dynamic> json) => CustomerDetailModal(
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
