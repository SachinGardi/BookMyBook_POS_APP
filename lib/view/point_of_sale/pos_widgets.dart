import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import '../../view_modal/pos_view_modal/counter_vm.dart';
import 'order_detail.dart';

///Dependancy injection

TextEditingController discountController = TextEditingController();


///Variable declaration
var discountedAmount = 0.0.obs;
var discount = 0.0.obs;
var totalFinalAmount = 0.obs;

///For Showing User assigned school name
Widget schoolNameWidget(BuildContext context) => Obx(()=> Padding(
      padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/110),
      child: RichText(
          text: TextSpan(
                text: posSelectedSchool.value == ""?"":"${posSelectedSchool.value} >>  ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height /45,
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF272727)),
            children: <TextSpan>[
              TextSpan(
                text:  posSelectedStandard.value == ""?"":"$posSelectedStandard  Std",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height /45,
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7367F0)),
              )
            ])),

  ));

final CounterController pendingBookController = Get.put(CounterController());

///Pending Book Dialogue
Future<void> pendingDialogue(BuildContext context,int id,String bookName,String type) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String keyToCheck = '$type-$id';
        bool? itemStatus = pendingBookController.pendingStatusList[keyToCheck];
        print(keyToCheck);
        print(pendingBookController.pendingStatusList);
        print("itemStatus$itemStatus");
        return SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(bottom: 2),
            titlePadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 40,
              left: MediaQuery.of(context).size.width / 40,
              bottom: MediaQuery.of(context).size.height /30,
            ),
            title: Text(
              (itemStatus == null || itemStatus == false)?'Mark as pending':"Revert Back" ,
              style: TextStyle(
                  color: const Color(0xFF5448D2),
                  fontSize: MediaQuery.of(context).size.height / 40,
                  fontWeight: FontWeight.w600),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height/4,
              child: Column(
                  children: [
                    SvgPicture.asset("assets/images/pos_images/pendingBooks.svg",
                      height: MediaQuery.of(context).size.height/10,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/30,
                    ),
                    Text(bookName,
                        style: TextStyle(
                            color: const Color(0xFFFF7630),
                            fontSize: MediaQuery.of(context).size.height / 40,
                            fontWeight: FontWeight.w400))
                    ,
                    SizedBox(
                      height: MediaQuery.of(context).size.height/50,
                    ),

                    Text( (itemStatus == null || itemStatus == false)?'Are you sure to mark this $type as pending ? ':"Are you sure to revert back this changes" ,
                        style: TextStyle(
                            color: const Color(0xFF3B3B3B),
                            fontSize: MediaQuery.of(context).size.height / 45,
                            fontWeight: FontWeight.w500)),
                  ]),

            ),

            actions: <Widget>[
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
                        (itemStatus == null || itemStatus == false)?
                        pendingBookController.updatePendingStatus(id.toString(),type):
                        pendingBookController.updateAvailableStatus(id.toString(),type);
                        Get.back();
                      },
                      child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height /15,
                            width: MediaQuery.of(context).size.width /8,
                            decoration: BoxDecoration(
                                color: const Color(0xFF7367F0),
                                boxShadow: [
                                  BoxShadow(
                                    color:  Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                    spreadRadius: 2, // Adjust the spread radius
                                    blurRadius: 5, // Adjust the blur radius
                                    offset: const Offset(0, 3), // Adjust the offset
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: Text(
                                  "OK",
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
              SizedBox(height: MediaQuery.of(context).size.height / 45),
            ],
          ),
        );
      });
}



/// dicount List

List defaultDiscountList = ['Flat Discount' , '% Discount'];
var selectedDiscountType =''.obs;

///applyDiscount Book Dialogue
Future<void> applyDiscount(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,

        content: SizedBox(
          width: MediaQuery.of(context).size.width/2.6,
          height: MediaQuery.of(context).size.height /1.8,
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
                            'Discount',
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
              SizedBox(height: MediaQuery.of(context).size.height/35,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                child: Text(
                  "Discount Type",
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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                  child:Obx(
                    ()=> DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          "Select Discount",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40,
                            fontFamily: "NatoSans",
                            color: const Color(0xFF3B3B3B),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        items: defaultDiscountList
                            .map((item) => DropdownMenuItem<String>(
                          value: item.toString(),
                          child: Text(
                            item.toString(),
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontFamily: "NatoSans",
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))
                            .toList(),
                        value:selectedDiscountType.value.isEmpty
                            ? null
                            : selectedDiscountType.value,
                        onChanged: (String? value) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            selectedDiscountType.value = value!;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 50,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: CupertinoColors.black),
                          ),
                          height: MediaQuery.of(context).size.height / 14,
                          width: MediaQuery.of(context).size.width / 2.5,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: MediaQuery.of(context).size.height / 2.5,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87, width: 1.5),
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                      ),
                    ),
                  )
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                child: Text(
                  "Discount",
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
                    cursorColor: Colors.black54,
                    controller: discountController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                      hintText: "Enter Value",
                      hintStyle: TextStyle(
                        fontFamily: "NatoSans",
                        fontSize: MediaQuery.of(context).size.height / 40)),
                    keyboardType: TextInputType.number,
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
                        discountController.clear();
                        selectedDiscountType.value = '';
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
                              "Clear",
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
                      onTap: () {
                        discountedAmount.value = 0.0;
                        discount.value = 0.0;
                        if(selectedDiscountType.value == ''){
                          snackbar(context, "Please select discount type.");
                        }
                        else if(discountController.text.isEmpty){
                          snackbar(context, "Please enter discount value.");
                        }

                        else if (selectedDiscountType.value == 'Flat Discount') {

                          if(int.parse(discountController.text) > totalItemsPrice.value){
                            snackbar(context,"Please enter valid discount value");
                          }
                          else{
                            discount.value = double.parse(discountController.text);
                            discountedAmount.value = totalItemsPrice.value - discount.value;
                            discountStatus.value = true;
                            Get.back();
                          }

                        } else if (selectedDiscountType.value == '% Discount') {
                          if (int.parse(discountController.text) > 100) {
                            snackbar(
                                context, "Please enter valid discount value");
                          }
                          else {
                            discount.value = totalItemsPrice.value *
                                (double.parse(discountController.text) / 100);
                            discountedAmount.value =
                                totalItemsPrice.value - discount.value;
                            discountStatus.value = true;
                            Get.back();
                          }
                        }

                      },
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7367F0),

                            ///clear
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
                              "Confirm",
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


double breakupTotalTax = 0.0;
 viewBreakupData(BuildContext context)async{
  await showDialog(
    context:context,
    barrierDismissible: true,
    builder: (BuildContext context){
      final CounterController controller = Get.put(CounterController());
      Map<double, Map<String, double>> groupedTaxData = {};

      for (int i = 0; i < posOrderDetails.length; i++) {
        final counterKey = '${posOrderDetails[i].bookType}-${posOrderDetails[i].bookId}';
        final counterValue = controller.counter[counterKey] ?? 1;

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
      // groupedTaxData.forEach((taxRate, data) {
      //   print('Tax Rate: $taxRate%');
      //   print('Sum of Total: ${data['total']}');
      //   print('Sum of Actual Price: ${data['actualPrice']}');
      //   print('Sum of Breakup Total Tax: ${data['breakupTotalTax']}');
      //   print('---');
      // });
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title:  Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height /40),
          child: Column(
            children: [
              Padding(
                padding:EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width /60,
                ),
                child: Row(
                  children: [
                    Text(
                        'Breakup View',
                        style: TextStyle(
                            color: const Color(0xFF5448D2),
                            fontFamily: "NotoSans",
                            fontSize: MediaQuery.of(context).size.height /30,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {

                        Get.back();
                      },
                      child:  Icon(Icons.cancel_outlined, color: Colors.redAccent,size: MediaQuery.of(context).size.height/20,),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/40,),
              const Divider(
                color: Colors.black,
                height: 2,
              )
            ],
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height / 1.8,
          child: ListView.builder(
            itemCount: groupedTaxData.length,
              itemBuilder: (BuildContext context,index){
              double taxRate = groupedTaxData.keys.elementAt(index);
            Map<String, double> data = groupedTaxData[taxRate]!;

            return ListTile(
            title: Text('Tax Rate: $taxRate%'),
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sum of Total: ${data['total']}'),
            Text('Sum of Actual Price: ${data['actualPrice']}'),
            Text('Sum of Breakup Total Tax: ${data['breakupTotalTax']}'),
          ],
        ),
      );
    },),
        ),
      );
    }

  );
}