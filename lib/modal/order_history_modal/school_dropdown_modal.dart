import 'dart:convert';

OrderHistorySchoolDropdown orderHistorySchoolDropdownFromJson(String str) => OrderHistorySchoolDropdown.fromJson(json.decode(str));

String orderHistorySchoolDropdownToJson(OrderHistorySchoolDropdown data) => json.encode(data.toJson());

class OrderHistorySchoolDropdown {
  int id;
  String schools;

  OrderHistorySchoolDropdown({
    required this.id,
    required this.schools,
  });

  factory OrderHistorySchoolDropdown.fromJson(Map<String, dynamic> json) => OrderHistorySchoolDropdown(
    id: json["id"],
    schools: json["schools"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "schools": schools,
  };
}
