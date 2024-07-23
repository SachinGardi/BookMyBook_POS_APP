
import 'dart:convert';

OrderHistoryTimerFilterDropdown orderHistoryTimerFilterDropdownFromJson(String str) => OrderHistoryTimerFilterDropdown.fromJson(json.decode(str));

String orderHistoryTimerFilterDropdownToJson(OrderHistoryTimerFilterDropdown data) => json.encode(data.toJson());

class OrderHistoryTimerFilterDropdown {
  int id;
  String text;

  OrderHistoryTimerFilterDropdown({
    required this.id,
    required this.text,
  });

  factory OrderHistoryTimerFilterDropdown.fromJson(Map<String, dynamic> json) => OrderHistoryTimerFilterDropdown(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}