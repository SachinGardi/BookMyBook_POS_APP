
import 'dart:convert';

PendingReportsLevel2Modal pendingReportsLevel2ModalFromJson(String str) => PendingReportsLevel2Modal.fromJson(json.decode(str));

String pendingReportsLevel2ModalToJson(PendingReportsLevel2Modal data) => json.encode(data.toJson());

class PendingReportsLevel2Modal {
  int srNo;
  int oId;
  String orderId;
  String studentName;
  String division;
  DateTime date;
  String mobileNo;
  int qtyPending;

  PendingReportsLevel2Modal({
    required this.srNo,
    required this.oId,
    required this.orderId,
    required this.studentName,
    required this.division,
    required this.date,
    required this.mobileNo,
    required this.qtyPending,
  });

  factory PendingReportsLevel2Modal.fromJson(Map<String, dynamic> json) => PendingReportsLevel2Modal(
    srNo: json["srNo"],
    oId: json["oId"],
    orderId: json["orderId"],
    studentName: json["studentName"],
    division: json["division"],
    date: DateTime.parse(json["date"]),
    mobileNo: json["mobileNo"],
    qtyPending: json["qtyPending"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "oId": oId,
    "orderId": orderId,
    "studentName": studentName,
    "division": division,
    "date": date.toIso8601String(),
    "mobileNo": mobileNo,
    "qtyPending": qtyPending,
  };
}
