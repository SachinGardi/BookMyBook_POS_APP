

import 'dart:convert';

PrintInvoiceModal printInvoiceModalFromJson(String str) => PrintInvoiceModal.fromJson(json.decode(str));

String printInvoiceModalToJson(PrintInvoiceModal data) => json.encode(data.toJson());

class PrintInvoiceModal {
  int id;
  DateTime invoiceDate;
  String invoiceNo;
  String payment;
  String customerMobileNo;
  String schoolName;
  String studentName;
  String standard;
  double subTotal;
  String discountType;
  double discount;
  double totalAmount;
  String remark;
  int totalQty;
  List<GstBreakUp> gstBreakUp;
  List<ItemList> itemList;
  List<PendingItemList> pendingItemList;

  PrintInvoiceModal({
    required this.id,
    required this.invoiceDate,
    required this.invoiceNo,
    required this.payment,
    required this.customerMobileNo,
    required this.schoolName,
    required this.studentName,
    required this.standard,
    required this.subTotal,
    required this.discountType,
    required this.discount,
    required this.totalAmount,
    required this.remark,
    required this.totalQty,
    required this.gstBreakUp,
    required this.itemList,
    required this.pendingItemList
  });

  factory PrintInvoiceModal.fromJson(Map<String, dynamic> json) => PrintInvoiceModal(
    id: json["id"],
    invoiceDate: DateTime.parse(json["invoiceDate"]),
    invoiceNo: json["invoiceNo"],
    payment: json["payment"],
    customerMobileNo: json["customerMobileNo"],
    schoolName: json["schoolName"],
    studentName: json["studentName"],
    standard: json["standard"],
    subTotal: json["subTotal"].toDouble(),
    discountType: json["discountType"],
    discount: json["discount"],
    totalAmount: json["totalAmount"],
    remark: json["remark"],
    totalQty: json["totalQty"],
    gstBreakUp: List<GstBreakUp>.from(json["gstBreakUp"].map((x) => GstBreakUp.fromJson(x))),
    itemList: List<ItemList>.from(json["itemList"].map((x) => ItemList.fromJson(x))),
    pendingItemList: List<PendingItemList>.from(json["pendingItemList"].map((x) => PendingItemList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoiceDate": invoiceDate.toIso8601String(),
    "invoiceNo": invoiceNo,
    "payment": payment,
    "customerMobileNo": customerMobileNo,
    "schoolName": schoolName,
    "studentName": studentName,
    "standard": standard,
    "subTotal": subTotal,
    "discountType": discountType,
    "discount": discount,
    "totalAmount": totalAmount,
    "remark": remark,
    "totalQty": totalQty,
    "gstBreakUp": List<dynamic>.from(gstBreakUp.map((x) => x.toJson())),
    "itemList": List<dynamic>.from(itemList.map((x) => x.toJson())),
    "pendingItemList": List<dynamic>.from(pendingItemList.map((x) => x.toJson())),
  };
}

class GstBreakUp {
  double cgst;
  double sgst;
  double cgstAmount;
  double sgstAmount;
  String type;

  GstBreakUp({
    required this.cgst,
    required this.sgst,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.type,
  });

  factory GstBreakUp.fromJson(Map<String, dynamic> json) => GstBreakUp(
    cgst: json["cgst"]?.toDouble(),
    sgst: json["sgst"]?.toDouble(),
    cgstAmount: json["cgstAmount"]?.toDouble(),
    sgstAmount: json["sgstAmount"]?.toDouble(),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "cgst": cgst,
    "sgst": sgst,
    "cgstAmount": cgstAmount,
    "sgstAmount": sgstAmount,
    "type": type,
  };
}

class ItemList {
  String item;
  double cgst;
  double sgst;
  double cgstAmount;
  double sgstAmount;
  int qty;
  double price;
  double amount;

  ItemList({
    required this.item,
    required this.cgst,
    required this.sgst,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.qty,
    required this.price,
    required this.amount,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
    item: json["item"],
    cgst: json["cgst"]?.toDouble(),
    sgst: json["sgst"]?.toDouble(),
    cgstAmount: json["cgstAmount"]?.toDouble(),
    sgstAmount: json["sgstAmount"]?.toDouble(),
    qty: json["qty"],
    price: json["price"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "item": item,
    "cgst": cgst,
    "sgst": sgst,
    "cgstAmount": cgstAmount,
    "sgstAmount": sgstAmount,
    "qty": qty,
    "price": price,
    "amount": amount,
  };
}

class PendingItemList {
  String item;
  double cgst;
  double sgst;
  double cgstAmount;
  double sgstAmount;
  int qty;
  double price;
  double amount;

  PendingItemList({
    required this.item,
    required this.cgst,
    required this.sgst,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.qty,
    required this.price,
    required this.amount,
  });

  factory PendingItemList.fromJson(Map<String, dynamic> json) => PendingItemList(
    item: json["item"],
    cgst: json["cgst"]?.toDouble(),
    sgst: json["sgst"]?.toDouble(),
    cgstAmount: json["cgstAmount"]?.toDouble(),
    sgstAmount: json["sgstAmount"]?.toDouble(),
    qty: json["qty"],
    price: json["price"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "item": item,
    "cgst": cgst,
    "sgst": sgst,
    "cgstAmount": cgstAmount,
    "sgstAmount": sgstAmount,
    "qty": qty,
    "price": price,
    "amount": amount,
  };
}
