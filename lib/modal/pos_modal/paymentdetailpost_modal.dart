
class PaymentDetailPostModal {
  int? id;
  int? customerId;
  double? subTotal;
  String? discountType;
  double? discount;
  int? tax;
  int? status;
  int? createdBy;
  double? totalAmount;
  double? totalCGST;
  double? totalSGST;
  List<BookDetail>? bookDetails;

  PaymentDetailPostModal({
    this.id,
    this.customerId,
    this.subTotal,
    this.discountType,
    this.discount,
    this.tax,
    this.status,
    this.createdBy,
    this.totalAmount,
    this.bookDetails,
    this.totalCGST,
    this.totalSGST
  });

  factory PaymentDetailPostModal.fromJson(Map<String, dynamic> json) => PaymentDetailPostModal(
    id: json["id"],
    customerId: json["customerId"],
    subTotal: json["subTotal"],
    discountType: json["discountType"],
    discount: json["discount"],
    tax: json["tax"],
    status: json["status"],
    createdBy: json["createdBy"],
    totalAmount: json["totalAmount"],
    totalCGST: json["totalCGST"],
    totalSGST: json["totalSGST"],
    bookDetails: json["bookDetails"] == null ? [] : List<BookDetail>.from(json["bookDetails"]!.map((x) => BookDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "subTotal": subTotal,
    "discountType": discountType,
    "discount": discount,
    "tax": tax,
    "status": status,
    "createdBy": createdBy,
    "totalAmount": totalAmount,
    "totalCGST": totalCGST,
    "totalSGST": totalSGST,
    "bookDetails": bookDetails == null ? [] : List<dynamic>.from(bookDetails!.map((x) => x.toJson())),
  };
}

class BookDetail {
  int? id;
  int? orderId;
  int? bookId;
  double? price;
  int? qty;
  int? status;
  bool? paymentflag;
  DateTime? paymentdate;
  String? type;
  int? createdBy;
  double? cgst;
  double? sgst;
  double? cgstAmount;
  double? sgstAmount;

  BookDetail({
    this.id,
    this.orderId,
    this.bookId,
    this.price,
    this.qty,
    this.status,
    this.paymentflag,
    this.paymentdate,
    this.type,
    this.createdBy,
    this.cgst,
    this.sgst,
    this.cgstAmount,
    this.sgstAmount,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
    id: json["id"],
    orderId: json["orderId"],
    bookId: json["bookId"],
    price: json["price"],
    qty: json["qty"],
    status: json["status"],
    paymentflag: json["paymentflag"],
    paymentdate: json["paymentdate"] == null ? null : DateTime.parse(json["paymentdate"]),
    type: json["type"],
    createdBy: json["createdBy"],
    cgst: json["cgst"],
    sgst: json["sgst"],
    cgstAmount: json["cgstAmount"],
    sgstAmount: json["sgstAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "bookId": bookId,
    "price": price,
    "qty": qty,
    "status": status,
    "paymentflag": paymentflag,
    "paymentdate": paymentdate?.toIso8601String(),
    "type": type,
    "createdBy": createdBy,
    "cgst": cgst,
    "sgst": sgst,
    "cgstAmount": cgstAmount,
    "sgstAmount": sgstAmount,
  };
}
