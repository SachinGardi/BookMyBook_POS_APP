
class TransactionReportModal {
  int? srNo;
  int? id;
  String? schoolName;
  String? orderId;
  String? paymentType;
  DateTime? date;
  double? totalAmount;
  String? studentName;
  List<TransactionPageModal>? transactionPageList;

  TransactionReportModal({
    required this.srNo,
    required this.id,
    required this.schoolName,
    required this.orderId,
    required this.paymentType,
    required this.date,
    required this.totalAmount,
    required this.studentName,
    required this.transactionPageList,
  });

  factory TransactionReportModal.fromJson(Map<String, dynamic> json) => TransactionReportModal(
    srNo: json["srNo"],
    id: json["id"],
    schoolName: json["schoolName"],
    orderId: json["orderId"],
    paymentType: json["paymentType"],
    date: DateTime.parse(json["date"]),
    totalAmount: json["totalAmount"],
    studentName: json["studentName"],
    transactionPageList: json["transactionPageList"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "id": id,
    "schoolName": schoolName,
    "orderId": orderId,
    "paymentType": paymentType,
    "date": date?.toIso8601String(),
    "totalAmount": totalAmount,
    "studentName": studentName,
    "transactionPageList": transactionPageList,
  };
}


class TransactionPageModal {
  int pageNo;
  int totalCount;
  int totalPages;

  TransactionPageModal({
    required this.pageNo,
    required this.totalCount,
    required this.totalPages,
  });

  factory TransactionPageModal.fromJson(Map<String, dynamic> json) => TransactionPageModal(
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