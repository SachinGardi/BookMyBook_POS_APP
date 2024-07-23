class DashboardStandardModal {
  int? id;
  String? text;

  DashboardStandardModal({
    this.id,
    this.text,
  });

  factory DashboardStandardModal.fromJson(Map<String, dynamic> json) => DashboardStandardModal(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
