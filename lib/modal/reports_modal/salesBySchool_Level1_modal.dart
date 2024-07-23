// To parse this JSON data, do
//
//     final schoolSalesLevel1Modal = schoolSalesLevel1ModalFromJson(jsonString);

import 'dart:convert';

SchoolSalesLevel1Modal schoolSalesLevel1ModalFromJson(String str) => SchoolSalesLevel1Modal.fromJson(json.decode(str));

String schoolSalesLevel1ModalToJson(SchoolSalesLevel1Modal data) => json.encode(data.toJson());

class SchoolSalesLevel1Modal {
  int srNo;
  int id;
  String schoolName;
  String location;
  dynamic date;
  double totalSale;

  SchoolSalesLevel1Modal({
    required this.srNo,
    required this.id,
    required this.schoolName,
    required this.location,
    required this.date,
    required this.totalSale,
  });

  factory SchoolSalesLevel1Modal.fromJson(Map<String, dynamic> json) => SchoolSalesLevel1Modal(
    srNo: json["srNo"],
    id: json["id"],
    schoolName: json["schoolName"],
    location: json["location"],
    date: json["date"],
    totalSale: json["totalSale"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "id": id,
    "schoolName": schoolName,
    "location": location,
    "date": date,
    "totalSale": totalSale,
  };
}
