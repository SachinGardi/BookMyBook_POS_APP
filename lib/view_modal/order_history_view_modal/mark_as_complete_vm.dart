import 'package:get/get.dart';
import '../../modal/order_history_modal/mark_as_complete_modal.dart';
import '../../repository/order_history_repository/mark_as_complete_repo.dart';

class MarkAsCompleteVm extends GetxController{

  var isLoading = true.obs;

  markAsCompleteRecord(int id,int orderId,List<SaveboolList> saveboolList )async{
    await MarkAsCompleteRepo.markAsCompleted(
        id,
        orderId,
        saveboolList
    );
     isLoading.value = false;
  }

}