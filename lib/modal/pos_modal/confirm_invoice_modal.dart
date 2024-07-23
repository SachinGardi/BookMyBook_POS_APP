import 'dart:convert';

ConfirmInvoiceModal confirmInvoiceModalFromJson(String str) => ConfirmInvoiceModal.fromJson(json.decode(str));

String confirmInvoiceModalToJson(ConfirmInvoiceModal data) => json.encode(data.toJson());

class ConfirmInvoiceModal {
  int id;
  int orderId;
  int totalQty;
  double totalAmount;
  String paymentMode;
  String remark;
  bool isPrintReceipt;
  int createdBy;

  ConfirmInvoiceModal({
    required this.id,
    required this.orderId,
    required this.totalQty,
    required this.totalAmount,
    required this.paymentMode,
    required this.remark,
    required this.isPrintReceipt,
    required this.createdBy,
  });

  factory ConfirmInvoiceModal.fromJson(Map<String, dynamic> json) => ConfirmInvoiceModal(
    id: json["id"],
    orderId: json["orderId"],
    totalQty: json["totalQty"],
    totalAmount: json["totalAmount"],
    paymentMode: json["paymentMode"],
    remark: json["remark"],
    isPrintReceipt: json["isPrintReceipt"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "totalQty": totalQty,
    "totalAmount": totalAmount,
    "paymentMode": paymentMode,
    "remark": remark,
    "isPrintReceipt": isPrintReceipt,
    "createdBy": createdBy,
  };
}
