import 'dart:async';
import 'package:get/get.dart';
import '../../modal/order_history_modal/timer_filter_modal.dart';
import '../../repository/order_history_repository/order_history_timer_filter_repo.dart';

class OrderHistoryTimerFilterVm extends GetxController{
  List<OrderHistoryTimerFilterDropdown> ohTimerFilterDropListVm =[];
  var isLoading = true.obs;

  getOhTimerFilter()async{
    var timerData = await OrderHistoryTimerFilterRepo.getTimerFilter();
    if(timerData != null){
      ohTimerFilterDropListVm = timerData;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
  }
}