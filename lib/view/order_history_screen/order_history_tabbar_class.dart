
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tuck_shop/view/common_widgets/progress_indicator.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/profile_screen/profile_screen.dart';
import '../../modal/order_history_modal/get_order_history_modal.dart';
import '../../view_modal/order_history_view_modal/get_order_history_vm.dart';
import '../../view_modal/order_history_view_modal/invoice_popup_vm.dart';
import '../../view_modal/order_history_view_modal/mark_as_complete_vm.dart';
import '../../view_modal/pos_view_modal/cancelorder_vm.dart';
import 'order_history_alert_dialog.dart';
import 'order_history_screen.dart';

final cancelOrderVm = Get.put(CancelOrderVm());
final remarkController = TextEditingController();

class AllRecord extends StatefulWidget {

  AllRecord({super.key,required this.getOrderHistory});

  List<GetOrderHistoryModal> Function() getOrderHistory;

  @override
  State<AllRecord> createState() => AllRecordState();
}

class AllRecordState extends State<AllRecord> {
  final getOrderHistoryVm = Get.put(GetOrderHistoryVm());
  final invoicePopupVm = Get.put(InvoicePopupVm());

  ///pagination
  static int page = 1;
  /// There is next page or not
  static bool hasNextPage = true;
  /// Used to display loading indicators when _firstLoad function is running
  bool isFirstLoadRunning = false;
  /// Used to display loading indicators when _loadMore function is running
  bool isLoadMoreRunning = false;

  ///for refresh indicator
  void getAPIMethod()async {
    hasNextPage =true;
    page = 1;
    getOrderHistoryVm.orderHistoryListVm.clear();
    getOrderHistoryVm.isLoading.value = true;
    await getOrderHistoryVm.getOrderHistoryVm(
        page,orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');

    // await notificationFlagCountVm.putNotificationFlag(updateCountData[i].id!,updateCountData[i].userId!);

  }

  ///load more data
  void loadMore()async{
    if(hasNextPage == true && isFirstLoadRunning == false && isLoadMoreRunning == false && orderHistoryTotalPages! > 1 &&
        controller.position.extentAfter < 300){
      setState(() {
        isLoadMoreRunning = true;
      });
      page += 1;
      try{
        // getOrderHistoryVm.isLoading.value = true;
        if(selectSchoolId == null){
          await getOrderHistoryVm.getOrderHistoryVm(
              page,orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');
        }
        else{
          await getOrderHistoryVm.getOrderHistoryVm(
              page,
              orderHistorySearchCtx.text,
              0,
              timeId!,
              storedFromDate!,
              storedToDate!,
              selectSchoolId ?? 0,
              stdId ?? 0,
              divId ?? 0,
              orderIdController.text,
              invoiceIdController.text);
        }



        if(page == orderHistoryTotalPages!){
          setState(() {
            hasNextPage = false;
          });
        }

      }catch(err){
        if(kDebugMode){
          print('Something went wrong!');
        }
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  ///Load first method
  // void firstLoad()async{
  //   setState(() {
  //     isFirstLoadRunning = true;
  //   });
  //   try{
  //     Timer(const Duration(milliseconds: 800), () async {
  //       getOrderHistoryVm.orderHistoryListVm.clear();
  //       getOrderHistoryVm.isLoading.value = true;
  //       await getOrderHistoryVm.getOrderHistoryVm(
  //           page,0, 0, '', '', 0, 0, 0, '', '');
  //     });
  //
  //   }catch(err){
  //     if(kDebugMode){
  //       print('Something went wrong');
  //     }
  //   }
  //   setState(() {
  //     isFirstLoadRunning = false;
  //   });
  // }
  late ScrollController controller;



  /* Future<dynamic> cancelOrderDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(

          shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.01
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsPadding: EdgeInsets.only(
            top:MediaQuery.of(context).size.width * 0.02 ,
            bottom:MediaQuery.of(context).size.width * 0.03,
           left: MediaQuery.of(context).size.width * 0.02,
           right: MediaQuery.of(context).size.width * 0.02,
          ),
          title: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close,size: 25,)),
              ),
              const Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 35,
              )
            ],
          ),
          content:  Container(
            width: MediaQuery.of(context).size.width/2.6,
            height: MediaQuery.of(context).size.height/5.5,
            child:  SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Do you want to cancel the order?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'NotoSans',
                        fontSize: MediaQuery.of(context).size.height/32
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/50,
                      left: MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.06,

                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Remark",
                            style: TextStyle(
                              fontFamily: "NatoSans",
                              color: const Color(0xFF3B3B3B),
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 50),
                        Container(
                          height: MediaQuery.of(context).size.height / 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)

                          ),

                          child: TextFormField(
                            controller: remarkController,
                            cursorColor: Colors.black54,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left:MediaQuery.of(context).size.width/70 ,
                                    top: MediaQuery.of(context).size.height/90),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none),
                                hintText: "Enter Remark",
                                hintStyle: TextStyle(
                                    fontFamily: "NatoSans",
                                    fontSize: MediaQuery.of(context).size.height / 40)),
                          ),
                        ),
                      ],
                    ),
                  )

                ],

              ),
            ),
          ),
          actions: [
            Container(
              height: MediaQuery.of(context).size.height/16,
              width: MediaQuery.of(context).size.width/9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                    spreadRadius: 2, // Adjust the spread radius
                    blurRadius: 5, // Adjust the blur radius
                    offset: const Offset(0, 3), // Adjust the offset
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'No',
                  style: TextStyle(fontFamily: 'NotoSans'),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/16,
              width: MediaQuery.of(context).size.width/9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                    spreadRadius: 2, // Adjust the spread radius
                    blurRadius: 5, // Adjust the blur radius
                    offset: const Offset(0, 3), // Adjust the offset
                  ),
                ],
                color: const Color(0xFF7367F0),
              ),
              child: TextButton(
                onPressed: ()  {


                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ],
        ));
  }*/

  ///cancel order Dialogue
  Future<void> cancelOrderDialog2(BuildContext context,String orderId,int indexValue) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,

          content: SizedBox(
            width: MediaQuery.of(context).size.width/2.6,
            height: MediaQuery.of(context).size.height /2.5,
            child: ListView(
              children: [
                Container(
                  color: const Color(0xFFE7E5FF),
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/50.50,
                            vertical: MediaQuery.of(context).size.height /60
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Do you want to cancel the order ?',
                              style: TextStyle(
                                  fontFamily: "NotoSans",
                                  color: const Color(0xFF5448D2),
                                  fontSize: MediaQuery.of(context).size.height /33,
                                  fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child: const Icon(Icons.cancel_outlined,color: Colors.redAccent,))
                          ],
                        ),
                      ),

                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Text(
                    "Remark",
                    style: TextStyle(
                      fontFamily: "NatoSans",
                      color: const Color(0xFF3B3B3B),
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)

                    ),

                    child: TextFormField(
                      controller: remarkController,
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left:MediaQuery.of(context).size.width/70 ,
                              top: MediaQuery.of(context).size.height/90),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none),
                          hintText: "Enter Remark",
                          hintStyle: TextStyle(
                              fontFamily: "NatoSans",
                              fontSize: MediaQuery.of(context).size.height / 40)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                    spreadRadius: 2, // Adjust the spread radius
                                    blurRadius: 5, // Adjust the blur radius
                                    offset: const Offset(0, 3), // Adjust the offset
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height /40,
                                  fontFamily: "NotoSans",
                                  color:  Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 50),
                      GestureDetector(
                        onTap: () async {
                          if(remarkController.text.isEmpty){
                            snackbar(context, "Please enter remark !");
                          }
                          else{
                            await cancelOrderVm.cancelOrderVmFunction(orderId, remarkController.text);
                            if(cancelOrderVm.statusCode == 200){
                              remarkController.clear();
                              setState(() {
                                widget.getOrderHistory()[indexValue].status = 'Cancelled';
                              });
                              Get.back();
                              toastMessage(context,cancelOrderVm.statusMessage!);
                            }
                            else{
                              toastMessage(context,cancelOrderVm.statusMessage!);
                            }
                          }

                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7367F0),

                              ///yes
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                  spreadRadius: 2, // Adjust the spread radius
                                  blurRadius: 5, // Adjust the blur radius
                                  offset: const Offset(0, 3), // Adjust the offset
                                ),
                              ],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height /40,
                                  fontFamily: "NotoSans",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    /* getOrderHistoryVm.isLoading.value = true;
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.invoiceListVm.clear();
      invoicePopupVm.invoiceDataListVm.clear();
      await  getOrderHistoryVm.getOrderHistoryVm(
          0, 0, '', '', 0, 0, 0, '', '');*/
    // firstLoad();
    controller = ScrollController()..addListener(loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      markAsCompleteVm.isLoading.value = false;
      invoicePopupVm.isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:  EdgeInsets.only(
          left:MediaQuery.of(context).size.width/80,
          right: MediaQuery.of(context).size.width/80,
        ),
        child: Obx(
              () => ModalProgressHUD(
            color: Colors.transparent,
            inAsyncCall: getOrderHistoryVm.isLoading.value == true,
            progressIndicator: progressIndicator(),
            child: getOrderHistoryVm.orderHistoryListVm.isEmpty && getOrderHistoryVm.isLoading.value == false ?const Center(child: Text('No Data found!'),): Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    controller: controller,
                    padding: EdgeInsets.only(
                      top:MediaQuery.of(context).size.height/80,
                      bottom:MediaQuery.of(context).size.height/35,
                    ),
                    itemCount: widget.getOrderHistory().length,
                    itemBuilder: (context, index) => Padding(
                      padding:  EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height/80,
                      ),
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        height:widget.getOrderHistory()[index].invoiceList.length == 2? MediaQuery.of(context).size.height/4.2:MediaQuery.of(context).size.height/5.5,
                        width: double.infinity,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: Color.fromRGBO(224, 221, 252, 1),
                                  width: 1
                              )
                          ),
                          elevation: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(
                                  top:MediaQuery.of(context).size.height/80,
                                  left: MediaQuery.of(context).size.width/80,
                                  right: MediaQuery.of(context).size.width/80,

                                ),
                                child: Row(
                                  children: [
                                    ///Student name
                                    Expanded(
                                      flex:6,
                                      child: Text(widget.getOrderHistory()[index].studentName.isEmpty?"":widget.getOrderHistory()[index].studentName,style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                          fontSize: MediaQuery.of(context).size.height/50
                                      ),),
                                    ),
                                    ///School name
                                    Expanded(
                                      flex:7,
                                      child: Text(widget.getOrderHistory()[index].schoolName.isEmpty?"":widget.getOrderHistory()[index].schoolName,style:
                                      TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                          fontSize: MediaQuery.of(context).size.height/50
                                      ),),
                                    ),
                                    Text(widget.getOrderHistory()[index].status.isEmpty?"":widget.getOrderHistory()[index].status,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.bold,
                                        color: widget.getOrderHistory()[index].status == 'Completed'?const Color.fromRGBO(18, 100, 23, 1):const Color(0xffBE5151),
                                        fontSize: MediaQuery.of(context).size.height/50
                                    ),),
                                    widget.getOrderHistory()[index].status == 'Completed'?SizedBox(width: MediaQuery.of(context).size.width/35,):widget.getOrderHistory()[index].status == 'Pending'?SizedBox(width: MediaQuery.of(context).size.width/24):SizedBox(width: MediaQuery.of(context).size.width/18),
                                    widget.getOrderHistory()[index].status != 'Cancelled'?InkWell(
                                        onTap: () {
                                          cancelOrderDialog2(context,widget.getOrderHistory()[index].orderId.toString(),index);
                                          print('Hello');
                                        },
                                        radius: 60,
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor: Colors.red.shade700,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 10,
                                            child: Icon(Icons.delete,color: Colors.redAccent,size: MediaQuery.of(context).size.height/30,))):const SizedBox.shrink()
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              ///STD ROW
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width/80,
                                    right: MediaQuery.of(context).size.width/80,
                                    bottom: MediaQuery.of(context).size.height/120

                                ),
                                child:  Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex:2,
                                              child: Text('Standard',style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              flex: 8,
                                              child: Text(widget.getOrderHistory()[index].standard.isEmpty?"":widget.getOrderHistory()[index].standard,style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              child: Text('Division',style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              flex: 5,
                                              child: Text(widget.getOrderHistory()[index].division.isEmpty?"":widget.getOrderHistory()[index].division,style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                                child: Text('Order Value',style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                                                child: Text(widget.getOrderHistory()[index].orderValue.round().toString().isEmpty?"":widget.getOrderHistory()[index].orderValue.round().toString(),style: TextStyle(
                                                    fontFamily: 'NotoSans',
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

                              ///invoice row
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.getOrderHistory()[index].invoiceList.length,
                                itemBuilder: (context, i) =>Column(
                                  children: [

                                    Padding(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width/80,
                                        vertical: MediaQuery.of(context).size.height/85,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Invoice ID',style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                    flex: 8,
                                                    child: Text(widget.getOrderHistory()[index].invoiceList[i].invoiceId.isEmpty ? "":widget.getOrderHistory()[index].invoiceList[i].invoiceId,style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                    flex:3,
                                                    child: Text('Mobile No',style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                    child: Text(widget.getOrderHistory()[index].mobileNo.isEmpty?"":widget.getOrderHistory()[index].mobileNo,style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                          fontFamily: 'NotoSans',
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
                                                      child: Text(
                                                        DateFormat('dd-MM-yyyy').format(widget.getOrderHistory()[index].invoiceList[i].date).isEmpty?"":
                                                        DateFormat('dd-MM-yyyy').format(widget.getOrderHistory()[index].invoiceList[i].date)
                                                        ,style: TextStyle(
                                                          fontFamily: 'NotoSans',
                                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),)),
                                                  InkWell(
                                                    onTap: () async{
                                                      await invoicePopupVm.getInvoicePopupDataVm(widget.getOrderHistory()[index].invoiceList[i].id);
                                                      if(invoicePopupVm.invoiceDataListVm.isNotEmpty && widget.getOrderHistory()[index].status == 'Completed'){
                                                        if(!mounted) return;
                                                        showCompletedDialog(
                                                          context,
                                                          invoicePopupVm.invoiceDataListVm,
                                                          widget.getOrderHistory()[index].studentName,
                                                          widget.getOrderHistory()[index].schoolName,
                                                          widget.getOrderHistory()[index].status,
                                                          widget.getOrderHistory()[index].invoiceList[i].id,
                                                        );

                                                      }
                                                      else if(invoicePopupVm.invoiceDataListVm.isNotEmpty && widget.getOrderHistory()[index].status == 'Pending'){
                                                        if(!mounted) return;
                                                        showPendingDialog(
                                                            context,
                                                            invoicePopupVm.invoiceDataListVm,
                                                            widget.getOrderHistory()[index].studentName,
                                                            widget.getOrderHistory()[index].schoolName,
                                                            widget.getOrderHistory()[index].status,
                                                            0,
                                                            (widget.getOrderHistory()[index].invoiceList[i].id).toString()
                                                        );

                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:  EdgeInsets.only(right:
                                                      MediaQuery.of(context).size.width/80
                                                      ),
                                                      child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: CircleAvatar(
                                                              radius: 8,
                                                              backgroundColor: Colors.transparent,
                                                              child: SvgPicture.asset('assets/images/order_history_images/Group 20111.svg',height: 8,))
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],

                                      ),
                                    ),
                                    i == 0 && widget.getOrderHistory()[index].invoiceList.length == 2? const Padding(
                                      padding: EdgeInsets.only(

                                      ),
                                      child: Divider(
                                        height: 0,
                                        thickness: 1,
                                      ),
                                    ):const SizedBox.shrink()
                                  ],
                                ),
                              ),
                              ///Row2






                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoadMoreRunning == true)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                      width:MediaQuery.of(context).size.width/40,
                      child: const CircularProgressIndicator(color: Color(0xff7367F0),strokeWidth:3,
                      ),
                    ),
                  ))
              ],

            ),
          ),
        )
    );
  }
}

class CompletedRecord extends StatefulWidget {

  CompletedRecord({super.key,required this.getOrderHistory});
  List<GetOrderHistoryModal> Function() getOrderHistory;
  @override
  State<CompletedRecord> createState() => CompletedRecordState();
}

class CompletedRecordState extends State<CompletedRecord> {
  final getOrderHistoryVm = Get.put(GetOrderHistoryVm());
  final invoicePopupVm = Get.put(InvoicePopupVm());

  ///pagination
  static int page = 1;
  /// There is next page or not
  static bool hasNextPage = true;
  /// Used to display loading indicators when _firstLoad function is running
  bool isFirstLoadRunning = false;
  /// Used to display loading indicators when _loadMore function is running
  bool isLoadMoreRunning = false;

  ///cancel order Dialogue
  Future<void> cancelOrderDialog2(BuildContext context,String orderId,int indexValue) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,

          content: SizedBox(
            width: MediaQuery.of(context).size.width/2.6,
            height: MediaQuery.of(context).size.height /2.5,
            child: ListView(
              children: [
                Container(
                  color: const Color(0xFFE7E5FF),
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/50.50,
                            vertical: MediaQuery.of(context).size.height /60
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Do you want to cancel the order ?',
                              style: TextStyle(
                                  fontFamily: "NotoSans",
                                  color: const Color(0xFF5448D2),
                                  fontSize: MediaQuery.of(context).size.height /33,
                                  fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child: const Icon(Icons.cancel_outlined,color: Colors.redAccent,))
                          ],
                        ),
                      ),

                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Text(
                    "Remark",
                    style: TextStyle(
                      fontFamily: "NatoSans",
                      color: const Color(0xFF3B3B3B),
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)

                    ),

                    child: TextFormField(
                      controller: remarkController,
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left:MediaQuery.of(context).size.width/70 ,
                              top: MediaQuery.of(context).size.height/90),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none),
                          hintText: "Enter Remark",
                          hintStyle: TextStyle(
                              fontFamily: "NatoSans",
                              fontSize: MediaQuery.of(context).size.height / 40)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                    spreadRadius: 2, // Adjust the spread radius
                                    blurRadius: 5, // Adjust the blur radius
                                    offset: const Offset(0, 3), // Adjust the offset
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height /40,
                                  fontFamily: "NotoSans",
                                  color:  Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 50),
                      GestureDetector(
                        onTap: () async {
                          if(remarkController.text.isEmpty){
                            snackbar(context, "Please enter remark !");
                          }
                          else{
                            await cancelOrderVm.cancelOrderVmFunction(orderId, remarkController.text);
                            if(cancelOrderVm.statusCode == 200){
                              remarkController.clear();
                              setState(() {
                                widget.getOrderHistory().removeAt(indexValue);
                              });
                              Get.back();
                              toastMessage(context,cancelOrderVm.statusMessage!);
                            }
                            else{
                              toastMessage(context,cancelOrderVm.statusMessage!);
                            }
                          }

                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7367F0),

                              ///yes
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                  spreadRadius: 2, // Adjust the spread radius
                                  blurRadius: 5, // Adjust the blur radius
                                  offset: const Offset(0, 3), // Adjust the offset
                                ),
                              ],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height /40,
                                  fontFamily: "NotoSans",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///for refresh indicator
  void getAPIMethod()async {
    hasNextPage =true;
    page = 1;
    getOrderHistoryVm.orderHistoryListVm.clear();
    getOrderHistoryVm.isLoading.value = true;
    await getOrderHistoryVm.getOrderHistoryVm(
        page,orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');

    // await notificationFlagCountVm.putNotificationFlag(updateCountData[i].id!,updateCountData[i].userId!);

  }

  ///load more data
  void loadMore()async{
    if(hasNextPage == true && isFirstLoadRunning == false && isLoadMoreRunning == false && orderHistoryTotalPages! > 1  &&
        controller.position.extentAfter < 300){
      setState(() {
        isLoadMoreRunning = true;
      });
      page += 1;

      try{
        // getOrderHistoryVm.isLoading.value = true;
        if(selectSchoolId == null){
          await getOrderHistoryVm.getOrderHistoryVm(
              page,orderHistorySearchCtx.text, 2, 0, '', '', 0, 0, 0, '', '');
        }
        else{
          await getOrderHistoryVm.getOrderHistoryVm(
              page,
              orderHistorySearchCtx.text,
              2,
              timeId!,
              storedFromDate!,
              storedToDate!,
              selectSchoolId ?? 0,
              stdId ?? 0,
              divId ?? 0,
              orderIdController.text,
              invoiceIdController.text);
        }


        if(page == orderHistoryTotalPages!){
          setState(() {
            hasNextPage = false;
          });
        }

      }catch(err){
        if(kDebugMode){
          print('Something went wrong!');
        }
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  ///Load first method
  // void firstLoad()async{
  //   setState(() {
  //     isFirstLoadRunning = true;
  //   });
  //   try{
  //     Timer(const Duration(milliseconds: 800), () async {
  //       getOrderHistoryVm.orderHistoryListVm.clear();
  //       getOrderHistoryVm.isLoading.value = true;
  //       await getOrderHistoryVm.getOrderHistoryVm(
  //           page,0, 0, '', '', 0, 0, 0, '', '');
  //     });
  //
  //   }catch(err){
  //     if(kDebugMode){
  //       print('Something went wrong');
  //     }
  //   }
  //   setState(() {
  //     isFirstLoadRunning = false;
  //   });
  // }
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      invoicePopupVm.isLoading.value = false;
      /* getOrderHistoryVm.isLoading.value = true;
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.invoiceListVm.clear();
      invoicePopupVm.invoiceDataListVm.clear();
      await getOrderHistoryVm.getOrderHistoryVm(
          2, 0, '', '', 0, 0, 0, '', '');*/
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:  EdgeInsets.only(
          left:MediaQuery.of(context).size.width/80,
          right: MediaQuery.of(context).size.width/80,
        ),
        child: Obx(
              () => ModalProgressHUD(
            inAsyncCall: getOrderHistoryVm.isLoading.value == true || invoicePopupVm.isLoading.value == true,
            progressIndicator: progressIndicator(),
            color: Colors.transparent,
            child: getOrderHistoryVm.orderHistoryListVm.isEmpty && getOrderHistoryVm.isLoading.value == false ?const Center(child: Text('No Data found!'),): Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    controller: controller,
                    padding: EdgeInsets.only(
                      top:MediaQuery.of(context).size.height/80,
                      bottom:MediaQuery.of(context).size.height/35,
                    ),
                    itemCount: widget.getOrderHistory().length,
                    itemBuilder: (context, index) => Padding(
                      padding:  EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height/80,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        height:widget.getOrderHistory()[index].invoiceList.length == 2? MediaQuery.of(context).size.height/4.2:MediaQuery.of(context).size.height/5.4,
                        width: double.infinity,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: Color.fromRGBO(224, 221, 252, 1),
                                  width: 1
                              )
                          ),
                          elevation: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(
                                  top:MediaQuery.of(context).size.height/80,
                                  left: MediaQuery.of(context).size.width/80,
                                  right: MediaQuery.of(context).size.width/80,

                                ),
                                child: Row(

                                  children: [
                                    ///Student name
                                    Expanded(
                                      flex:6,
                                      child: Text(widget.getOrderHistory()[index].studentName,style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                          fontSize: MediaQuery.of(context).size.height/50
                                      ),),
                                    ),
                                    ///School Name
                                    Expanded(
                                        flex: 7,
                                        child: Text(widget.getOrderHistory()[index].schoolName,style:
                                        TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromRGBO(59, 59, 59, 1),
                                            fontSize: MediaQuery.of(context).size.height/50
                                        ),)),
                                    ///Status
                                    Text(widget.getOrderHistory()[index].status,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromRGBO(18, 100, 23, 1),
                                        fontSize: MediaQuery.of(context).size.height/50
                                    ),),
                                    widget.getOrderHistory()[index].status == 'Completed'?SizedBox(width: MediaQuery.of(context).size.width/35,):widget.getOrderHistory()[index].status == 'Pending'?SizedBox(width: MediaQuery.of(context).size.width/24):SizedBox(width: MediaQuery.of(context).size.width/18),
                                    widget.getOrderHistory()[index].status != 'Cancelled'?InkWell(
                                        onTap: () {
                                          cancelOrderDialog2(context,widget.getOrderHistory()[index].orderId.toString(),index);
                                          print('Hello');
                                        },
                                        radius: 60,
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor: Colors.red.shade700,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 10,
                                            child: Icon(Icons.delete,color: Colors.redAccent,size: MediaQuery.of(context).size.height/30,))):const SizedBox.shrink()
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),
                              ///STD ROW
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width/80,
                                    right: MediaQuery.of(context).size.width/80,
                                    bottom: MediaQuery.of(context).size.height/120

                                ),
                                child:  Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex:2,
                                              child: Text('Standard',style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              flex: 8,
                                              child: Text(widget.getOrderHistory()[index].standard,style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              child: Text('Division',style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              flex: 5,
                                              child: Text(widget.getOrderHistory()[index].division,style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                                child: Text('Order Value',style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                                                child: Text(widget.getOrderHistory()[index].orderValue.round().toString(),style: TextStyle(
                                                    fontFamily: 'NotoSans',
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

                              ///invoice row
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.getOrderHistory()[index].invoiceList.length,
                                itemBuilder: (context, i) =>Column(
                                  children: [

                                    Padding(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width/80,
                                        vertical: MediaQuery.of(context).size.height/85,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Text('Invoice ID',style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                    flex: 8,
                                                    child: Text(widget.getOrderHistory()[index].invoiceList[i].invoiceId,style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                    flex:3,
                                                    child: Text('Mobile No',style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                    child: Text(widget.getOrderHistory()[index].mobileNo,style: TextStyle(
                                                        fontFamily: 'NotoSans',
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
                                                          fontFamily: 'NotoSans',
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
                                                      child: Text(
                                                        DateFormat('dd-MM-yyyy').format(widget.getOrderHistory()[index].invoiceList[i].date)
                                                        ,style: TextStyle(
                                                          fontFamily: 'NotoSans',
                                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/50
                                                      ),)),
                                                  InkWell(
                                                      onTap: () async {
                                                        await invoicePopupVm.getInvoicePopupDataVm(widget.getOrderHistory()[index].invoiceList[i].id);
                                                        if(invoicePopupVm.invoiceDataListVm.isNotEmpty){
                                                          if(!mounted) return;
                                                          showCompletedDialog(
                                                              context,
                                                              invoicePopupVm.invoiceDataListVm,
                                                              widget.getOrderHistory()[index].studentName,
                                                              widget.getOrderHistory()[index].schoolName,
                                                              widget.getOrderHistory()[index].status,
                                                              widget.getOrderHistory()[index].invoiceList[i].id
                                                          );
                                                        }


                                                      },
                                                      child: Padding(
                                                        padding:  EdgeInsets.only(right:
                                                        MediaQuery.of(context).size.width/80
                                                        ),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: CircleAvatar(
                                                              radius: MediaQuery.of(context).size.height/70,
                                                              backgroundColor: Colors.transparent,
                                                              child: SvgPicture.asset('assets/images/order_history_images/Group 20111.svg',height: 8,)),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],

                                      ),
                                    ),
                                    i == 0 && widget.getOrderHistory()[index].invoiceList.length == 2? const Padding(
                                      padding: EdgeInsets.only(

                                      ),
                                      child: Divider(
                                        height: 0,
                                        thickness: 1,
                                      ),
                                    ):const SizedBox.shrink()
                                  ],
                                ),
                              ),
                              ///Row2




                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoadMoreRunning == true)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                      width:MediaQuery.of(context).size.width/40,
                      child: const CircularProgressIndicator(color: Color(0xff7367F0),strokeWidth:3,
                      ),
                    ),
                  ))
              ],

            ),
          ),

        )
    );
  }
}

class PendingRecord extends StatefulWidget {
  PendingRecord({super.key, required this.getOrderHistory});
  List<GetOrderHistoryModal> Function() getOrderHistory;
  @override
  State<PendingRecord> createState() => PendingRecordState();
}

class PendingRecordState extends State<PendingRecord> {

  final getOrderHistoryVm = Get.put(GetOrderHistoryVm());
  final invoicePopupVm = Get.put(InvoicePopupVm());
  final markAsCompleteVm = Get.put(MarkAsCompleteVm());

  ///pagination
  static int page = 1;
  /// There is next page or not
  static bool hasNextPage = true;
  /// Used to display loading indicators when _firstLoad function is running
  bool isFirstLoadRunning = false;
  /// Used to display loading indicators when _loadMore function is running
  bool isLoadMoreRunning = false;

  ///cancel order Dialogue
  Future<void> cancelOrderDialog2(BuildContext context,String orderId,int indexValue) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,

          content: SizedBox(
            width: MediaQuery.of(context).size.width/2.6,
            height: MediaQuery.of(context).size.height /2.5,
            child: ListView(
              children: [
                Container(
                  color: const Color(0xFFE7E5FF),
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/50.50,
                            vertical: MediaQuery.of(context).size.height /60
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Do you want to cancel the order ?',
                              style: TextStyle(
                                  fontFamily: "NotoSans",
                                  color: const Color(0xFF5448D2),
                                  fontSize: MediaQuery.of(context).size.height /33,
                                  fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child: const Icon(Icons.cancel_outlined,color: Colors.redAccent,))
                          ],
                        ),
                      ),

                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Text(
                    "Remark",
                    style: TextStyle(
                      fontFamily: "NatoSans",
                      color: const Color(0xFF3B3B3B),
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)

                    ),

                    child: TextFormField(
                      controller: remarkController,
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left:MediaQuery.of(context).size.width/70 ,
                              top: MediaQuery.of(context).size.height/90),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none),
                          hintText: "Enter Remark",
                          hintStyle: TextStyle(
                              fontFamily: "NatoSans",
                              fontSize: MediaQuery.of(context).size.height / 40)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                    spreadRadius: 2, // Adjust the spread radius
                                    blurRadius: 5, // Adjust the blur radius
                                    offset: const Offset(0, 3), // Adjust the offset
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height /40,
                                  fontFamily: "NotoSans",
                                  color:  Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 50),
                      GestureDetector(
                        onTap: () async {
                          if(remarkController.text.isEmpty){
                            snackbar(context, "Please enter remark !");
                          }
                          else{
                            await cancelOrderVm.cancelOrderVmFunction(orderId, remarkController.text);
                            if(cancelOrderVm.statusCode == 200){
                              remarkController.clear();
                              setState(() {
                                widget.getOrderHistory().removeAt(indexValue);
                              });
                              Get.back();
                              toastMessage(context,cancelOrderVm.statusMessage!);
                            }
                            else{
                              toastMessage(context,cancelOrderVm.statusMessage!);
                            }
                          }

                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7367F0),

                              ///yes
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                  spreadRadius: 2, // Adjust the spread radius
                                  blurRadius: 5, // Adjust the blur radius
                                  offset: const Offset(0, 3), // Adjust the offset
                                ),
                              ],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height /40,
                                  fontFamily: "NotoSans",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///for refresh indicator
  void getAPIMethod()async {
    hasNextPage =true;
    page = 1;
    getOrderHistoryVm.orderHistoryListVm.clear();
    getOrderHistoryVm.isLoading.value = true;
    await getOrderHistoryVm.getOrderHistoryVm(
        page,orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');

    // await notificationFlagCountVm.putNotificationFlag(updateCountData[i].id!,updateCountData[i].userId!);

  }

  ///load more data
  void loadMore()async{
    if(hasNextPage == true && isFirstLoadRunning == false && isLoadMoreRunning == false && orderHistoryTotalPages! > 1 &&
        controller.position.extentAfter < 300){
      setState(() {
        isLoadMoreRunning = true;
      });
      page += 1;

      try{


        // getOrderHistoryVm.isLoading.value = true;
        if(selectSchoolId == null){
          await getOrderHistoryVm.getOrderHistoryVm(
              page,orderHistorySearchCtx.text,1, 0, '', '', 0, 0, 0, '', '');
        }
        else{
          await getOrderHistoryVm.getOrderHistoryVm(
              page,
              orderHistorySearchCtx.text,
              1,
              timeId!,
              storedFromDate!,
              storedToDate!,
              selectSchoolId ?? 0,
              stdId ?? 0,
              divId ?? 0,
              orderIdController.text,
              invoiceIdController.text);
        }


        if(page == orderHistoryTotalPages! ){
          setState(() {
            hasNextPage = false;
          });
        }

      }catch(err){
        if(kDebugMode){
          print('Something went wrong!');
        }
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  ///Load first method
  // void firstLoad()async{
  //   setState(() {
  //     isFirstLoadRunning = true;
  //   });
  //   try{
  //     Timer(const Duration(milliseconds: 800), () async {
  //       getOrderHistoryVm.orderHistoryListVm.clear();
  //       getOrderHistoryVm.isLoading.value = true;
  //       await getOrderHistoryVm.getOrderHistoryVm(
  //           page,0, 0, '', '', 0, 0, 0, '', '');
  //     });
  //
  //   }catch(err){
  //     if(kDebugMode){
  //       print('Something went wrong');
  //     }
  //   }
  //   setState(() {
  //     isFirstLoadRunning = false;
  //   });
  // }
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(loadMore);

    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      /* getOrderHistoryVm.isLoading.value = true;
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.invoiceListVm.clear();
      invoicePopupVm.invoiceDataListVm.clear();
      await getOrderHistoryVm.getOrderHistoryVm(
          1, 0, '', '', 0, 0, 0, '', '');*/
    });

  }


  @override
  Widget build(BuildContext context) {

    return  Padding(
        padding:  EdgeInsets.only(
          left:MediaQuery.of(context).size.width/80,
          right: MediaQuery.of(context).size.width/80,
        ),
        child:Obx(
              () => ModalProgressHUD(
            inAsyncCall: getOrderHistoryVm.isLoading.value == true,
            progressIndicator: progressIndicator(),
            color: Colors.transparent,
            child:getOrderHistoryVm.orderHistoryListVm.isEmpty && getOrderHistoryVm.isLoading.value == false ?const Center(child: Text('No Data found!'),): Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top:MediaQuery.of(context).size.height/80,
                      bottom:MediaQuery.of(context).size.height/35,
                    ),
                    itemCount: widget.getOrderHistory().length,
                    itemBuilder: (context, index) => Padding(
                      padding:  EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height/80,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        height: MediaQuery.of(context).size.height/5.5,
                        width: double.infinity,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: Color.fromRGBO(224, 221, 252, 1),
                                  width: 1
                              )
                          ),
                          elevation: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(
                                  top:MediaQuery.of(context).size.height/80,
                                  left: MediaQuery.of(context).size.width/80,
                                  right: MediaQuery.of(context).size.width/80,

                                ),
                                child: Row(
                                  children: [
                                    ///student name
                                    Expanded(
                                      flex:6,
                                      child: Text(widget.getOrderHistory()[index].studentName,style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                          fontSize: MediaQuery.of(context).size.height/50
                                      ),),
                                    ),
                                    ///school name
                                    Expanded(
                                      flex:7,
                                      child: Text(widget.getOrderHistory()[index].schoolName,style:
                                      TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(59, 59, 59, 1),
                                          fontSize: MediaQuery.of(context).size.height/50
                                      ),),
                                    ),
                                    ///status
                                    Text(widget.getOrderHistory()[index].status,style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xffBE5151),
                                        fontSize: MediaQuery.of(context).size.height/50
                                    ),),
                                    widget.getOrderHistory()[index].status == 'Completed'?SizedBox(width: MediaQuery.of(context).size.width/35,):widget.getOrderHistory()[index].status == 'Pending'?SizedBox(width: MediaQuery.of(context).size.width/24):SizedBox(width: MediaQuery.of(context).size.width/18),
                                    widget.getOrderHistory()[index].status != 'Cancelled'?InkWell(
                                        onTap: () {
                                          cancelOrderDialog2(context,widget.getOrderHistory()[index].orderId.toString(),index);
                                          print('Hello');
                                        },
                                        radius: 60,
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor: Colors.red.shade700,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 10,
                                            child: Icon(Icons.delete,color: Colors.redAccent,size: MediaQuery.of(context).size.height/30,))):const SizedBox.shrink()
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness:1,
                                color: Color.fromRGBO(224, 221, 252, 1),
                              ),

                              ///Row2
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width/80,
                                    right: MediaQuery.of(context).size.width/80,
                                    bottom:MediaQuery.of(context).size.height/80
                                ),
                                child:  Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex:2,
                                              child: Text('Standard',style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              flex: 8,
                                              child: Text(widget.getOrderHistory()[index].standard,style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              child: Text('Division',style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                              flex: 5,
                                              child: Text(widget.getOrderHistory()[index].division,style: TextStyle(
                                                  fontFamily: 'NotoSans',
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
                                                child: Text('Order Value',style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                                                child: Text(widget.getOrderHistory()[index].orderValue.round().toString(),style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                              ///invoice row
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.getOrderHistory()[index].invoiceList.length,
                                itemBuilder: (context, i) =>Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width/80,

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
                                                    fontFamily: 'NotoSans',
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
                                                flex: 8,
                                                child: Text(widget.getOrderHistory()[index].invoiceList[i].invoiceId,style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                                                flex:3,
                                                child: Text('Mobile No',style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                                                child: Text(widget.getOrderHistory()[index].mobileNo,style: TextStyle(
                                                    fontFamily: 'NotoSans',
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
                                                      fontFamily: 'NotoSans',
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
                                                  child: Text(
                                                    DateFormat('dd-MM-yyyy').format(widget.getOrderHistory()[index].invoiceList[i].date)
                                                    ,style: TextStyle(
                                                      fontFamily: 'NotoSans',
                                                      color: const Color.fromRGBO(59, 59, 59, 1),
                                                      fontSize: MediaQuery.of(context).size.height/50
                                                  ),)),
                                              InkWell(
                                                onTap: () async {
                                                  await invoicePopupVm.getInvoicePopupDataVm(widget.getOrderHistory()[index].invoiceList[i].id);
                                                  if(invoicePopupVm.invoiceDataListVm.isNotEmpty){
                                                    markAsCompleteVm.isLoading.value = false;
                                                    if(!mounted) return;
                                                    showPendingDialog(
                                                        context,
                                                        invoicePopupVm.invoiceDataListVm,
                                                        widget.getOrderHistory()[index].studentName,
                                                        widget.getOrderHistory()[index].schoolName,
                                                        widget.getOrderHistory()[index].status,
                                                        1,
                                                        (widget.getOrderHistory()[index].invoiceList[i].id).toString()
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:  EdgeInsets.only(right:
                                                  MediaQuery.of(context).size.width/80
                                                  ),
                                                  child:  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: CircleAvatar(
                                                          radius: 8,
                                                          backgroundColor: Colors.transparent,
                                                          child: SvgPicture.asset('assets/images/order_history_images/Group 20111.svg',height: 8,))
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],

                                  ),
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoadMoreRunning == true)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                      width:MediaQuery.of(context).size.width/40,
                      child: const CircularProgressIndicator(color: Color(0xff7367F0),strokeWidth:3,
                      ),
                    ),
                  ))
              ],
            ),
          ),

        )
    );
  }
}