import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repository/change_password/change_password_repo.dart';

class ChangePasswordVm extends GetxController {
  var isLoading = true.obs;

  postPassword(int userId,String currentPassword,String newPassword,BuildContext context) async {
    await ChangePasswordRepo.changePasswordData(
      userId,
      currentPassword,
      newPassword,
      context
    );
  }
}