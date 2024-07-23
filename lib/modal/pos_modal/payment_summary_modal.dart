
import 'dart:convert';

PaymentSummaryModal paymentSummaryModalFromJson(String str) => PaymentSummaryModal.fromJson(json.decode(str));

String paymentSummaryModalToJson(PaymentSummaryModal data) => json.encode(data.toJson());

class PaymentSummaryModal {
  String studentName;
  String standard;
  String division;
  int totalQty;
  double totalAmount;

  PaymentSummaryModal({
    required this.studentName,
    required this.standard,
    required this.division,
    required this.totalQty,
    required this.totalAmount,
  });

  factory PaymentSummaryModal.fromJson(Map<String, dynamic> json) => PaymentSummaryModal(
    studentName: json["studentName"],
    standard: json["standard"],
    division: json["division"],
    totalQty: json["totalQty"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "studentName": studentName,
    "standard": standard,
    "division": division,
    "totalQty": totalQty,
    "totalAmount": totalAmount,
  };
}
