import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modal/order_history_modal/get_order_history_modal.dart';
import '../../repository/order_history_repository/get_order_history_repo.dart';

int? orderHistoryTotalPages;
int? orderHistoryTotal;

class GetOrderHistoryVm extends GetxController {
  List<InvoiceListModal> invoiceListVm = [];
  List<GetOrderHistoryModal> orderHistoryListVm = [];
  List<OrderHistoryPageDetail> orderHistoryPageDetail = [];
  var isLoading = true.obs;

  getOrderHistoryVm(
      int pageNo,
      String textSearch,
      int statusId,
      int timeId,
      String fromDate,
      String toDate,
      int schoolId,
      int stdId,
      int divId,
      String orderId,
      String invoiceId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = await GetOrderHistoryRepo.getOrderHistoryData(
        pageNo.toString(),
        textSearch,
        pref.getInt('userId')!,
        statusId,
        timeId,
        fromDate,
        toDate,
        schoolId,
        stdId,
        divId,
        orderId,
        invoiceId);
    print(data);
    if (data != null) {
      orderHistoryListVm = data;
      invoiceListVm = orderHistoryListVm[0].invoiceList!;
      isLoading.value = false;

    } else {
      Timer(const Duration(seconds: 2), () {
        isLoading.value = false;
      });
    }
    orderHistoryListVm.forEach((element) {
      for (var pageDetail in element.orderHistoryPageDetailList!) {
        orderHistoryTotalPages = pageDetail.totalPages;
        orderHistoryTotal = pageDetail.totalCount;
      }
    });

    print("######$orderHistoryTotalPages");
    print("######$orderHistoryTotal");

  }
}
