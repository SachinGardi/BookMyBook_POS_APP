

import 'dart:convert';

SchoolReportsLevel3Modal schoolReportsLevel3ModalFromJson(String str) => SchoolReportsLevel3Modal.fromJson(json.decode(str));

String schoolReportsLevel3ModalToJson(SchoolReportsLevel3Modal data) => json.encode(data.toJson());

class SchoolReportsLevel3Modal {
  int srNo;
  int id;
  String division;
  int students;
  int totalStudents;
  int totalDivision;
  DateTime date;
  double totalSale;

  SchoolReportsLevel3Modal({
    required this.srNo,
    required this.id,
    required this.division,
    required this.students,
    required this.totalStudents,
    required this.totalDivision,
    required this.date,
    required this.totalSale,
  });

  factory SchoolReportsLevel3Modal.fromJson(Map<String, dynamic> json) => SchoolReportsLevel3Modal(
    srNo: json["srNo"],
    id: json["id"],
    division: json["division"],
    students: json["students"],
    totalStudents: json["totalStudents"],
    totalDivision: json["totalDivision"],
    date: DateTime.parse(json["date"]),
    totalSale: json["totalSale"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "id": id,
    "division": division,
    "students": students,
    "totalStudents": totalStudents,
    "totalDivision": totalDivision,
    "date": date.toIso8601String(),
    "totalSale": totalSale,
  };
}
