import 'dart:async';
import 'package:get/get.dart';
import '../../modal/dashboard_modal/bargraphdata_modal.dart';
import '../../repository/dashbord_repository/bargraph_repo.dart';

class BarGraphVM extends GetxController{
var isLoading = false.obs;
List<BarGraphModal> barDataList = [];
String? barLabelName;
getBarGraphData(String userId,String fromDate, String toDate,String schoolId,String standardId ,String divisionId) async {
  var data = await BarGraphRepo.barData(userId,fromDate, toDate,schoolId,standardId,divisionId);
  print("data$data");
  if(data != null){
    barDataList = data;
    isLoading.value = false;
    barLabelName = BarGraphRepo.barLabelName;
  }
  else{
    Timer(const Duration(seconds: 1),() {
      isLoading.value = false;
    });
  }
}
}