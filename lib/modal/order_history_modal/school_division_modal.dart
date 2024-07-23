import 'dart:convert';

OrderHistorySchoolDivisionDropdown orderHistorySchoolDivisionDropdownFromJson(String str) => OrderHistorySchoolDivisionDropdown.fromJson(json.decode(str));

String orderHistorySchoolDivisionDropdownToJson(OrderHistorySchoolDivisionDropdown data) => json.encode(data.toJson());

class OrderHistorySchoolDivisionDropdown {
  int id;
  String text;

  OrderHistorySchoolDivisionDropdown({
    required this.id,
    required this.text,
  });

  factory OrderHistorySchoolDivisionDropdown.fromJson(Map<String, dynamic> json) => OrderHistorySchoolDivisionDropdown(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
