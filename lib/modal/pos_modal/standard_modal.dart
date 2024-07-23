class PosStandardModal {
  int? id;
  String? text;

  PosStandardModal({
    this.id,
    this.text,
  });

  factory PosStandardModal.fromJson(Map<String, dynamic> json) => PosStandardModal(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
