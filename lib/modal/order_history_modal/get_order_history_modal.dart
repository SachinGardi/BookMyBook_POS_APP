import 'dart:convert';

GetOrderHistoryModal getOrderHistoryModalFromJson(String str) => GetOrderHistoryModal.fromJson(json.decode(str));

String getOrderHistoryModalToJson(GetOrderHistoryModal data) => json.encode(data.toJson());

class GetOrderHistoryModal {
  int id;
  int orderId;
  String studentName;
  String schoolName;
  int statusId;
  String status;
  String mobileNo;
  String standard;
  String division;
  double orderValue;
  List<InvoiceListModal> invoiceList;
  List<OrderHistoryPageDetail>? orderHistoryPageDetailList;

  GetOrderHistoryModal({
    required this.id,
    required this.orderId,
    required this.studentName,
    required this.schoolName,
    required this.statusId,
    required this.status,
    required this.mobileNo,
    required this.standard,
    required this.division,
    required this.orderValue,
    required this.invoiceList,
    required this.orderHistoryPageDetailList
  });

  factory GetOrderHistoryModal.fromJson(Map<String, dynamic> json) => GetOrderHistoryModal(
    id: json["id"],
    orderId: json["orderId"],
    studentName: json["studentName"],
    schoolName: json["schoolName"],
    statusId: json["statusId"],
    status: json["status"],
    mobileNo: json['mobileNo'],
    standard: json['standard'],
    division: json['division'],
    orderValue: json['orderValue'],
    invoiceList: List<InvoiceListModal>.from(json["invoiceList"].map((x) => InvoiceListModal.fromJson(x))),
    orderHistoryPageDetailList: json['orderHistoryPageDetailList']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "studentName": studentName,
    "schoolName": schoolName,
    "statusId": statusId,
    "status": status,
    "mobileNo":mobileNo,
    "standard":standard,
    "division":division,
    "orderValue":orderValue,
    "invoiceList": List<dynamic>.from(invoiceList.map((x) => x.toJson())),
    "orderHistoryPageDetailList":orderHistoryPageDetailList,
  };
}

class InvoiceListModal {
  int id;
  String invoiceId;
  DateTime date;


  InvoiceListModal({
    required this.id,
    required this.invoiceId,
    required this.date,

  });

  factory InvoiceListModal.fromJson(Map<String, dynamic> json) => InvoiceListModal(
    id: json["id"],
    invoiceId: json["invoiceId"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoiceId": invoiceId,
    "date": date.toIso8601String(),
  };
}

class OrderHistoryPageDetail {
  int pageNo;
  int totalCount;
  int totalPages;

  OrderHistoryPageDetail({
    required this.pageNo,
    required this.totalCount,
    required this.totalPages,
  });

  factory OrderHistoryPageDetail.fromJson(Map<String, dynamic> json) => OrderHistoryPageDetail(
    pageNo: json["pageNo"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "pageNo": pageNo,
    "totalCount": totalCount,
    "totalPages": totalPages,
  };
}