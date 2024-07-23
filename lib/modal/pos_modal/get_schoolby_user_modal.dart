class GetSchoolByUserIdModal {
  int? id;
  String? schools;

  GetSchoolByUserIdModal({
    this.id,
    this.schools,
  });

  factory GetSchoolByUserIdModal.fromJson(Map<String, dynamic> json) => GetSchoolByUserIdModal(
    id: json["id"],
    schools: json["schools"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "schools": schools,
  };
}
