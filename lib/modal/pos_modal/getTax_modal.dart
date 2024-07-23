

import 'dart:convert';

GetTaxModal getTaxModalFromJson(String str) => GetTaxModal.fromJson(json.decode(str));

String getTaxModalToJson(GetTaxModal data) => json.encode(data.toJson());

class GetTaxModal {
  int id;
  String text;

  GetTaxModal({
    required this.id,
    required this.text,
  });

  factory GetTaxModal.fromJson(Map<String, dynamic> json) => GetTaxModal(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
