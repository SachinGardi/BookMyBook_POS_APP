class BarGraphModal {
  String? label;
  double? totalsale;

  BarGraphModal({
    this.label,
    this.totalsale,
  });

  factory BarGraphModal.fromJson(Map<String, dynamic> json) => BarGraphModal(
    label: json["label"],
    totalsale: json["totalsale"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "totalsale": totalsale,
  };
}
