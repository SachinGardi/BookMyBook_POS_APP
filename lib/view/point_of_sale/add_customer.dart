import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import '../../view_modal/pos_view_modal/addcustomer_vm.dart';
import '../common_widgets/progress_indicator.dart';
import '../common_widgets/snack_bar.dart';



var selectedDiv = 'Select Division'.obs;

var customerLoader = false.obs;

///TextEditing Controller
TextEditingController parentNameController =TextEditingController();
TextEditingController parentMobController =TextEditingController();
TextEditingController studentNameController =TextEditingController();
final AddCustomerVm addCustomerVm =Get.put(AddCustomerVm());
bool isParentNameValid(String parentName) {
  final parentNameWithoutSpaces = parentName.replaceAll(" ", "");
  return parentNameWithoutSpaces.length > 2;
}

addCustomerAPI(BuildContext context) async {
  SharedPreferences pref = await  SharedPreferences.getInstance();
  addCustomerVm.isLoading.value = true;
  customerLoader.value = true;
  await addCustomerVm.addCustomer(0,
      parentNameController.text.trimRight(),
      parentMobController.text,
      studentNameController.text.trimRight(),
      posSchoolId!,
      posStandardId!,
      (posDivId == 0 )? 1 : posDivId! ,
      pref.getInt('userId')!);
  if(addCustomerVm.statusCode == 200){
    toastMessage(context, addCustomerVm.statusMessage!);
    Get.back();
    customerLoader.value = false;
  }
  else{
    toastMessage(context, addCustomerVm.statusMessage!);
    customerLoader.value = false;
  }
}

Future<void> addCustomerForm(BuildContext context) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Obx(
            ()=> NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll){
                overScroll.disallowIndicator();
                return true;
              },
              child: SizedBox(
                  width: MediaQuery.of(context).size.width/1.5,
                  height: MediaQuery.of(context).size.height/1.4,
                  child: ModalProgressHUD(
                    color: Colors.transparent,
                    inAsyncCall: divisionVM.isLoading.value == true || customerLoader.value == true,
                    progressIndicator:progressIndicator(),
                    child: Form(
                      key: formKey,
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
                                          'Add Customer Details',
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
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RichText(
                                      text:TextSpan(
                                        text: "Parent's Name",
                                        style:  TextStyle(
                                            color: const Color(0xFF3B3B3B),
                                            fontFamily: "NotoSans",
                                            fontSize: MediaQuery.of(context).size.height/37,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                         TextSpan(
                                           text: " *",
                                             style:  TextStyle(
                                               color:  Colors.redAccent,
                                               fontSize: MediaQuery.of(context).size.height/37,


                                              )
                                         )
                                        ]
                                      ) ,

                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RichText(
                                      text:TextSpan(
                                          text: "Mobile Number",
                                          style:  TextStyle(
                                              color: const Color(0xFF3B3B3B),
                                              fontFamily: "NotoSans",
                                              fontSize: MediaQuery.of(context).size.height/37,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                                text: " *",
                                                style:  TextStyle(
                                                  color:  Colors.redAccent,
                                                  fontSize: MediaQuery.of(context).size.height/37,


                                                )
                                            )
                                          ]
                                      ) ,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/55,),
                            ///Parents name and mobile number TextField row
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child:Padding(
                                        padding:  EdgeInsets.only(top:  MediaQuery.of(context).size.height/90),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height/14,
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                                            child: TextFormField(
                                              controller: parentNameController,
                                              style:  TextStyle(
                                                  fontFamily: "NotoSans",
                                                  fontSize: MediaQuery.of(context).size.height/38,
                                                  fontWeight: FontWeight.bold

                                              ),
                                              cursorColor: Colors.black26,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z ]')),
                                                LengthLimitingTextInputFormatter(50),
                                                TextInputFormatter.withFunction((oldValue, newValue) {
                                                  String trimmedText = newValue.text.trimLeft();
                                                  final cursorOffset = newValue.selection.baseOffset - (newValue.text.length - trimmedText.length);
                                                  return TextEditingValue(
                                                    text: trimmedText,
                                                    selection: TextSelection.collapsed(offset: cursorOffset),
                                                  );
                                                }),
                                              ],
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:MediaQuery.of(context).size.width/70),
                                                isDense: false,

                                                border:OutlineInputBorder(

                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: const BorderSide(
                                                        color:   Colors.black45
                                                    )
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: const BorderSide(
                                                       color: Colors.black45
                                                    )
                                                ),
                                                hintText: "Parent's Name",
                                                hintStyle: TextStyle(
                                                  fontFamily: "NotoSans",
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: MediaQuery.of(context).size.height/45,
                                                ),


                                              ),

                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization.words, // Capitalize the first letter of each word
                                              // You can add more properties like validators, controllers, and onChanged as needed
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child:SizedBox(
                                        height: MediaQuery.of(context).size.height/14,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                                          child: TextFormField(
                                            controller: parentMobController,
                                            style:  TextStyle(
                                                fontFamily: "NotoSans",
                                                fontSize: MediaQuery.of(context).size.height/38,
                                                fontWeight: FontWeight.bold

                                            ),
                                            cursorColor: Colors.black26,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(10),

                                            ],
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:MediaQuery.of(context).size.width/70),
                                              border:OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:   Colors.black45
                                                  )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:  Colors.black45
                                                  )
                                              ),
                                              hintText: "Mobile Number",
                                              hintStyle: TextStyle(
                                                fontFamily: "NotoSans",
                                                fontWeight: FontWeight.w300,
                                                fontSize: MediaQuery.of(context).size.height/45,
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/35,),

                            ///Student name and Select standard label row
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RichText(
                                      text:TextSpan(
                                          text: "Student Name",
                                          style:  TextStyle(
                                              color: const Color(0xFF3B3B3B),
                                              fontFamily: "NotoSans",
                                              fontSize: MediaQuery.of(context).size.height/37,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                                text: " *",
                                                style:  TextStyle(
                                                  color:  Colors.redAccent,
                                                  fontSize: MediaQuery.of(context).size.height/37,


                                                )
                                            )
                                          ]
                                      ) ,

                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('Select Standard',
                                        style: TextStyle(
                                            color: const Color(0xFF3B3B3B),
                                            fontFamily: "NotoSans",
                                            fontSize: MediaQuery.of(context).size.height/37,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/55,),
                            ///Student name Text field and Select standard dropdown row
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child:SizedBox(
                                        height: MediaQuery.of(context).size.height/14,
                                        width: MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                                          child: TextFormField(
                                            controller: studentNameController,
                                            cursorColor: Colors.black26,
                                            style:  TextStyle(
                                                fontFamily: "NotoSans",
                                                fontSize: MediaQuery.of(context).size.height/38,
                                                fontWeight: FontWeight.bold

                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z ]')),
                                              LengthLimitingTextInputFormatter(50),
                                              TextInputFormatter.withFunction((oldValue, newValue) {
                                                String trimmedText = newValue.text.trimLeft();
                                                final cursorOffset = newValue.selection.baseOffset - (newValue.text.length - trimmedText.length);
                                                return TextEditingValue(
                                                  text: trimmedText,
                                                  selection: TextSelection.collapsed(offset: cursorOffset),
                                                );
                                              }),
                                            ],
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:MediaQuery.of(context).size.width/70),
                                              isDense: false,

                                              border:OutlineInputBorder(

                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:  Colors.black45
                                                  )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:   Colors.black45
                                                  )
                                              ),
                                              hintText: "Student Name",
                                              hintStyle:  TextStyle(
                                                fontFamily: "NotoSans",
                                                fontWeight: FontWeight.w300,
                                                fontSize: MediaQuery.of(context).size.height/45,
                                              ),


                                            ),

                                            keyboardType: TextInputType.text,
                                            textCapitalization: TextCapitalization.words, // Capitalize the first letter of each word
                                            // You can add more properties like validators, controllers, and onChanged as needed
                                          ),
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child:SizedBox(
                                        height: MediaQuery.of(context).size.height/14,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                                          child:  TextFormField(

                                            readOnly: true,
                                            style:  TextStyle(
                                                fontFamily: "NotoSans",
                                                fontSize: MediaQuery.of(context).size.height/38,
                                                fontWeight: FontWeight.bold

                                            ),
                                            cursorColor: Colors.black26,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:MediaQuery.of(context).size.width/70),
                                              isDense: false,


                                              border:OutlineInputBorder(

                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:  Colors.black45
                                                  )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:   Colors.black45
                                                  )
                                              ),
                                              hintText: posSelectedStandard.value,
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "NotoSans",
                                                fontSize: MediaQuery.of(context).size.height/45,
                                              )),
                                            keyboardType: TextInputType.text,
                                            textCapitalization: TextCapitalization.words, // Capitalize the first letter of each word
                                            // You can add more properties like validators, controllers, and onChanged as needed
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/35),
                            ///select div label
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RichText(
                                      text:TextSpan(
                                          text: "Select Division",
                                          style:  TextStyle(
                                              color: const Color(0xFF3B3B3B),
                                              fontFamily: "NotoSans",
                                              fontSize: MediaQuery.of(context).size.height/37,
                                              fontWeight: FontWeight.bold),

                                      ) ,

                                    ),
                                  ),

                                ],
                              ),
                            ),


                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child:SizedBox(
                                        height: MediaQuery.of(context).size.height/14,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                                          child:  Obx(() => DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text("Select Division",
                                                  style: TextStyle(
                                                    fontFamily: "NotoSans",
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: MediaQuery.of(context).size.height/45,
                                                  )),
                                                items:
                                                divisionVM.divisionList.map((item) => DropdownMenuItem<String>(
                                                  value: item.id.toString(),
                                                  child: Text(
                                                      item.text.toString(),
                                                      style:TextStyle(
                                                          fontSize: MediaQuery.of(context).size.height/40,
                                                          fontFamily: "NotoSans",
                                                          color:   Colors.black,
                                                          fontWeight: FontWeight.w400
                                                      )
                                                  ),
                                                ))
                                                    .toList(),
                                                value: selectedDiv.value == 'Select Division' ? null : selectedDiv.value,
                                                onChanged: (String? value) {

                                                  if (value != null) {
                                                    selectedDiv.value = value;
                                                    posDivId = int.parse(value);

                                                  }// Use the controller to set the value
                                                },
                                                buttonStyleData:  ButtonStyleData(
                                                  padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/50),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    border: Border.all(color: (

                                                        Colors.black45
                                                    )

                                                    ),),

                                                  height: MediaQuery.of(context).size.height / 14,
                                                  width: MediaQuery.of(context).size.width/2.5,
                                                ),

                                                dropdownStyleData: DropdownStyleData(
                                                    maxHeight: MediaQuery.of(context).size.height/2.5,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black45,width:2)
                                                    )),
                                                menuItemStyleData: MenuItemStyleData(

                                                  height: MediaQuery.of(context).size.height/15,
                                                ),
                                              ),
                                            )),
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child:SizedBox(
                                        height: MediaQuery.of(context).size.height/10,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/60),
                                          child: const Text(""),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/70,),
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/50),
                              child: Row(
                                children: [
                                  const Expanded(
                                      flex: 2,
                                      child: Text("")),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          GestureDetector(
                                            onTap: () {
                                              parentNameController.clear();
                                              studentNameController.clear();
                                              parentMobController.clear();
                                              selectedDiv.value = 'Select Division';


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
                                                        "Clear",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                            fontSize:
                                                            MediaQuery.of(context).size.height /40,
                                                            fontFamily: "NotoSans",
                                                            color:   Colors.black54),
                                                      )),
                                                )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/50,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (parentNameController.text.isEmpty) {
                                                snackbar(context, "Enter parent's name");
                                              } else if (!isParentNameValid(parentNameController.text)) {
                                                snackbar(context, "Enter min 3 characters of parent's name ");
                                              } else if (parentMobController.text.isEmpty) {
                                                snackbar(context, "Enter mobile number");
                                              } else if (parentMobController.text.startsWith("0") ||
                                                  parentMobController.text.startsWith("1") ||
                                                  parentMobController.text.startsWith("2") ||
                                                  parentMobController.text.startsWith("3") ||
                                                  parentMobController.text.startsWith("4") ||
                                                  parentMobController.text.startsWith("5")) {
                                                snackbar(context, "Enter valid mobile number");
                                              } else if (parentMobController.text.length < 10) {
                                                snackbar(context, "Enter valid mobile number");
                                              } else if (studentNameController.text.isEmpty) {
                                                snackbar(context, "Enter student name");
                                              }else if (!isParentNameValid(studentNameController.text)) {
                                                snackbar(context, "Enter min 3 characters of student name");
                                              } else if (posSelectedStandard.value == "") {
                                                snackbar(context, "Standard is not selected");
                                              }

                                              else {
                                                addCustomerAPI(context);
                                              }
                                            },
                                            child: Center(
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height /15,
                                                  width: MediaQuery.of(context).size.width /8,
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
                                                      borderRadius: BorderRadius.circular(5)),
                                                  child: Center(
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                            fontSize:
                                                            MediaQuery.of(context).size.height /40,
                                                            fontFamily: "NotoSans",
                                                            color: Colors.white),
                                                      )),
                                                )),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )



                          ]),
                    ),
                  ),
                ),
            ),
          ),
        );
      });
}





