// To parse this JSON data, do
//
//     final loginModal = loginModalFromJson(jsonString);

import 'dart:convert';

LoginModal loginModalFromJson(String str) => LoginModal.fromJson(json.decode(str));

String loginModalToJson(LoginModal data) => json.encode(data.toJson());

class LoginModal {
  ResponseData? responseData;
  ResponseData1? responseData1;

  LoginModal({
     this.responseData,
     this.responseData1,
  });

  factory LoginModal.fromJson(Map<String, dynamic> json) => LoginModal(
    responseData: ResponseData.fromJson(json["responseData"]),
    responseData1: ResponseData1.fromJson(json["responseData1"]),
  );

  Map<String, dynamic> toJson() => {
    "responseData": responseData!.toJson(),
    "responseData1": responseData1!.toJson(),
  };
}

class ResponseData {
  int? id;
  int? designationId;
  String? name;
  String? userName;
  String? emailId;
  String? mobileNo;
  dynamic msg;
  String? designation;
  String? imagePath;

  ResponseData({
     this.id,
     this.designationId,
     this.name,
     this.userName,
     this.emailId,
     this.mobileNo,
     this.msg,
     this.designation,
     this.imagePath,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    id: json["id"],
    designationId: json["designationId"],
    name: json["name"],
    userName: json["userName"],
    emailId: json["emailId"],
    mobileNo: json["mobileNo"],
    msg: json["msg"],
    designation: json["designation"],
    imagePath: json["imagePath"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "designationId": designationId,
    "name": name,
    "userName": userName,
    "emailId": emailId,
    "mobileNo": mobileNo,
    "msg": msg,
    "designation": designation,
    "imagePath": imagePath,
  };
}

class ResponseData1 {
  String? accessToken;
  DateTime? expireAccessToken;
  RefreshToken? refreshToken;

  ResponseData1({
     this.accessToken,
     this.expireAccessToken,
     this.refreshToken,
  });

  factory ResponseData1.fromJson(Map<String, dynamic> json) => ResponseData1(
    accessToken: json["accessToken"],
    expireAccessToken: DateTime.parse(json["expireAccessToken"]),
    refreshToken: RefreshToken.fromJson(json["refreshToken"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "expireAccessToken": expireAccessToken!.toIso8601String(),
    "refreshToken": refreshToken!.toJson(),
  };
}

class RefreshToken {
  String? userId;
  String? tokenString;
  DateTime? expireAt;

  RefreshToken({
     this.userId,
     this.tokenString,
     this.expireAt,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    userId: json["UserId"],
    tokenString: json["tokenString"],
    expireAt: DateTime.parse(json["expireAt"]),
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "tokenString": tokenString,
    "expireAt": expireAt!.toIso8601String(),
  };
}
