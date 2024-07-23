class DivisionModal {
  int? id;
  String? text;

  DivisionModal({
    this.id,
    this.text,
  });

  factory DivisionModal.fromJson(Map<String, dynamic> json) => DivisionModal(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
