class DashboardSchoolModal {
  int? id;
  String? schools;

  DashboardSchoolModal({
    this.id,
    this.schools,
  });

  factory DashboardSchoolModal.fromJson(Map<String, dynamic> json) => DashboardSchoolModal(
    id: json["id"],
    schools: json["schools"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "schools": schools,
  };
}
