// To parse this JSON data, do
//
//     final invoicePopupModal = invoicePopupModalFromJson(jsonString);

import 'dart:convert';

InvoicePopupModal invoicePopupModalFromJson(String str) => InvoicePopupModal.fromJson(json.decode(str));

String invoicePopupModalToJson(InvoicePopupModal data) => json.encode(data.toJson());

class InvoicePopupModal {
  int id;
  int orderId;
  String invoiceId;
  String mobileNo;
  String date;
  String standard;
  String division;
  double orderValue;
  List<BookLlistElementModal> bookLlist;
  List<BookLlistElementModal> pendingBooklist;

  InvoicePopupModal({
    required this.id,
    required this.orderId,
    required this.invoiceId,
    required this.mobileNo,
    required this.date,
    required this.standard,
    required this.division,
    required this.orderValue,
    required this.bookLlist,
    required this.pendingBooklist,
  });

  factory InvoicePopupModal.fromJson(Map<String, dynamic> json) => InvoicePopupModal(
    id: json["id"],
    orderId: json["orderId"],
    invoiceId: json["invoiceId"],
    mobileNo: json["mobileNo"],
    date: json["date"],
    standard: json["standard"],
    division: json["division"],
    orderValue: json["orderValue"],
    bookLlist: List<BookLlistElementModal>.from(json["bookLlist"].map((x) => BookLlistElementModal.fromJson(x))),
    pendingBooklist: List<BookLlistElementModal>.from(json["pendingBooklist"].map((x) => BookLlistElementModal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "invoiceId": invoiceId,
    "mobileNo": mobileNo,
    "date": date,
    "standard": standard,
    "division": division,
    "orderValue": orderValue,
    "bookLlist": List<dynamic>.from(bookLlist.map((x) => x.toJson())),
    "pendingBooklist": List<dynamic>.from(pendingBooklist.map((x) => x.toJson())),
  };
}

class BookLlistElementModal {
  int srNo;
  int bookId;
  String bookName;
  String type;
  String publication;
  double amount;
  int qty;

  BookLlistElementModal({
    required this.srNo,
    required this.bookId,
    required this.bookName,
    required this.type,
    required this.publication,
    required this.amount,
    required this.qty,
  });

  factory BookLlistElementModal.fromJson(Map<String, dynamic> json) => BookLlistElementModal(
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
