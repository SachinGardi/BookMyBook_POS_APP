import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import 'package:tuck_shop/view/point_of_sale/pos_widgets.dart';
import 'package:tuck_shop/view_modal/pos_view_modal/getpayment_summary_vm.dart';
import '../../repository/pos_repository/paymentdetailpost_repo.dart';
import '../../view_modal/pos_view_modal/addcustomer_vm.dart';
import '../../view_modal/pos_view_modal/counter_vm.dart';
import '../common_widgets/progress_indicator.dart';
import '../common_widgets/snack_bar.dart';
import 'add_customer.dart';
import 'order_detail.dart';


var isChecked = false.obs;
var cashPayment = false.obs;
var upiPayment = false.obs;
var cardPayment = false.obs;
var otherPayment = false.obs;
var paymentType = "".obs;

///Remark Controller
TextEditingController remarkController = TextEditingController();


///Posting invoice data
confirmInvoiceApi(BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  confirmInvoiceVm.isLoading.value = true;
  await confirmInvoiceVm.confirmInvoice(
      0,
      posOrderId!,
      int.parse(pTotalQtys!),
      double.parse(pTotalAmounts!),
      paymentType.value,
      remarkController.text,
      isChecked.value,
      pref.getInt("userId")!);

  if(confirmInvoiceVm.statusCode == 200){
    final CounterController controller = Get.put(CounterController());
    controller.resetCounters();
    posCustomerId.value ="";
    discountStatus.value = false;
    addCustomerVm.customerResponseList.clear();
   posParentName.value ='';
   posMobileNumber.value ='';
   posStudentName.value ='';
   posStdDiv.value ='';
    detailsIsLoading.value = false;
    discountStatus.value = false;
    discount.value = 0.0;
    selectedDiscountType.value = "";
    snackbar(context, confirmInvoiceVm.statusMessage!);
    // Get.offAllNamed("/receiptWebView",arguments: [confirmInvoiceVm.invoiceId.toString(),1]);
    Get.offAllNamed("/receiptWebView",arguments: [posOrderId.toString(),1]);


  }
  else{
    toastMessage(context, confirmInvoiceVm.statusMessage!);
  }

}

Future<void> paymentPopUp(BuildContext context) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,

          content: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 1.4,
              child:Obx(
                    () => ModalProgressHUD(
                  inAsyncCall: getPaymentSummaryVm.isLoading.value == true,
                  progressIndicator: progressIndicator(),
                  child: ListView(
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
                              'Payment Summary',
                              style: TextStyle(
                                  fontFamily: "NotoSans",
                                  color: const Color(0xFF5448D2),
                                  fontSize: MediaQuery.of(context).size.height /34,
                                  fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            // GestureDetector(
                            //     onTap: () async {
                            //       remarkController.clear();
                            //       isChecked.value = false;
                            //       cashPayment.value = false;
                            //       upiPayment.value = false;
                            //       cardPayment.value = false;
                            //       Get.back();
                            //       },
                            //     child: const Icon(Icons.cancel_outlined,color: Colors.redAccent,))
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height/80,
                              horizontal: MediaQuery.of(context).size.width / 50),
                          child: Column(
                             children: [
                              profileDetail(
                                  context, "Student Name", payStudentsName ?? ""),
                              profileDetail(
                                  context, "Standard", pStandards ?? ""),
                              profileDetail(
                                  context, "Division",  pDivisions ?? ""),
                              profileDetail(
                                  context, "Total Qty.", pTotalQtys ?? ""),
                            ],
                          ),
                        ),
                      ),
                      totalAmount(context),
                      SizedBox(height: MediaQuery.of(context).size.height / 40),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width /47,
                          right: MediaQuery.of(context).size.width / 40,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                upiPayment.value = false;
                                cardPayment.value = false;
                                otherPayment.value = false;
                                cashPayment.value = true;
                                paymentType.value = "Cash";
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /18,
                                    height: MediaQuery.of(context).size.height /14,
                                    decoration: BoxDecoration(
                                      color: cashPayment.value == true
                                          ? const Color(0xFF7367F0)
                                              .withOpacity(0.2)
                                          : Colors.white,
                                      border: Border.all(
                                        color: cashPayment.value == true
                                            ? const Color(0xFF7367F0)
                                            : const Color(
                                                0xFF707070), // Border color
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SvgPicture.asset(
                                          "assets/images/pos_images/cashPayment.svg"),
                                    ),
                                  ),
                                  cashPayment.value == true
                                      ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  60,
                                              backgroundColor:
                                                  const Color(0xFF7367F0),
                                              child: Center(
                                                  child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    70,
                                              ))),
                                        )
                                      : const Text(""),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  cardPayment.value = false;
                                  cashPayment.value = false;
                                  otherPayment.value = false;
                                  upiPayment.value = true;
                                  paymentType.value = "Upi";
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 18,
                                      height:
                                          MediaQuery.of(context).size.height / 14,
                                      decoration: BoxDecoration(
                                        color: upiPayment.value == true
                                            ? const Color(0xFF7367F0)
                                                .withOpacity(0.2)
                                            : Colors.white,
                                        border: Border.all(
                                          color: upiPayment.value == true
                                              ? const Color(0xFF7367F0)
                                              : const Color(
                                                  0xFF707070), // Border color
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SvgPicture.asset(
                                            "assets/images/pos_images/upi.svg"),
                                      ),
                                    ),
                                    upiPayment.value == true
                                        ? Positioned(
                                            right: 0,
                                            top: 0,
                                            child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    60,
                                                backgroundColor:
                                                    const Color(0xFF7367F0),
                                                child: Center(
                                                    child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      70,
                                                ))),
                                          )
                                        : const Text(""),
                                  ],
                                )),
                            GestureDetector(
                                onTap: () {
                                  upiPayment.value = false;
                                  cashPayment.value = false;
                                  otherPayment.value = false;
                                  cardPayment.value = true;
                                  paymentType.value = "Card";
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 18,
                                      height:
                                          MediaQuery.of(context).size.height / 14,
                                      decoration: BoxDecoration(
                                        color: cardPayment.value == true
                                            ? const Color(0xFF7367F0)
                                                .withOpacity(0.2)
                                            : Colors.white,
                                        border: Border.all(
                                          color: cardPayment.value == true
                                              ? const Color(0xFF7367F0)
                                              : const Color(
                                                  0xFF707070), // Border color
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SvgPicture.asset(
                                            "assets/images/pos_images/cardPayment.svg"),
                                      ),
                                    ),
                                    cardPayment.value == true
                                        ? Positioned(
                                            right: 0,
                                            top: 0,
                                            child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    60,
                                                backgroundColor:
                                                    const Color(0xFF7367F0),
                                                child: Center(
                                                    child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      70,
                                                ))),
                                          )
                                        : const Text(""),
                                  ],
                                )),
                            GestureDetector(
                                onTap: () {
                                  upiPayment.value = false;
                                  cashPayment.value = false;
                                  cardPayment.value = false;
                                  otherPayment.value = true;
                                  paymentType.value = "Other";
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width / 18,
                                      height:
                                      MediaQuery.of(context).size.height / 14,
                                      decoration: BoxDecoration(
                                        color: otherPayment.value == true
                                            ? const Color(0xFF7367F0)
                                            .withOpacity(0.2)
                                            : Colors.white,
                                        border: Border.all(
                                          color: otherPayment.value == true
                                              ? const Color(0xFF7367F0)
                                              : const Color(
                                              0xFF707070), // Border color
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text("Other",
                                            style:  TextStyle(
                                                fontFamily: "NotoSans",
                                                fontSize: MediaQuery.of(context).size.height/45,
                                                fontWeight: FontWeight.w500,
                                                color:Colors.redAccent
                                            )
                                        ),
                                      ),
                                    ),
                                    otherPayment.value == true
                                        ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: CircleAvatar(
                                          radius: MediaQuery.of(context)
                                              .size
                                              .height /
                                              60,
                                          backgroundColor:
                                          const Color(0xFF7367F0),
                                          child: Center(
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    70,
                                              ))),
                                    )
                                        : const Text(""),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height /30),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 47),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width / 50),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: remarkController,
                              style:  TextStyle(
                                  fontFamily: "NotoSans",
                                  fontSize: MediaQuery.of(context).size.height/45,
                                  fontWeight: FontWeight.w500,
                                  color:Colors.black
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left:MediaQuery.of(context).size.width/70 ,
                                    top: MediaQuery.of(context).size.height/70),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFA8A8A8))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFA8A8A8))),
                                hintText: "Enter Remark",
                                hintStyle: TextStyle(
                                  fontFamily: "NotoSans",
                                  fontSize: MediaQuery.of(context).size.height /45,
                                  color: Colors.grey
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height /20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                cancelOrderVm.statusCode = 0;
                                await cancelOrderVm.cancelOrderVmFunction(posOrderId.toString(),"");
                                if(cancelOrderVm.statusCode == 200){
                                 posCustId.value = '';
                                  final CounterController controller = Get.put(CounterController());
                                  controller.resetCounters();
                                 posCustomerId.value ="";
                                  discountStatus.value = false;
                                 addCustomerVm.customerResponseList.clear();
                                 posParentName.value ='';
                                 posMobileNumber.value ='';
                                 posStudentName.value ='';
                                 posStdDiv.value ='';
                                  detailsIsLoading.value = false;
                                  discountStatus.value = false;
                                  discount.value = 0.0;
                                  selectedDiscountType.value = "";
                                  Get.offAllNamed("/dashboard", arguments: 1);
                                  toastMessage(context,cancelOrderVm.statusMessage!);
                                }
                                else{
                                  toastMessage(context,cancelOrderVm.statusMessage!);
                                }
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
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  "Cancel order",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height / 50,
                                      fontFamily: "NotoSans",
                                      color:  Colors.black),
                                )),
                              )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 50,
                            ),
                            GestureDetector(
                              onTap: ()  {
                                paymentType.value == ""?
                                snackbar(context, "Please select transaction type"):
                                (otherPayment.value == true && remarkController.text == "")?
                                snackbar(context, "Please enter remark"):
                                confirmInvoiceApi(context);
                              },
                              child: Center(
                                  child: Container(
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width / 8,
                                decoration: BoxDecoration(
                                  ///confirm
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                        spreadRadius: 2, // Adjust the spread radius
                                        blurRadius: 5, // Adjust the blur radius
                                        offset: const Offset(0, 3), // Adjust the offset
                                      ),
                                    ],
                                    color: const Color(0xFF7367F0),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  "Confirm order",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height / 50,
                                      fontFamily: "OpenSans",
                                      color: Colors.white),
                                )),
                              )),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

        );
      });
}

Widget profileDetail(BuildContext context, String key, String value) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    key,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height /42,
                        fontFamily: "NotoSans",
                        color: const Color(0xFF272727)),
                  ),
                  const Spacer(),
                  Text(
                    ':  ',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 40,
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height /41,
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF272727)),
                maxLines: 3,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );

Widget totalAmount(BuildContext context) => Container(
      height: MediaQuery.of(context).size.height / 20,
      color: const Color(0xFFEBEBEB),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 120),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width /47),
                    child: Text(
                      "Amount",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 41,
                          fontFamily: "NotoSans",
                          color: const Color(0xFF272727)),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    ':  ',
                    style: TextStyle(
                      fontFamily: "NotoSans",
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 40,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ $pTotalAmounts",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontFamily: "NatoSans",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7367F0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
