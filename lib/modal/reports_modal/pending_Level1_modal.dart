

class PendingLevel1Modal {
  int srNo;
  int id;
  int schoolId;
  String schoolName;
  String location;
  String standardId;
  String standard;
  int bookSetId;
  String bookSetName;
  int qtyPending;
  List<PendingL1PageModal>? pendingL1PageModalList;

  PendingLevel1Modal({
    required this.srNo,
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.location,
    required this.standardId,
    required this.standard,
    required this.bookSetId,
    required this.bookSetName,
    required this.qtyPending,
    required this.pendingL1PageModalList,
  });

  factory PendingLevel1Modal.fromJson(Map<String, dynamic> json) => PendingLevel1Modal(
    srNo: json["srNo"],
    id: json["id"],
    schoolId: json["schoolId"],
    schoolName: json["schoolName"],
    location: json["location"],
    standardId: json["standardId"],
    standard: json["standard"],
    bookSetId: json["bookSetId"],
    bookSetName: json["bookSetName"],
    qtyPending: json["qtyPending"],
    pendingL1PageModalList: json["pendingL1PageModalList"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "id": id,
    "schoolId": schoolId,
    "schoolName": schoolName,
    "location": location,
    "standardId": standardId,
    "standard": standard,
    "bookSetId": bookSetId,
    "bookSetName": bookSetName,
    "qtyPending": qtyPending,
    "pendingL1PageModalList": pendingL1PageModalList,
  };
}
class PendingL1PageModal {
  int pageNo;
  int totalCount;
  int totalPages;

  PendingL1PageModal({
    required this.pageNo,
    required this.totalCount,
    required this.totalPages,
  });

  factory PendingL1PageModal.fromJson(Map<String, dynamic> json) => PendingL1PageModal(
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