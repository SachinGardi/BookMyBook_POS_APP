class ProfileModal {
  String? name;
  String? emailId;
  String? mobileNo;
  String? dob;
  String? gender;

  ProfileModal({
    this.name,
    this.emailId,
    this.mobileNo,
    this.dob,
    this.gender,
  });

  factory ProfileModal.fromJson(Map<String, dynamic> json) => ProfileModal(
    name: json["name"],
    emailId: json["emailId"],
    mobileNo: json["mobileNo"],
    dob: json["dob"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "emailId": emailId,
    "mobileNo": mobileNo,
    "dob": dob,
    "gender": gender,
  };
}
