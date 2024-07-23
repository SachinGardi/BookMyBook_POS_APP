import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tuck_shop/utility/base_url.dart';

import '../../modal/order_history_modal/get_order_history_modal.dart';
class GetOrderHistoryRepo{

  static List<GetOrderHistoryModal> orderHistoryList = [];
  static List<OrderHistoryPageDetail> orderHistoryPageDetail = [];

  static getOrderHistoryData(
      String pageNo,
      String textSearch,
      int userId,
      int statusId,
      int timeId,
      String fromDate,
      String toDate,
      int schoolId,
      int stdId,
      int divId,
      String orderId,
      String invoiceId,
      )async{
    var queryParams = {
      'PageNo':pageNo,
      'PageSize':'${10}',
      'TextSearch':textSearch,
      'UserId':'$userId',
      'Status':'$statusId',
      'Time':'$timeId',
      'Fromdate':fromDate,
      'Todate':toDate,
      'SchoolId':'$schoolId',
      'Standard':'$stdId',
      'Division':'$divId',
      'OrderId':orderId,
      'InvoiceId':invoiceId
    };
    Uri url = Uri.http(baseUrl,'tuckshop/api/PointOfSale/get-OrderHistory',queryParams);
    try{
      http.Response response = (await http.get(url));
      if(response.statusCode == 200){
        print('order history');
        print(url);
        print(response.body);
        Map res = jsonDecode(response.body);

        final value = OrderHistoryPageDetail.fromJson(res['responseData1']);
        orderHistoryPageDetail.add(value);

        res['responseData'].forEach((data){
          orderHistoryList.add(
              GetOrderHistoryModal(
                  id: data['id'],
                  orderId: data['orderId'],
                  studentName: data['studentName'],
                  schoolName: data['schoolName'],
                  statusId: data['statusId'],
                  status: data['status'],
                  mobileNo: data['mobileNo'],
                  standard: data['standard'],
                  division: data['division'],
                  orderValue: data['orderValue'],
                  invoiceList: data['invoiceList'] == null ? []:List<InvoiceListModal>.from(data['invoiceList']!.map((x)=>InvoiceListModal.fromJson(x))),
                  orderHistoryPageDetailList: orderHistoryPageDetail
              )
          );
        });

        return orderHistoryList;


      }
    }catch(err){
      if(kDebugMode){
        print("Exception in Data $err");
      }
    }
  }
}