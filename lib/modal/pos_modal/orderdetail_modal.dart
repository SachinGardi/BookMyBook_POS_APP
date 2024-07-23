class OrderDetailModal {
  int? bookId;
  String? bookType;
  double? id;
  String? bookName;
  double? taxRate;


  OrderDetailModal({
    this.bookId,
    this.bookType,
    this.id,
    this.bookName,
    this.taxRate,

  });

  factory OrderDetailModal.fromJson(Map<String, dynamic> json) => OrderDetailModal(
    bookId: json["bookId"],
    bookType: json["bookType"],
    id: json["id"],
    bookName: json["text"],
    taxRate: json["taxRate"],

  );

  Map<String, dynamic> toJson() => {
    "bookId": bookId,
    "bookType": bookType,
    "id": id,
    "text": bookName,
    "taxRate": taxRate,

  };
}
