import 'dart:convert';

OrderHistorySchoolStandardDropdown orderHistorySchoolStandardDropdownFromJson(String str) => OrderHistorySchoolStandardDropdown.fromJson(json.decode(str));

String orderHistorySchoolStandardDropdownToJson(OrderHistorySchoolStandardDropdown data) => json.encode(data.toJson());

class OrderHistorySchoolStandardDropdown {
  int id;
  String text;

  OrderHistorySchoolStandardDropdown({
    required this.id,
    required this.text,
  });

  factory OrderHistorySchoolStandardDropdown.fromJson(Map<String, dynamic> json) => OrderHistorySchoolStandardDropdown(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
