
import 'dart:convert';

TimeFilterModal timeFilterModalFromJson(String str) => TimeFilterModal.fromJson(json.decode(str));

String timeFilterModalToJson(TimeFilterModal data) => json.encode(data.toJson());

class TimeFilterModal {
  int id;
  String text;

  TimeFilterModal({
    required this.id,
    required this.text,
  });

  factory TimeFilterModal.fromJson(Map<String, dynamic> json) => TimeFilterModal(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
