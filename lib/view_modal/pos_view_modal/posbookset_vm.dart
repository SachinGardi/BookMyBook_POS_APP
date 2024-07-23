import 'dart:async';
import 'package:get/get.dart';
import 'package:tuck_shop/modal/pos_modal/bookset_modal.dart';
import '../../repository/pos_repository/posbookset_repo.dart';
List<PosBookSetModal> allBooksList =[];
List<PosBookSetModal> allTextBooks =[];
List<PosBookSetModal> allNoteBooks =[];
List<PosBookSetModal> allStationary =[];
class PosBookSetVM  extends GetxController{
  List<PosBookSetModal>  bookSetList = [];
  var isLoading = true.obs;
  getBookSet(String pageNo,String pageSize,String textSearch,String schoolId,String standardId,String type)async{
    var data = await PosBookSetRepo.bookSetDetails(pageNo, pageSize, textSearch, schoolId, standardId, type);
  print("data$data");
    if(data!= null){
      bookSetList = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 1), () {
        isLoading.value = false;
      });
    }
  }
}