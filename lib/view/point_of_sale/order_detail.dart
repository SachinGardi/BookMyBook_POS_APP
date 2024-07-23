import'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/point_of_sale/payment.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import 'package:tuck_shop/view/point_of_sale/pos_widgets.dart';
import '../../modal/pos_modal/paymentdetailpost_modal.dart';
import '../../repository/pos_repository/paymentdetailpost_repo.dart';
import '../../view_modal/pos_view_modal/addcustomer_vm.dart';
import '../../view_modal/pos_view_modal/counter_vm.dart';
import '../../view_modal/pos_view_modal/customerdetail_vm.dart';
import '../common_widgets/progress_indicator.dart';
import '../common_widgets/snack_bar.dart';
import 'add_customer.dart';
import 'calculator_screen.dart';
import 'edit_customer.dart';
var totalItemsPrice = 0.0.obs;
var taxAmount = 0.0.obs;
var payableTotal = 0.0.obs;
var discountStatus = false.obs;
var viewBreakup = false.obs;
Map<double, Map<String, double>> groupedTaxData = {};
var posPaymentLoader = false.obs;


double total = 0.0;
var totalPayableTax = 0.0.obs;

///Add Customer Api Integration
customerDetailApi()async{
  updateParentName = "";
  updateMobileNumber= "";
  updateStudentName= "";
  updateStandard= "";
  updateDiv= "";
  updateDivId= "";
  customerDetailVM.customerDetailList.clear();
  customerDetailVM.isLoading.value = true;
  await customerDetailVM.getCustomerInfo(posCustId.value);
  initialCustomerData();
}
List<BookDetail> bookDetailList = [];

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final CounterController countController = Get.find<CounterController>();


  ///Division Api Integration
  divApiCalling() async{
    divisionVM.divisionList.clear();
    divisionVM.isLoading.value = true;
    await divisionVM.getDivisionInfo();
  }


  Future<void> paymentConfirmationPopUp(BuildContext context) async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SizedBox(
                height: MediaQuery.of(context).size.height /6,
                child: AlertDialog(

                  contentPadding: const EdgeInsets.only(bottom: 2),
                  titlePadding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 40,
                    left: MediaQuery.of(context).size.width / 40,
                    bottom: MediaQuery.of(context).size.height /30,
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height /3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: const Color(0xFFE7E5FF),
                          child: Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width/51,
                                    vertical: MediaQuery.of(context).size.height /60
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      ' Order Confirmation',
                                      style: TextStyle(
                                          fontFamily: "NotoSans",
                                          color: const Color(0xFF5448D2),
                                          fontSize: MediaQuery.of(context).size.height /34,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),

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
                        Text(
                          'Are you sure to confirm this order ?',
                          style: TextStyle(
                              fontFamily: "NotoSans",
                              color:  Colors.black,
                              fontSize: MediaQuery.of(context).size.height /35,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Center(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height /15,
                                      width: MediaQuery.of(context).size.width /8,
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
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context).size.height /45,
                                                fontFamily: "NotoSans",
                                                color: Colors.black),
                                          )),
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/50,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  Future.delayed(Duration.zero,(){
                                    postPaymentData();
                                  });

                                },
                                child: Center(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height /15,
                                      width: MediaQuery.of(context).size.width /8,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF7367F0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(
                                            "Proceed",
                                            style: TextStyle(
                                                fontSize:
                                                MediaQuery.of(context).size.height / 50,
                                                fontFamily: "OpenSans",
                                                color: Colors.white),
                                          ))))),

                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height /55),
                      ],
                    ),
                  ),
                ),
              );});
  }



 /// Post all details of student  upto payment
  postPaymentData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final CounterController controller = Get.put(CounterController());
    posPaymentLoader.value = true;
    bookDetailList.clear();
    posOrderId = 0;
    paymentType.value = "";
    isChecked.value = false;
    remarkController.clear();

    for(int i =0 ;i< posOrderDetails.length;i++){
      final counterKey = '${posOrderDetails[i].bookType}-${posOrderDetails[i].bookId}';
      final counterValue = controller.counter[counterKey] ?? 1;
      final pendingStatus  = (controller.pendingStatusList[counterKey] == false
          || controller.pendingStatusList[counterKey] == null) ? 2 : 1;


      if (counterValue > 0) {
        final sellingPrice = posOrderDetails[i].id!.obs;
         double  total = (sellingPrice.value * counterValue);
         double actualPrice = total / (1 + posOrderDetails[i].taxRate!.toDouble() / 100);
         double totalTax = total- actualPrice;

        bookDetailList.add(
          BookDetail(
            id: 0,
            orderId: 0,
            bookId: posOrderDetails[i].bookId,
            price: posOrderDetails[i].id,
            qty: counterValue,
            status: pendingStatus,
            paymentflag: true,
            paymentdate: DateTime.now(),
            type: posOrderDetails[i].bookType,
            createdBy: pref.getInt("userId")!,
            cgst: posOrderDetails[i].taxRate! / 2,
            sgst:  posOrderDetails[i].taxRate! / 2,
            cgstAmount:double.tryParse((totalTax/ 2).toStringAsFixed(2),),
            sgstAmount: double.tryParse((totalTax / 2).toStringAsFixed(2),),
          ),
        );
      }
    }

    bool allStatusFalse = bookDetailList.every((bookDetail) => bookDetail.status == 2);

   print("allStatusFalse");
    print(allStatusFalse);

    await paymentDetailPostVm.addPaymentDetails(
        0,
        posCustomerId.value,
        totalItemsPrice.value,
        selectedDiscountType.value ==""?"":selectedDiscountType.value,
        discount.value,
        "0",
        allStatusFalse == true ? 2:1,
        pref.getInt("userId")!,
        payableTotal.value,
        1.0,
        1.0,
        bookDetailList
    );

    print( controller.pendingStatusList);

    controller.pendingStatusList.forEach((key, value) {
      print("$key$value");
    });

    if(paymentDetailPostVm.statusCode == 200){
      paymentPopUp(context);
      snackbar(context, paymentDetailPostVm.statusMessage!);
      posPaymentLoader.value = false;
      getPaymentSummaryVm.getPaymentSummaryList.clear();
      getPaymentSummaryVm.isLoading.value = true;
      await getPaymentSummaryVm.getPaymentSummaryDetails(posOrderId.toString());
      print("posOrderId: $posOrderId");

    }
    else{
      posPaymentLoader.value = false;
      snackbar(context, paymentDetailPostVm.statusMessage!);
    }

  }

  @override
  void initState() {
    super.initState();

  }
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollControllervb = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> ModalProgressHUD(
        inAsyncCall: posPaymentLoader.value == true,
        progressIndicator: progressIndicator(),
        child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: const Color(0xFFF3F3F3),
                      child: NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll){
                          overScroll.disallowIndicator();
                          return true;
                        },
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/9,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const CalculatorButton(),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                       if (posSelectedStandard.value.isNotEmpty || posSelectedStandard.value != "") {
                                         selectedDiv.value = "Select Division";
                                         posDivId = 0;
                                         parentNameController.text = "";
                                         studentNameController.text = "";
                                         parentMobController.text = '';
                                         divApiCalling();
                                         addCustomerForm(context);
                                       }
                                       else{
                                         posCustId.value = "";
                                         toastMessage(context, "Please select standard and school");
                                       }
                                      });
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height /15,
                                      width: MediaQuery.of(context).size.width /7,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF7367F0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                              spreadRadius: 2, // Adjust the spread radius
                                              blurRadius: 5, // Adjust the blur radius
                                              offset: const Offset(0, 3), // Adjust the offset
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(25)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                      Expanded(
                                        flex:3,
                                        child: Center(
                                          child: Text(
                                            " Add Customer",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height/42,
                                              color:  Colors.white,
                                              fontFamily: "NotoSans",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                "assets/images/pos_images/add_customer.svg",
                                                height: MediaQuery.of(context).size.height/9,

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/50),
                                  Builder(
                                    builder: (context) {
                                      return InkWell(
                                        onTap: () async {
                                          Scaffold.of(context).openEndDrawer();
                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          getSchoolByUserVM.schoolDetailList.clear();
                                          getSchoolByUserVM.isLoading.value = true;
                                          await getSchoolByUserVM.getSchoolByUser(pref.getInt("userId").toString());
                                          },
                                        child:   Container(
                                          height: MediaQuery.of(context).size.height/15,
                                          width:  MediaQuery.of(context).size.width/9,
                                          decoration:  BoxDecoration(
                                           color: const Color(0xFF7367F0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                                  spreadRadius: 2, // Adjust the spread radius
                                                  blurRadius: 5, // Adjust the blur radius
                                                  offset: const Offset(0, 3), // Adjust the offset
                                                ),
                                              ],
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30)
                                              )),
                                          child: Padding(
                                            padding: EdgeInsets.all(MediaQuery.of(context).size.height/70),
                                            child: SvgPicture.asset(
                                              "assets/images/pos_images/graduate.svg",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/90),
                              child: Container(
                                height: MediaQuery.of(context).size.height/8,
                                   width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F5FF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE0DDFC))
                              ),

                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/80),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Customer Details",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height/40,
                                                color: const Color(0xFF4D3FD9),
                                                fontFamily: "NotoSans",
                                                fontWeight: FontWeight.bold
                                            )),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              if(posParentName.value == ""){

                                              }
                                             else{
                                               customerDetailApi();
                                               divApiCalling();
                                               editCustomerForm(context);
                                             }

                                            });

                                          },
                                            child: SvgPicture.asset("assets/images/pos_images/edit.svg")) ,
                                      ],),
                                      Padding(
                                        padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width/20),
                                        child: Row(
                                          children: [
                                            Obx(()=>
                                               Text((posParentName.value == "")?"--":posParentName.toString(),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height/55,
                                                      color: const Color(0xFF272727),
                                                      fontFamily: "NotoSans",
                                                      fontWeight: FontWeight.bold
                                                  )),
                                            ),
                                            const Spacer(),
                                            Obx(()=>
                                              Text((posMobileNumber.value == "")?"--":posMobileNumber.toString(),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height/50,
                                                      color: const Color(0xFF616161),
                                                      fontWeight: FontWeight.w500))),
                                          ],
                                        ),
                                      ),
                                       Padding(
                                      padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width/20),
                                        child: Row(
                                        children: [
                                          Obx(
                                          ()=>
                                              Text((posStudentName.value == "")?"--":posStudentName.toString(),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height/55,
                                                    color: const Color(0xFF272727),
                                                    fontFamily: "NotoSans",
                                                    fontWeight: FontWeight.bold
                                                )),
                                          ),
                                          const Spacer(),
                                          Obx(
                                          ()=>
                                              Text((posStdDiv.value == "")?"--":posStdDiv.toString(),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height/50,
                                                    color: const Color(0xFF4D3FD9),
                                                    fontFamily: "NotoSans",
                                                    fontWeight: FontWeight.bold

                                                )),
                                          ),
                                        ],
                                    ),
                                      )

                                  ],
                                ),
                              ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/70,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/90),
                              child: Container(
                                height:viewBreakup.value == false? MediaQuery.of(context).size.height/2.5 : MediaQuery.of(context).size.height/1.8,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3), // Adjust shadow color and opacity
                                        spreadRadius: 2, // Adjust the spread radius
                                        blurRadius: 5, // Adjust the blur radius
                                        offset: const Offset(0, 3), // Adjust the offset
                                      ),
                                    ],
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius:const BorderRadius.only(topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                    border: Border.all(color: const Color(0xFFE0DDFC))
                                ),
                                child:Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/90),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height:MediaQuery.of(context).size.height/90),
                                      Text("Order Details",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height/40,
                                              color: const Color(0xFF4D3FD9),
                                              fontFamily: "NotoSans",
                                              fontWeight: FontWeight.bold
                                          )),
                                      SizedBox(height: MediaQuery.of(context).size.height/130),
                                      const Divider(
                                        color: Colors.grey,
                                        height: 3),
                                      SizedBox(
                                          height:viewBreakup.value == false? MediaQuery.of(context).size.height/3:MediaQuery.of(context).size.height/2.2,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height:MediaQuery.of(context).size.height/5.3,
                                              child: Obx(()=>
                                                  Scrollbar(
                                                thumbVisibility: true,
                                                thickness: 2,
                                                    controller: scrollController1,
                                                child: detailsIsLoading.value == true ?
                                                const Center(child: Text("Data Not Found")):
                                                ListView.builder(
                                                  controller: scrollController1,
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: posOrderDetails.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final counterKey = '${posOrderDetails[index].bookType}-${posOrderDetails[index].bookId}';
                                                    final counterValue = countController.counter[counterKey] ?? 1;
                                                    if (counterValue > 0) {
                                                      final sellingPrice = posOrderDetails[index].id!.obs;
                                                      total = (sellingPrice.value * counterValue);
                                                      double actualPrice = total / (1 + posOrderDetails[index].taxRate!.toDouble() / 100);
                                                      double totalTax = total- actualPrice;

                                                      return Column(
                                                        children: [
                                                          Center(
                                                            child: SizedBox(
                                                              height: MediaQuery.of(context).size.height /11,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: MediaQuery.of(context).size.height /90),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: Text(
                                                                          posOrderDetails[index].bookName ?? "",
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,

                                                                          style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.height /50,
                                                                            color: Colors.black,
                                                                            fontFamily: "NotoSans",
                                                                            fontWeight: FontWeight.bold,

                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        "₹ $total",
                                                                        style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.height/55,
                                                                            color:  Colors.black,
                                                                            fontFamily: "NotoSans",
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                       SizedBox(width: MediaQuery.of(context).size.width/80),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/90),
                                                                    child: Row(
                                                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          posOrderDetails[index].id?.toString() ?? "",
                                                                          style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.height /55,
                                                                            color: const Color(0xFF616161),
                                                                            fontFamily: "NotoSans",
                                                                            fontWeight: FontWeight.w300,
                                                                          ),
                                                                        ),
                                                                        Text(" x ",
                                                                            style: TextStyle(
                                                                        fontSize: MediaQuery.of(context).size.height /60,
                                                                        color: const Color(0xFF616161),
                                                                        fontWeight: FontWeight.w500,
                                                                        ),),
                                                                        Text(
                                                                          '$counterValue',
                                                                          style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.height /55,
                                                                            color: const Color(0xFF616161),
                                                                            fontFamily: "NotoSans",
                                                                            fontWeight: FontWeight.w300,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: MediaQuery.of(context).size.width/19,),
                                                                        Text( posOrderDetails[index].taxRate == 0.0 ?"":
                                                                          "CGST(${(double.tryParse(posOrderDetails[index].taxRate?.toString() ?? "") ?? 0) / 2}% ₹ ${(totalTax/2).toStringAsFixed(2)})",
                                                                          style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.height / 55,
                                                                            color: const Color(0xFF616161),
                                                                            fontFamily: "NotoSans",
                                                                            fontWeight: FontWeight.w300,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: MediaQuery.of(context).size.width/40,),
                                                                        Text(
                                                                          posOrderDetails[index].taxRate == 0.0 ?"":
                                                                          "SGST(${(double.tryParse(posOrderDetails[index].taxRate?.toString() ?? "") ?? 0) / 2}% ₹ ${(totalTax/2).toStringAsFixed(2)})",
                                                                          style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.height / 55,
                                                                            color: const Color(0xFF616161),
                                                                            fontFamily: "NotoSans",
                                                                            fontWeight: FontWeight.w300,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return const SizedBox.shrink(); // Return an empty container for non-zero counter items
                                                    }
                                                  },
                                                ),
                                              )
                                              ),
                                              ),

                                            SizedBox(height: MediaQuery.of(context).size.height/100),
                                           Row(
                                             children: [
                                               Text("Subtotal",
                                               style: TextStyle(
                                                 fontSize: MediaQuery.of(context).size.height /55,
                                                 color: Colors.black,
                                                 fontFamily: "NotoSans",
                                                 fontWeight: FontWeight.bold,
                                               )
                                           ),
                                               const Spacer(),




                                         Obx(() {
                                           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                             totalItemsPrice.value = 0.0;
                                           for (int index = 0; index < posOrderDetails.length; index++) {
                                             final sellingPrice = posOrderDetails[index].id!.obs;
                                             final count = (countController.counter["${posOrderDetails[index].bookType}-${posOrderDetails[index].bookId}"] ?? 1).obs;
                                             totalItemsPrice.value += sellingPrice.value.toDouble() * count.value.toDouble();
                                           }});
                                             return detailsIsLoading.value == true?Text("0.0",
                                                 style: TextStyle(
                                                     fontSize: MediaQuery.of(context).size.height/55,
                                                     color: const Color(0xFF272727),
                                                     fontWeight: FontWeight.w500
                                                 )):Text("₹ ${totalItemsPrice.value.toString()}",
                                                 style: TextStyle(
                                                   fontSize: MediaQuery.of(context).size.height /55,
                                                   color: Colors.black,
                                                   fontFamily: "NotoSans",
                                                   fontWeight: FontWeight.bold,
                                                 ));},
                                         ),
                                               const SizedBox(width: 7),
                                             ],
                                           ),
                                            SizedBox(height: MediaQuery.of(context).size.height/150),
                                            Row(
                                              children: [
                                                Text("Discount",
                                                    style:TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height /55,
                                                      color: Colors.black,
                                                      fontFamily: "NotoSans",
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: (){
                                                    discountController.clear();
                                                    selectedDiscountType.value ='';
                                                    applyDiscount(context);
                                                  },
                                                  child: Text(
                                                    discount.value == 0.0?"Apply  (₹ ${discount.value})":

                                                    "Applied  (₹ ${discount.value})",
                                                      style: TextStyle(
                                                      decorationColor:const Color(0xFF4D3FD9),
                                                      decorationThickness: 1,
                                                      fontWeight: FontWeight.bold,
                                                      shadows: const [Shadow(color: Color(0xFF4D3FD9), offset: Offset(0, -4))],
                                                      decoration: TextDecoration.underline,
                                                      fontSize: MediaQuery.of(context).size.height/55,
                                                      fontFamily: "NotoSans",
                                                      color: Colors.transparent),
                                                  ),
                                                ),
                                                SizedBox(width: MediaQuery.of(context).size.width/130,),
                                                discount.value == 0.0?const Text("")

                                                :GestureDetector(
                                                    onTap: (){
                                                      discountStatus.value = false;
                                                      discount.value = 0.0;
                                                      selectedDiscountType.value = "";
                                                    },
                                                    child:  Padding(
                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/130),
                                                      child: Icon(
                                                        Icons.cancel_outlined,
                                                        size: MediaQuery.of(context).size.height/35,
                                                        color: Colors.redAccent,
                                                      ),
                                                    ))


                                              ],
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height/150),
                                            Row(
                                              children: [
                                                Text("Tax",
                                                    style:TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height /55,
                                                      color: Colors.black,
                                                      fontFamily: "NotoSans",
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                ),
                                                const Spacer(),
                                                Obx(() {
                                                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                  totalPayableTax.value = 0.00;
                                                  int index = 0;
                                                  for (index = 0; index < posOrderDetails.length; index++) {
                                                    final sellingPrice = posOrderDetails[index].id!.obs;
                                                    final count = (countController.counter["${posOrderDetails[index].bookType}-${posOrderDetails[index].bookId}"] ?? 1).obs;
                                                    final totalItemsPrice = (sellingPrice.value.toDouble() * count.value.toDouble()).obs;
                                                    double? actualPrice = totalItemsPrice / (1 + posOrderDetails[index].taxRate!.toDouble()/ 100);
                                                    double? totalTax = totalItemsPrice.toDouble() - actualPrice;
                                                    double? cgst = double.tryParse((totalTax/2).toStringAsFixed(2));
                                                    double? sgst = double.tryParse((totalTax/2).toStringAsFixed(2));
                                                    totalPayableTax.value = totalPayableTax.value + (cgst!+sgst!);

                                                  }

                                                });

                                                  return detailsIsLoading.value == true
                                                      ? Text(
                                                    "0.00",
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height / 55,
                                                      color: const Color(0xFF272727),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                      : Text(
                                                    totalPayableTax.value.toPrecision(2).toString(),
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height / 55,
                                                      color: Colors.black,
                                                      fontFamily: "NotoSans",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  );
                                                }),
                                                SizedBox(width: MediaQuery.of(context).size.width/150),
                                              ],
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height/150),
                                            Row(
                                              children: [
                                                Text("",
                                                    style:TextStyle(
                                                      fontSize: MediaQuery.of(context).size.height /55,
                                                      color: Colors.black,
                                                      fontFamily: "NotoSans",
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: (){
                                                 if(payableTotal.value != 0.0) {
                                                      viewBreakup.value = !viewBreakup.value;
                                                    }
                                                  },

                                                  child: Text(viewBreakup.value == false?"View Breakup":"Hide Breakup",
                                                    style: TextStyle(
                                                        decorationColor:const Color(0xFF4D3FD9),
                                                        decorationThickness: 1,
                                                        fontWeight: FontWeight.bold,
                                                        shadows: const [Shadow(color: Color(0xFF4D3FD9), offset: Offset(0, -4))],
                                                        decoration: TextDecoration.underline,
                                                        fontSize: MediaQuery.of(context).size.height/55,
                                                        fontFamily: "NotoSans",
                                                        color: Colors.transparent),
                                                  ),
                                                ),
                                              SizedBox(width: MediaQuery.of(context).size.width/200),
                                              ],
                                            ),
                                            if(viewBreakup.value == true) SizedBox(

                                                 height:  MediaQuery.of(context).size.height/9,
                                                child: Obx((){
                                                groupedTaxData.clear();
                                                int i = 0;
                                                for (i = 0; i < posOrderDetails.length; i++) {
                                                  final counterKey = '${posOrderDetails[i].bookType}-${posOrderDetails[i].bookId}';
                                                  final counterValue = countController.counter[counterKey] ?? 1;
                                                  if (counterValue > 0) {
                                                    final sellingPrice = posOrderDetails[i].id!.obs;
                                                    double total = (sellingPrice.value * counterValue);
                                                    double actualPrice = total / (1 + posOrderDetails[i].taxRate!.toDouble() / 100);
                                                    double breakupTotalTax = total - actualPrice;
                                                    double taxRate = posOrderDetails[i].taxRate!.toDouble();
                                                    groupedTaxData[taxRate] ??= {
                                                      'total': 0,
                                                      'actualPrice': 0,
                                                      'breakupTotalTax': 0,
                                                    };
                                                    groupedTaxData[taxRate]!['total'] = (groupedTaxData[taxRate]!['total'] ?? 0) + total;
                                                    groupedTaxData[taxRate]!['actualPrice'] = (groupedTaxData[taxRate]!['actualPrice'] ?? 0) + actualPrice;
                                                    groupedTaxData[taxRate]!['breakupTotalTax'] = (groupedTaxData[taxRate]!['breakupTotalTax'] ?? 0) + breakupTotalTax;
                                                  }
                                                }
                                                return Scrollbar(
                                                  thumbVisibility: true,
                                                  thickness: 2,
                                                  controller: scrollControllervb,
                                                  child: ListView.builder(
                                                    controller: scrollControllervb,
                                                    itemCount: groupedTaxData.length,
                                                    itemBuilder: (BuildContext context, index) {
                                                      double taxRate = groupedTaxData.keys.elementAt(index);
                                                      Map<String, double> data = groupedTaxData[taxRate]!;
                                                      if ((data['breakupTotalTax']!/2) > 0) {
                                                        return Padding(
                                                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 50),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text(""),
                                                                  Text('CGST @  ${taxRate / 2}%',
                                                                    style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).size.height / 55,
                                                                      color: Colors.black,
                                                                      fontFamily: "NotoSans",
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Text('₹ ${(data['breakupTotalTax']! / 2).toStringAsFixed(2)}',
                                                                    style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).size.height / 55,
                                                                      color: Colors.black,
                                                                      fontFamily: "NotoSans",
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text(""),
                                                                  Text('SGST @  ${taxRate / 2}%',
                                                                    style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).size.height / 55,
                                                                      color: Colors.black,
                                                                      fontFamily: "NotoSans",
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Text('₹ ${(data['breakupTotalTax']! / 2).toStringAsFixed(2)}',
                                                                    style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).size.height / 55,
                                                                      color: Colors.black,
                                                                      fontFamily: "NotoSans",
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),

                                                );},
                                              )
                                            )
                                          ],)),
                                    ],
                                  )))),


                            Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/90),
                            child: Container(
                              color: const Color(0xFFF3F3F3),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:MediaQuery.of(context).size.height/90 ,
                                    horizontal: MediaQuery.of(context).size.width/90),
                                child: Row(
                                  children: [
                                    Text("Total",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height /40,
                                          color: Colors.black,
                                          fontFamily: "NotoSans",
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Spacer(),
                                    Obx(() {
                                      Future.delayed(Duration.zero, () {
                                        setState(() {
                                          if(discountStatus.value == false){
                                            payableTotal.value = 0.0;
                                            payableTotal.value = totalItemsPrice.value + taxAmount.value;
                                          }else{
                                            payableTotal.value = 0.0;
                                            payableTotal.value = discountedAmount.value + taxAmount.value;
                                          }


                                        });

                                      });
                                    return   detailsIsLoading.value == true?Text("0.00",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height/55,
                                            color: const Color(0xFF272727),
                                            fontWeight: FontWeight.w500
                                        )):
                                      Text("₹ ${payableTotal.value.toStringAsFixed(
                                          2)}",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height /46,
                                            color: Colors.black,
                                            fontFamily: "NotoSans",
                                            fontWeight: FontWeight.bold,
                                          )
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ),
                          ),
                            GestureDetector(
                              onTap:(){
                                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                  if(posCustomerId.value  == "" ){
                                      toastMessage(context,"Please add customer details");
                                    }
                                    else if(payableTotal.value == 0.0){
                                      toastMessage(context,"Payment details are empty");
                                    }
                                    else{
                                      upiPayment.value = false;
                                      cashPayment.value = false;
                                      cardPayment.value = false;
                                      otherPayment.value = false;
                                      viewBreakup.value = false;
                                      paymentConfirmationPopUp(context);
                                    }
                                });

                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/90),
                                child: Container(
                                 height:MediaQuery.of(context).size.height/10,
                                  decoration: const BoxDecoration(
                                      borderRadius:BorderRadius.only(bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      color: Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0, 3),
                                            blurRadius: 6)
                                      ]),

                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height/17,
                                        decoration:  BoxDecoration(
                                          color: const Color(0xFF7367F0),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Center(child: Obx(() {
                                          Future.delayed(Duration.zero, () {
                                            setState(() {
                                              if(discountStatus.value == false){
                                                payableTotal.value = 0.0;
                                                payableTotal.value = totalItemsPrice.value + taxAmount.value;
                                              }else{
                                                payableTotal.value = 0.0;
                                                payableTotal.value = discountedAmount.value + taxAmount.value;
                                              }

                                            });

                                          });
                                          return   detailsIsLoading.value == true?Text("0.00",
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height/55,
                                                  color: Colors.white,
                                                  fontFamily: "Notosans",
                                                  fontWeight: FontWeight.bold
                                              )):
                                          Text(" Pay ₹ ${payableTotal.value.toStringAsFixed(0)}",
                                              style: TextStyle(
                                                  fontSize: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height / 40,
                                                  color: Colors.white,
                                                  fontFamily: "Notosans",
                                                  fontWeight: FontWeight.bold
                                              )
                                          );
                                        })),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
               ),
      ),
    );
  }
}
