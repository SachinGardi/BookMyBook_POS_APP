import 'dart:async';
import 'package:get/get.dart';
import '../../modal/dashboard_modal/dashboard_data_modal.dart';
import '../../repository/dashbord_repository/dashboard_card_data_repo.dart';

double? totalSale;
double? totalProfit;
double? avgSaleValue;
int? totalTransactions;
int? totalCancleOrder;
double? totalCancleOrderAmount;
double? totalUpi;
double? totalCash;
double? totalCard;
double? totalOtherPayment;

class DashboardDataVm extends GetxController{

  var isLoading = false.obs;
  List<DashboardDataModal> dashboardDatavmList = [];

   getDashboardDataVm(String userId, String schoolId, String stdId, String divId, String fromdate, String todate,) async {
    var data = await DashboardRepo.getDashboardData(userId, schoolId, stdId, divId, fromdate, todate);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@$data");
     if(data != null){
          dashboardDatavmList = data;
          isLoading.value = false;
        }
        else{
          Timer(const Duration(seconds: 2),(){
            isLoading.value = false;
          });
        }

    dashboardDatavmList.forEach((element) {
      totalSale = element.totalSales;
      totalProfit = element.totalProfit;
      avgSaleValue = element.avgSaleValue;
      totalTransactions = element.totalTransactions;
      totalCancleOrder = element.totalCancleOrder;
      totalCancleOrderAmount = element.totalCancleOrderAmount;
      totalCard = element.totalCard;
      totalCash = element.totalCash;
      totalUpi = element.totalUpi;
      totalOtherPayment= element.totalOtherPayment;
    });
  }

}