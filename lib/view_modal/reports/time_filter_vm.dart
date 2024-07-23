import 'dart:async';
import 'package:get/get.dart';
import '../../modal/reports_modal/time_filter_modal.dart';
import '../../repository/reports/time_filter_repo.dart';

class TimeFilterVm extends GetxController {
  var isLoading = true.obs;
  List<TimeFilterModal> timeFilterList = [];

  getTimeFilterInfo() async {
    var filterData = await TimeFilterRepo.gettimeFilter();
    if(filterData != null){
      timeFilterList = filterData;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
  }
}