import 'dart:async';
import 'package:get/get.dart';
import 'package:tuck_shop/modal/pos_modal/standard_modal.dart';
import 'package:tuck_shop/repository/pos_repository/standard_repo.dart';

class PosStandardVM extends GetxController {
  var isLoading = true.obs;
  List<PosStandardModal> posStandardList = [];
  List<PosStandardModal> dashboardStandardList = [];

  getPosStandardInfo(int schoolId) async {
    var standardData = await PosStandardRepository.posStandardDetails(schoolId);
    if (standardData != null) {
      posStandardList = standardData;
      isLoading.value = false;
    }
    else {
      Timer(const Duration(seconds: 2), () {
        isLoading.value = false;
      });
    }
  }



}