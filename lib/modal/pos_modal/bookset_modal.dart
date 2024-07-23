

class PosBookSetModal {
  int? srNo;
  int? id;
  String? bookName;
  int? schoolId;
  String? schoolName;
  int? standardId;
  String? standard;
  double? sellingPrice;
  String? pulicationName;
  String? type;
  int? qty;
  double? taxRate;
  bool? isPending;

  PosBookSetModal({
    this.srNo,
    this.id,
    this.bookName,
    this.schoolId,
    this.schoolName,
    this.standardId,
    this.standard,
    this.sellingPrice,
    this.pulicationName,
    this.type,
    this.qty,
    this.taxRate,
    this.isPending
  });

  factory PosBookSetModal.fromJson(Map<String, dynamic> json) => PosBookSetModal(
    srNo: json["srNo"],
    id: json["id"],
    bookName: json["bookName"],
    schoolId: json["schoolId"],
    schoolName: json["schoolName"],
    standardId: json["standardId"],
    standard: json["standard"],
    sellingPrice: json["sellingPrice"],
    pulicationName: json["pulicationName"],
    type: json["type"],
    qty: json["qty"],
    taxRate: json["taxRate"],
    isPending: json["isPending"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "id": id,
    "bookName": bookName,
    "schoolId": schoolId,
    "schoolName": schoolName,
    "standardId": standardId,
    "standard": standard,
    "sellingPrice": sellingPrice,
    "pulicationName": pulicationName,
    "type": type,
    "qty": qty,
    "taxRate": taxRate,
    "isPending": isPending,
  };
}
