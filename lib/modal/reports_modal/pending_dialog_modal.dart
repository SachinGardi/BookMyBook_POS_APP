// To parse this JSON data, do
//
//     final pendingDialogModal = pendingDialogModalFromJson(jsonString);

import 'dart:convert';

PendingDialogModal pendingDialogModalFromJson(String str) => PendingDialogModal.fromJson(json.decode(str));

String pendingDialogModalToJson(PendingDialogModal data) => json.encode(data.toJson());

class PendingDialogModal {
  int id;
  int orderId;
  String invoiceId;
  String mobileNo;
  DateTime date;
  String schoolName;
  String standard;
  String division;
  String parentName;
  String studentName;
  String transactionID;
  String paymentType;
  double orderValue;
  List<PendingBooklist> pendingBooklist;

  PendingDialogModal({
    required this.id,
    required this.orderId,
    required this.invoiceId,
    required this.mobileNo,
    required this.date,
    required this.schoolName,
    required this.standard,
    required this.division,
    required this.parentName,
    required this.studentName,
    required this.transactionID,
    required this.paymentType,
    required this.orderValue,
    required this.pendingBooklist,
  });

  factory PendingDialogModal.fromJson(Map<String, dynamic> json) => PendingDialogModal(
    id: json["id"],
    orderId: json["orderId"],
    invoiceId: json["invoiceId"],
    mobileNo: json["mobileNo"],
    date: DateTime.parse(json["date"]),
    schoolName: json["schoolName"],
    standard: json["standard"],
    division: json["division"],
    parentName: json["parentName"],
    studentName: json["studentName"],
    transactionID: json["transactionID"],
    paymentType: json["paymentType"],
    orderValue: json["orderValue"],
    pendingBooklist: List<PendingBooklist>.from(json["pendingBooklist"].map((x) => PendingBooklist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "invoiceId": invoiceId,
    "mobileNo": mobileNo,
    "date": date.toIso8601String(),
    "schoolName": schoolName,
    "standard": standard,
    "division": division,
    "parentName": parentName,
    "studentName": studentName,
    "transactionID": transactionID,
    "paymentType": paymentType,
    "orderValue": orderValue,
    "pendingBooklist": List<dynamic>.from(pendingBooklist.map((x) => x.toJson())),
  };
}

class PendingBooklist {
  int srNo;
  int bookId;
  String bookName;
  String type;
  String publication;
  double amount;
  int qty;

  PendingBooklist({
    required this.srNo,
    required this.bookId,
    required this.bookName,
    required this.type,
    required this.publication,
    required this.amount,
    required this.qty,
  });

  factory PendingBooklist.fromJson(Map<String, dynamic> json) => PendingBooklist(
    srNo: json["srNo"],
    bookId: json["bookId"],
    bookName: json["bookName"],
    type: json["type"],
    publication: json["publication"],
    amount: json["amount"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "bookId": bookId,
    "bookName": bookName,
    "type": type,
    "publication": publication,
    "amount": amount,
    "qty": qty,
  };
}
