import 'dart:convert';

GetLoginSchoolModal getLoginSchoolFromJson(String str) => GetLoginSchoolModal.fromJson(json.decode(str));

String getLoginSchoolToJson(GetLoginSchoolModal data) => json.encode(data.toJson());

class GetLoginSchoolModal {
  int? id;
  String? schools;

  GetLoginSchoolModal({
     this.id,
     this.schools,
  });

  factory GetLoginSchoolModal.fromJson(Map<String, dynamic> json) => GetLoginSchoolModal(
    id: json["id"],
    schools: json["schools"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "schools": schools,
  };
}