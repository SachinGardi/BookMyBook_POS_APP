import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/modal/order_history_modal/invoice_popup_modal.dart';
import 'package:tuck_shop/view/common_widgets/progress_indicator.dart';
import '../../modal/order_history_modal/mark_as_complete_modal.dart';
import '../../view_modal/order_history_view_modal/get_order_history_vm.dart';
import '../../view_modal/order_history_view_modal/invoice_popup_vm.dart';
import '../../view_modal/order_history_view_modal/mark_as_complete_vm.dart';
import 'order_history_screen.dart';

final markAsCompleteVm = Get.put(MarkAsCompleteVm());
final getOrderHistoryVm = Get.put(GetOrderHistoryVm());
List<SaveboolList> saveboolList = [];
Future<void> showPendingDialog(BuildContext context,List<InvoicePopupModal> invoicePopupData,String studentName,String schoolName,String status,int selectedIndex,String printInvoiceId) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final invoicePopupVm = Get.put(InvoicePopupVm());
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: const EdgeInsets.only(bottom: 2),
          actionsPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height/80
          ),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 40,
                    left: MediaQuery.of(context).size.width / 40,
                    bottom: MediaQuery.of(context).size.height /90,
                    right:MediaQuery.of(context).size.width / 40
                ),
                child: Row(
                  children: [
                    Text(
                      'Order History',
                      style: TextStyle(
                          fontFamily: "NotoSans",
                          color: const Color(0xFF5448D2),
                          fontSize: MediaQuery.of(context).size.height /40,
                          fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          print("printInvoiceId$printInvoiceId");
                          Get.offAllNamed("/receiptWebView",arguments:[orderId.toString(),2]);
                        },
                        child: const Icon(Icons.print,color: Color(0xff7367F0),)
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/20,),


                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child:  Icon(
                          Icons.cancel,color: const Color(0xff7367F0),
                          size: MediaQuery.of(context).size.height /20,
                        ))
                  ],
                ),
              ),
              const Divider(
                thickness: 2.5,
                color: Color(0xaaB5B5B5),
              )
            ],
          ),
          content: Obx(
                () => ModalProgressHUD(
              inAsyncCall: invoicePopupVm.isLoading.value == true || markAsCompleteVm.isLoading.value == true,
              progressIndicator: progressIndicator(),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height/1.6,
                  child: Padding(
                      padding:  EdgeInsets.symmetric(

                          horizontal: MediaQuery.of(context).size.width/50),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                                color: Color(0xffE0DDFC)
                            )
                        ),
                        elevation: 0,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50,
                                  vertical: MediaQuery.of(context).size.height/80,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(studentName,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,
                                        color: const Color(0xff3B3B3B)
                                    ),),
                                    Text(schoolName,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,
                                        color: const Color(0xff3B3B3B)
                                    ),),
                                    Text(status,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,
                                        color: Color(0xffBE5151)
                                    ),),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              ///standard and invoice row
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: MediaQuery.of(context).size.height/80,
                                    horizontal: MediaQuery.of(context).size.width/50
                                ),
                                child:  Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context).size.height/150
                                      ),
                                      child:  Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Invoice ID',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ))),
                                                Expanded(
                                                    flex: 0,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                SizedBox(width: MediaQuery.of(context).size.width/50,),
                                                Expanded(
                                                    flex: 5,
                                                    child: Text(invoicePopupData.first.invoiceId,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Mob',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),


                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 8,
                                                    child: Text(invoicePopupData.first.mobileNo,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              child: Row(

                                                children: [
                                                  Expanded(
                                                      flex:5,
                                                      child: Text('Date',style: TextStyle(
                                                          color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),
                                                        textAlign: TextAlign.end,
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(':',style: TextStyle(
                                                          color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),
                                                          textAlign: TextAlign.center
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(DateFormat('dd-MM-yyyy').format(DateTime.tryParse(invoicePopupData.first.date)!) ,style: TextStyle(
                                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(

                                          vertical: MediaQuery.of(context).size.height/150
                                      ),
                                      child:  Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Std',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 0,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                SizedBox(width: MediaQuery.of(context).size.width/50,),
                                                Expanded(
                                                    flex: 5,
                                                    child: Text(invoicePopupData.first.standard,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Div',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),


                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 8,
                                                    child: Text(invoicePopupData.first.division,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(

                                              children: [
                                                Expanded(
                                                    flex:5,
                                                    child: Text('Order Value',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),
                                                      textAlign: TextAlign.end,
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),
                                                        textAlign: TextAlign.center
                                                    )),
                                                Expanded(
                                                    flex: 4,
                                                    child: Text('₹ ${invoicePopupData.first.orderValue.round()}',style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              ///label for Rows
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50,
                                  vertical: MediaQuery.of(context).size.height/80,
                                ),
                                child: Row(

                                  children: [
                                    ///SrNo
                                    Expanded(
                                      flex:2,
                                      child: Text('Sr.No.',style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: MediaQuery.of(context).size.height/50,
                                          color: const Color(0xff3B3B3B)
                                      ),),
                                    ),
                                    ///Book Name
                                    Expanded(
                                      flex: 6,
                                      child: Text('Items',style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: MediaQuery.of(context).size.height/50,
                                          color: const Color(0xff3B3B3B)
                                      ),),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/150,),
                                    ///Publication
                                    Expanded(
                                      flex: 6,
                                      child: Text('Publication',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),

                                    ///Amount
                                    Expanded(
                                      flex: 2,
                                      child: Text('Amount',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),
                                    ///Quantity
                                    Expanded(
                                      flex: 0,
                                      child: Text('Quantity',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height/4.5,

                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: invoicePopupData[0].bookLlist.length,
                                  shrinkWrap: true,
                                  itemBuilder:(context, index) => Card(

                                    elevation: 0,
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width/50,
                                        vertical: MediaQuery.of(context).size.height/80,
                                      ),
                                      child: Row(

                                        children: [
                                          ///SrNo
                                          Expanded(
                                            flex:2,
                                            child: Text('${index + 1}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Book Name
                                          Expanded(
                                            flex: 7,
                                            child: Text(invoicePopupData[0].bookLlist[index].bookName,style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Publication
                                          Expanded(
                                            flex: 7,
                                            child: Text(invoicePopupData[0].bookLlist[index].publication,style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),

                                          ///Amount
                                          Expanded(
                                            flex: 2,
                                            child: Text('₹ ${invoicePopupData[0].bookLlist[index].amount.round()}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Quantity
                                          Expanded(
                                            flex: 1,
                                            child: Text('${invoicePopupData[0].bookLlist[index].qty}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),
                                                textAlign: TextAlign.right
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50,
                                  vertical: MediaQuery.of(context).size.height/80,
                                ),
                                child: Row(

                                  children: [
                                    ///SrNo
                                    Expanded(
                                      flex:2,
                                      child: Text('Sr.No.',style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: MediaQuery.of(context).size.height/50,
                                          color: const Color(0xff3B3B3B)
                                      ),),
                                    ),

                                    ///Book Name
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text('Pending Items',style: TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontWeight: FontWeight.w700,
                                            fontSize: MediaQuery.of(context).size.height/50,
                                            color: const Color(0xff3B3B3B)
                                        ),),
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/150,),
                                    ///Publication
                                    Expanded(
                                      flex: 6,
                                      child: Text('Publication',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),

                                    ///Amount
                                    Expanded(
                                      flex: 2,
                                      child: Text('Amount',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),
                                    ///Quantity
                                    Expanded(
                                      flex: 0,
                                      child: Text('Quantity',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height/7,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: ListView.builder(
                                  itemCount: invoicePopupData[0].pendingBooklist.length,
                                  shrinkWrap: true,
                                  itemBuilder:(context, index) => Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width/50,
                                        vertical: MediaQuery.of(context).size.height/80,
                                      ),
                                      child: Row(

                                        children: [
                                          ///SrNo
                                          Expanded(
                                            flex:2,
                                            child: Text('${index + 1}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Book Name
                                          Expanded(
                                            flex: 7,
                                            child: Text(invoicePopupData[0].pendingBooklist[index].bookName,style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Publication
                                          Expanded(
                                            flex: 7,
                                            child: Text(invoicePopupData[0].pendingBooklist[index].publication,style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),

                                          ///Amount
                                          Expanded(
                                            flex: 2,
                                            child: Text('₹ ${invoicePopupData[0].pendingBooklist[index].amount.round()}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Quantity
                                          Expanded(
                                            flex: 1,
                                            child: Text('${invoicePopupData[0].pendingBooklist[index].qty}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),
                                                textAlign: TextAlign.right
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ),
                              ),



                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/80,
                  right: MediaQuery.of(context).size.width/50
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height/80
                    )
                ),
                height: MediaQuery.of(context).size.height/18,
                color: const Color.fromRGBO(115, 103, 240, 1),

                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  saveboolList.clear();
                  for(var invoicedata in invoicePopupData.first.pendingBooklist){
                    print('####${invoicedata.bookId}#######');
                    saveboolList.add(
                        SaveboolList(
                            bookId: invoicedata.bookId,
                            price: invoicedata.amount,
                            qty: invoicedata.qty,
                            type: invoicedata.type,
                            createdBy: pref.getInt('userId')!
                        )
                    );


                  }
                  print('######${saveboolList.length}######');
                  if(saveboolList.isNotEmpty){
                    markAsCompleteVm.isLoading.value = true;
                    await markAsCompleteVm.markAsCompleteRecord(
                        invoicePopupData.first.id,
                        invoicePopupData.first.orderId,
                        saveboolList
                    );
                    Get.back();
                    if(selectedIndex == 0){
                      getOrderHistoryVm.orderHistoryListVm.clear();
                      getOrderHistoryVm.isLoading.value = true;
                      await getOrderHistoryVm.getOrderHistoryVm(
                          1,orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');
                    }
                    else{
                      getOrderHistoryVm.orderHistoryListVm.clear();
                      getOrderHistoryVm.isLoading.value = true;
                      await getOrderHistoryVm.getOrderHistoryVm(
                          1,orderHistorySearchCtx.text,1, 0, '', '', 0, 0, 0, '', '');
                    }
                  }

                },
                child:  Text('Mark as Completed',style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontFamily: 'NotoSans',
                    fontSize: MediaQuery.of(context).size.height/40
                ),),
              ),
            )
          ],


        );
      });
}
Future<void> showCompletedDialog(BuildContext context,List<InvoicePopupModal> invoicePopupData,String studentName,String schoolName,String status,int completedPrintID) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final invoicePopupVm = Get.put(InvoicePopupVm());
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: const EdgeInsets.only(bottom: 15,),

          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 40,
                    left: MediaQuery.of(context).size.width / 40,
                    bottom: MediaQuery.of(context).size.height /90,
                    right:MediaQuery.of(context).size.width / 40
                ),
                child: Row(
                  children: [
                    Text(
                      'Order History',
                      style: TextStyle(
                          fontFamily: "NotoSans",
                          color: const Color(0xFF5448D2),
                          fontSize: MediaQuery.of(context).size.height /40,
                          fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          Get.offAllNamed("/receiptWebView",arguments: [orderId.toString(),2]);
                        },
                        child: const Icon(Icons.print,color: Color(0xff7367F0),)),
                    SizedBox(width: MediaQuery.of(context).size.width/20,),
                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child:  Icon(
                          Icons.cancel,color: const Color(0xff7367F0),
                          size: MediaQuery.of(context).size.height /20,
                        ))
                  ],
                ),
              ),
              const Divider(
                thickness: 2.5,
                color: Color(0xaaB5B5B5),
              )
            ],
          ),
          content: Obx(
                () => ModalProgressHUD(
              inAsyncCall:invoicePopupVm.isLoading.value == true ,
              progressIndicator: progressIndicator(),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height/2,
                  child: Padding(
                      padding:  EdgeInsets.symmetric(

                          horizontal: MediaQuery.of(context).size.width/50),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                                color: Color(0xffE0DDFC)
                            )
                        ),
                        elevation: 0,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50,
                                  vertical: MediaQuery.of(context).size.height/80,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(studentName,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,
                                        color: const Color(0xff3B3B3B)
                                    ),),
                                    Text(schoolName,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,
                                        color: const Color(0xff3B3B3B)
                                    ),),
                                    Text(status,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,
                                        color: const Color.fromRGBO(18, 100, 23, 1)
                                    ),),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              ///standard and invoice row
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: MediaQuery.of(context).size.height/80,
                                    horizontal: MediaQuery.of(context).size.width/50
                                ),
                                child:  Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context).size.height/150
                                      ),
                                      child:  Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Invoice ID',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 0,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                SizedBox(width: MediaQuery.of(context).size.width/50,),
                                                Expanded(
                                                    flex: 5,
                                                    child: Text(invoicePopupData.first.invoiceId,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Mob',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),


                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 8,
                                                    child: Text(invoicePopupData.first.mobileNo,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              child: Row(

                                                children: [
                                                  Expanded(
                                                      flex:5,
                                                      child: Text('Date',style: TextStyle(
                                                          color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),
                                                        textAlign: TextAlign.end,
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(':',style: TextStyle(
                                                          color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),
                                                          textAlign: TextAlign.center
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(DateFormat('dd-MM-yyyy').format(DateTime.tryParse(invoicePopupData.first.date)!) ,style: TextStyle(
                                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(

                                          vertical: MediaQuery.of(context).size.height/150
                                      ),
                                      child:  Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Std',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 0,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                SizedBox(width: MediaQuery.of(context).size.width/50,),
                                                Expanded(
                                                    flex: 5,
                                                    child: Text(invoicePopupData.first.standard,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Div',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),


                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),)),
                                                Expanded(
                                                    flex: 8,
                                                    child: Text(invoicePopupData.first.division,style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(

                                              children: [
                                                Expanded(
                                                    flex:5,
                                                    child: Text('Order Value',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),
                                                      textAlign: TextAlign.end,
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(':',style: TextStyle(
                                                        color: const Color.fromRGBO(129, 129, 129, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),
                                                        textAlign: TextAlign.center
                                                    )),
                                                Expanded(
                                                    flex: 4,
                                                    child: Text('₹ ${invoicePopupData.first.orderValue.round()}',style: TextStyle(
                                                        color: const Color.fromRGBO(59, 59, 59, 1),
                                                        fontSize: MediaQuery.of(context).size.height/50
                                                    ),))
                                              ],
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              ///label for Rows
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50,
                                  vertical: MediaQuery.of(context).size.height/80,
                                ),
                                child: Row(

                                  children: [
                                    ///SrNo
                                    Expanded(
                                      flex:2,
                                      child: Text('Sr.No.',style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: MediaQuery.of(context).size.height/50,
                                          color: const Color(0xff3B3B3B)
                                      ),),
                                    ),
                                    ///Book Name
                                    Expanded(
                                      flex: 6,
                                      child: Text('Items',style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: MediaQuery.of(context).size.height/50,
                                          color: const Color(0xff3B3B3B)
                                      ),),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/150,),
                                    ///Publication
                                    Expanded(
                                      flex: 6,
                                      child: Text('Publication',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),

                                    ///Amount
                                    Expanded(
                                      flex: 2,
                                      child: Text('Amount',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),
                                    ///Quantity
                                    Expanded(
                                      flex: 0,
                                      child: Text('Quantity',style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.height/50,

                                      ),),
                                    ),
                                  ],

                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height/3.5,

                                decoration: const BoxDecoration(

                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: invoicePopupData[0].bookLlist.length,
                                  shrinkWrap: true,
                                  itemBuilder:(context, index) => Card(

                                    elevation: 0,
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width/50,
                                        vertical: MediaQuery.of(context).size.height/80,
                                      ),
                                      child: Row(

                                        children: [
                                          ///SrNo
                                          Expanded(
                                            flex:2,
                                            child: Text('${index + 1}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Book Name
                                          Expanded(
                                            flex: 7,
                                            child: Text(invoicePopupData[0].bookLlist[index].bookName,style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Publication
                                          Expanded(
                                            flex: 7,
                                            child: Text(invoicePopupData[0].bookLlist[index].publication,style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),

                                          ///Amount
                                          Expanded(
                                            flex: 2,
                                            child: Text('₹ ${invoicePopupData[0].bookLlist[index].amount.round()}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),),
                                          ),
                                          ///Quantity
                                          Expanded(
                                            flex: 1,
                                            child: Text('${invoicePopupData[0].bookLlist[index].qty}',style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context).size.height/50,
                                                color: const Color(0xff616161)
                                            ),
                                                textAlign: TextAlign.right
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ),

          ),

        );
      });
}