

import 'dart:async';

import 'package:get/get.dart';

import '../../modal/pos_modal/getTax_modal.dart';
import '../../repository/pos_repository/getTax_repo.dart';


String? taxPercentage;
class GetTaxVM extends GetxController {
   var isLoading = true.obs;
   List<GetTaxModal> getTaxList = [];

   getTaxInfo() async {
     var getTaxData = await GetTaxRepository.getTaxDetails();
     if(getTaxData != null){
       getTaxList = getTaxData;
       isLoading.value = false;
     } else{
       Timer(const Duration(seconds: 2),(){
         isLoading.value = false;
       });
     }
     getTaxList.forEach((element) {
       taxPercentage = element.text;
     });
     print(taxPercentage);
   }
}