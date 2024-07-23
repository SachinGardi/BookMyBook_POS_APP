


class ChangePasswordModal {
  int userId;
  String currentPassword;
  String newPassword;

  ChangePasswordModal({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordModal.fromJson(Map<String, dynamic> json) => ChangePasswordModal(
    userId: json["userId"],
    currentPassword: json["currentPassword"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "currentPassword": currentPassword,
    "newPassword": newPassword,
  };
}
