
import 'dart:convert';

SchoolReportsLevel2Modal pendingReportsLevel2ModalFromJson(String str) => SchoolReportsLevel2Modal.fromJson(json.decode(str));

String pendingReportsLevel2ModalToJson(SchoolReportsLevel2Modal data) => json.encode(data.toJson());

class SchoolReportsLevel2Modal {
  int srNo;
  int id;
  String standard;
  int totalStudent;
  int totalStandard;
  DateTime date;
  double totalSale;


  SchoolReportsLevel2Modal({
    required this.srNo,
    required this.id,
    required this.standard,
    required this.totalStudent,
    required this.totalStandard,
    required this.date,
    required this.totalSale,
  });

  factory SchoolReportsLevel2Modal.fromJson(Map<String, dynamic> json) => SchoolReportsLevel2Modal(
    srNo: json["srNo"],
    id: json["id"],
    standard: json["standard"],
    totalStudent: json["totalStudent"],
    totalStandard: json["totalStandard"],
    date: DateTime.parse(json["date"]),
    totalSale: json["totalSale"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "id": id,
    "standard": standard,
    "totalStudent": totalStudent,
    "totalStandard": totalStandard,
    "date": date.toIso8601String(),
    "totalSale": totalSale,
  };
}
