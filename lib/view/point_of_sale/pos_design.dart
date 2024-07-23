import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/point_of_sale/pos_tab.dart';
import 'package:tuck_shop/view_modal/pos_view_modal/addcustomer_vm.dart';
import '../../modal/pos_modal/orderdetail_modal.dart';
import '../../view_modal/pos_view_modal/cancelorder_vm.dart';
import '../../view_modal/pos_view_modal/confirm_invoice_vm.dart';
import '../../view_modal/pos_view_modal/counter_vm.dart';
import '../../view_modal/pos_view_modal/customerdetail_vm.dart';
import '../../view_modal/pos_view_modal/division_vm.dart';
import '../../view_modal/pos_view_modal/getpayment_summary_vm.dart';
import '../../view_modal/pos_view_modal/getschoolbyuser_vm.dart';
import '../../view_modal/pos_view_modal/paymentdetailpost_vm.dart';
import '../../view_modal/pos_view_modal/posbookset_vm.dart';
import '../../view_modal/pos_view_modal/standard_vm.dart';
import 'add_customer.dart';
import 'order_detail.dart';



///Dependency Injection
GlobalKey<FormState> formKey = GlobalKey<FormState>();
final PosStandardVM standardVM = Get.put(PosStandardVM());
final DivisionVM divisionVM = Get.put(DivisionVM());
final GetSchoolByUserVM getSchoolByUserVM = Get.put(GetSchoolByUserVM());
final PosBookSetVM posBookSetVM = Get.put(PosBookSetVM());
final PaymentDetailPostVm paymentDetailPostVm = Get.put(PaymentDetailPostVm());
final getPaymentSummaryVm = Get.put(GetPaymentSummaryVm());
final customerDetailVM = Get.put(CustomerDetailVM());
final confirmInvoiceVm = Get.put(ConfirmInvoiceVm());
final cancelOrderVm = Get.put(CancelOrderVm());
final PosTabState posTab = PosTabState();


final TextEditingController dropdownSearchController = TextEditingController();
///Variable
int? selectedItemId;
var posSelectedSchool =''.obs ;
var posSelectedStandard = ''.obs;
var posSelectedSchoolId = ''.obs;
var counterIncrement = ''.obs;
var detailsIsLoading = true.obs;
int? posSchoolId;
int? posStandardId;
int? posDivId;


List<OrderDetailModal> posOrderDetails =[];
///Color List for filter Standard Border
List<Color> colorList = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.purple,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.purple,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
];

class PointOfSale extends StatefulWidget {
  const PointOfSale({Key? key}) : super(key: key);
  @override
  State<PointOfSale> createState() => _PointOfSaleState();
}


///This Filtered school and standard wise data
filteredBookSetApi(){
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

    final CounterController controller = Get.put(CounterController());
    controller.resetCounters();
    detailsIsLoading.value = true;
    posPendingStatus.value = false;
     //currentIndexPos.value = 0;
    posCustId.value = '';
    updateDiv = '';
    viewBreakup.value =false;
    posBookSetVM.bookSetList.clear();
    posOrderDetails.clear();

    posBookSetVM.isLoading.value = true;
    await posBookSetVM.getBookSet("1", "500", "", posSelectedSchoolId.toString(), posStandardId.toString(), "");
    controller.initialController();
     for (var element in posBookSetVM.bookSetList) {
       posOrderDetails.add(OrderDetailModal(
           bookId: element.id,
           bookType: element.type,
           id: element.sellingPrice!,
           bookName: element.bookName == null ? "":element.bookName!,
           taxRate:   element.taxRate!

       ));
     }


    addCustomerVm.customerResponseList.clear();
     // currentIndexPos.value = 0;
      posParentName.value ='';
      posMobileNumber.value ='';
      posStudentName.value ='';
      posStdDiv.value ='';
      detailsIsLoading.value = false;
    Get.back();
    Get.offAllNamed("/dashboard", arguments: 1);
  });
}


/// Initially api calling
initApiCalling() {
  if(posSelectedSchool.value == "" || posSelectedSchool.value == null) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      //posSelectedSchool.value = pref.getString("schoolName")!;
    //  posSelectedSchoolId.value = pref.getInt("schoolId").toString();
    });
  }
}
var drawerSelectedSchool = ''.obs;
class _PointOfSaleState extends State<PointOfSale> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  setState(() {
    initApiCalling();
  });
  }


  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF4F4F6),
          endDrawer:GestureDetector(
            child: Container(
                color: const Color(0xFFF3F3F3),
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 40,
                      vertical: MediaQuery.of(context).size.height / 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child:  Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.redAccent,
                                  size: MediaQuery.of(context).size.height/20,
                                ))
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      Text(
                        "Select School",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 35,
                            fontFamily: "NatoSans",
                            color: const Color(0xFF3B3B3B),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 40),

                Obx(() => getSchoolByUserVM.isLoading.value == true ? Center(child: const CircularProgressIndicator(color: Colors.deepPurpleAccent,)) : DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      "Select School",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40,
                          fontFamily: "NatoSans",
                          color: const Color(0xFF3B3B3B),
                          fontWeight: FontWeight.w400),
                    ),
                    items: getSchoolByUserVM.schoolDetailList
                        .map((item) => DropdownMenuItem<String>(
                      onTap: () async {
                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                          posSelectedSchool.value = item.schools!;
                          posSelectedSchoolId.value = item.id!.toString();
                          posSchoolId = item.id!;
                          posBookSetVM.bookSetList.clear();
                          posBookSetVM.isLoading.value = true;
                          posTab.getPosFilteredBooks().clear;
                          posOrderDetails.clear();
                          posCustomerId.value = "";
                          standardVM.posStandardList.clear();
                          standardVM.isLoading.value = true;
                          await standardVM.getPosStandardInfo(posSchoolId!);
                          Timer(const Duration(milliseconds: 100), () {
                            posBookSetVM.isLoading.value = false;
                          });
                        });



                      },
                      value: item.schools.toString(),
                      child: Text(item.schools.toString(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontFamily: "NatoSans",
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ))
                        .toList(),
                    value: drawerSelectedSchool.value == '' ? null : drawerSelectedSchool.value,
                    onChanged: (String? value) {
                      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                        selectedItemId = -1;
                        drawerSelectedSchool.value = value!;
                        posSelectedStandard.value = "";
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: (drawerSelectedSchool.value == "") ? CupertinoColors.black : const Color(0xFF7367F0))),
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width / 2.5,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: dropdownSearchController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: dropdownSearchController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search school',
                            hintStyle: const TextStyle(fontSize: 12),
                            suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    dropdownSearchController.clear();
                                  });
                                },
                                child:  Icon(Icons.cancel_outlined,
                                    size: MediaQuery.of(context).size.height/25,
                                    color: Colors.redAccent)),
                            focusedBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),

                            ) ,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (items, selectedTaluka) {
                        return (items.value
                            .toString()
                            .toLowerCase()
                            .startsWith(selectedTaluka
                            .toLowerCase()));
                      },
                    ),
                    // This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        dropdownSearchController.clear();
                      }
                    },
                    dropdownStyleData: DropdownStyleData(
                        maxHeight: MediaQuery.of(context).size.height / 2.5,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 1.5))),
                    menuItemStyleData: MenuItemStyleData(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                  ),
                )),

                SizedBox(height: MediaQuery.of(context).size.height / 40),
                      (drawerSelectedSchool.value == "") ? Text("") :
                      Text("Select Standard",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height / 35,
                                  fontFamily: "NatoSans",
                                  color: const Color(0xFF3B3B3B),
                                  fontWeight: FontWeight.w500),
                            ),
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      Obx(()=> (standardVM.isLoading.value == true)?const Text(""):
                             Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 35),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height / 2.2,
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      // Number of columns in the grid
                                      crossAxisSpacing:
                                          MediaQuery.of(context).size.width / 25,
                                      // Spacing between columns
                                      mainAxisSpacing:
                                          MediaQuery.of(context).size.height / 40,
                                      childAspectRatio: 2.8, // Spacing between rows
                                    ),
                                    itemCount: standardVM.posStandardList.length,
                                    // The total number of grid items
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                               posBookSetVM.bookSetList.clear();
                                                posBookSetVM.isLoading.value = true;
                                                posTab.getPosFilteredBooks().clear;
                                                posOrderDetails.clear();
                                                posCustomerId.value = "";
                                                Timer(const Duration(milliseconds: 100), () {
                                                  posBookSetVM.isLoading.value = false;
                                                });

                                              selectedItemId = index;
                                              posStandardId = standardVM.posStandardList[index].id!;
                                              posSelectedStandard.value = standardVM.posStandardList[index].text!.toString();

                                            });
                                          },
                                          child: Container(
                                            decoration:  BoxDecoration(
                                              color: const Color(0xFFFCFCFC),
                                              border: Border(
                                                top: BorderSide(
                                                  color: (selectedItemId == index)? Colors.blue:Colors.white,
                                                  width: 2,
                                                ),
                                                left: BorderSide(
                                                  color: (selectedItemId == index)? Colors.blue:Colors.white,
                                                  width: 2,
                                                ),
                                                right: BorderSide(
                                                    color: (selectedItemId == index)? Colors.blue:Colors.white, width: 2),
                                                bottom: BorderSide(
                                                  color: colorList[index], // Border color
                                                  width: 3.5, // Border width
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                standardVM.posStandardList[index].text!,
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        40,
                                                    fontFamily: "NatoSans",
                                                    color: const Color(0xFF3B3B3B),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                              ),
                          ),
                      Spacer(),

                      GestureDetector(
                        onTap: () {
                          (drawerSelectedSchool.value == "")
                              ? toastMessage(context, "Please select school")
                              :  posSelectedStandard.value == ""
                                  ? toastMessage(context, "Please select standard")
                                  : filteredBookSetApi();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 14,
                          decoration: BoxDecoration(
                              color: const Color(0xFF7367F0),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                            "Proceed",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height / 40,
                                fontFamily: "NatoSans",
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
                  vertical: MediaQuery.of(context).size.height / 50),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PosTab(),
                  ),
                  Expanded(flex: 2, child: OrderDetails()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


