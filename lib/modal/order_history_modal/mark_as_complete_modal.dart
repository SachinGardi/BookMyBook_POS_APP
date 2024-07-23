// To parse this JSON data, do
//
//     final markAsCompleteModal = markAsCompleteModalFromJson(jsonString);

import 'dart:convert';

MarkAsCompleteModal markAsCompleteModalFromJson(String str) => MarkAsCompleteModal.fromJson(json.decode(str));

String markAsCompleteModalToJson(MarkAsCompleteModal data) => json.encode(data.toJson());

class MarkAsCompleteModal {
  int id;
  int orderId;
  List<SaveboolList> saveboolList;

  MarkAsCompleteModal({
    required this.id,
    required this.orderId,
    required this.saveboolList,
  });

  factory MarkAsCompleteModal.fromJson(Map<String, dynamic> json) => MarkAsCompleteModal(
    id: json["id"],
    orderId: json["orderId"],
    saveboolList: List<SaveboolList>.from(json["saveboolList"].map((x) => SaveboolList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "saveboolList": List<dynamic>.from(saveboolList.map((x) => x.toJson())),
  };
}

class SaveboolList {
  int bookId;
  double price;
  int qty;
  String type;
  int createdBy;

  SaveboolList({
    required this.bookId,
    required this.price,
    required this.qty,
    required this.type,
    required this.createdBy,
  });

  factory SaveboolList.fromJson(Map<String, dynamic> json) => SaveboolList(
    bookId: json["bookId"],
    price: json["price"],
    qty: json["qty"],
    type: json["type"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "bookId": bookId,
    "price": price,
    "qty": qty,
    "type": type,
    "createdBy": createdBy,
  };
}
