import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/schoolSales_L1.dart';
import 'package:tuck_shop/view/reports/schoolSales_L2.dart';
import 'package:tuck_shop/view/reports/schoolSales_L3.dart';
import 'package:tuck_shop/view/reports/transaction_history.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utility/base_url.dart';
import '../../view_modal/reports/salesBySchool_Level1Vm.dart';
import '../../view_modal/reports/salesBySchool_Level2Vm.dart';
import '../../view_modal/reports/salesBySchool_Level3Vm.dart';
import '../common_widgets/progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

import '../common_widgets/snack_bar.dart';


bool? salesBookClick;
int? salesSchoolIdL1;
String? salesSchoolName;
String? salesSchoolStd;
int? salesSchoolStdId;
String? salesSchoolLocation;
double? salesSchoolTotalSales;

TextEditingController salesBySchoolL1Controller = TextEditingController();
TextEditingController salesBySchoolL2Controller = TextEditingController();
TextEditingController salesBySchoolL3Controller = TextEditingController();


String? selectedSchool;
int? selectedSchoolId;
String? selectedStd;
int? selectedStdId;
String? selectedDiv;
int? selectedDivId;
String? selectedTime;
int? timeId;

final salesBySchoolLevel1Vm = Get.put(SalesBySchoolLevel1Vm());
final salesBySchoolL2Vm = Get.put(SalesBySchoolL2Vm());
final salesBySchoolL3Vm = Get.put(SalesBySchoolL3Vm());
class ListViewSwitcher extends StatefulWidget {
  @override
  _ListViewSwitcherState createState() => _ListViewSwitcherState();
}

class _ListViewSwitcherState extends State<ListViewSwitcher> {
  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  final GlobalKey<ScaffoldState> _scaffoldKeys =  GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  List<int> _history = [];

  late Timer _debounce;
  late DateTime fromDate;
  late DateTime toDate;
  late String selectedOption;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _debounce = Timer(const Duration(milliseconds: 500), () {});
    fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    selectedOption = 'This Month';
  }
  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }

  bool isFromDateSelectable = false;
  bool isToDateSelectable = false;
  Future<void> selectDate(BuildContext context, bool isFrom) async {
    DateTime initialDate = isFrom ? fromDate : toDate;
    if (isFrom && initialDate == DateTime(DateTime.now().year, DateTime.now().month, 1)) {
      initialDate = DateTime.now();
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isFrom ? DateTime(2000) : (isFromDateSelectable ? fromDate : DateTime.now()),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff5448D2),
              colorScheme: const ColorScheme.light(primary: Color(0xff5448D2)),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          isToDateSelectable = true; // Update the flag when the From date changes
        } else {
          if (picked.isAfter(fromDate) || picked.isAtSameMomentAs(fromDate)) {
            toDate = picked;
          } else {
            // Show error message or handle invalid date selection
            // Here we reset to the default value (if needed)
            toDate = fromDate;
            // You can also display a snackbar or show an error message
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please select a date after or equal to From date'),
            ));
          }
        }
      });
    }
  }

  void setDateRange(String option) {
    setState(() {
      selectedOption = option;
      isFromDateSelectable = option == 'Custom Date';
      if (option != 'Custom Date') {
        if (option == 'This Month') {
          fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
          toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (option == 'Last Month') {
          fromDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
          toDate = DateTime(DateTime.now().year, DateTime.now().month, 0);
        } else if (option == 'This Quarter') {
          int currentMonth = DateTime.now().month;
          int quarterStartMonth = ((currentMonth - 1) ~/ 3) * 3 + 1;
          fromDate = DateTime(DateTime.now().year, quarterStartMonth, 1);
          toDate = DateTime(DateTime.now().year, quarterStartMonth + 3, 0);
        } else if (option == 'Last Quarter') {
          int currentMonth = DateTime.now().month;
          int lastQuarterStartMonth = (((currentMonth - 1) ~/ 3) - 1) * 3 + 1;
          fromDate = DateTime(DateTime.now().year, lastQuarterStartMonth, 1);
          toDate = DateTime(DateTime.now().year, lastQuarterStartMonth + 3, 0);
        }
        isToDateSelectable = false; // Reset the flag
      }
    });
  }
  void clearDates() {
    setState(() {
      fromDate = DateTime.now();
      toDate = DateTime.now();
      isToDateSelectable = false;
    });
  }
  String? storedFromDate;
  String? storedToDate;


/// _currentIndex == 0?'schoolLevel1':_currentIndex == 1?'schoolLevel2':'schoolLevel3'
  Future<void> downloadExcel1() async {
    // String baseUrl = 'http://pos-test.shauryatechnosoft.com/excel-download-for-app';
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getInt('userId')!);
    Map<String, dynamic> obj = {
      'pageName': 'schoolLevel1',
      'UserId': pref.getInt('userId')!,
      'SchoolId': selectedSchoolId == null? 0 : selectedSchoolId!,
      'SchoolName': '',
      'StdId': selectedStdId == null? 0 : selectedStdId!,
      'standard': '',
      'DivId': selectedDivId == null? 0 : selectedDivId!,
      'division': '',
      'Time': timeId == null? 0 : timeId!,
      'OrderId': '',
      'InvoiceId': '',
      'FromDate': storedFromDate == null ? "":storedFromDate!,
      'ToDate': storedToDate == null ? "":storedToDate!,
      'BookSetId': 0,
      'BookSetName':'',
      'PageNo': 1,
      'PageSize': 10,
      'TextSearch': salesBySchoolL1Controller.text.isEmpty?"":salesBySchoolL1Controller.text,
    };

    // Convert data to JSON
    String jsonData = json.encode(obj);

    // Encrypt JSON data
    String encryptedData = encryptData(jsonData);

    // Construct URL with encrypted data as query parameter
    String url = '$excelBaseUrl?id=${Uri.encodeComponent(encryptedData)}';

    // Send request to the server
    try {
      http.Response response = await http.get(Uri.parse(url));

      // Check response status code
      if (response.statusCode == 200) {
        toastMessage(context, 'Excel sheet is being downloaded!');
        print(obj);
        // Success
        print('URI: $url');
        print('Excel downloaded successfully');

        // After successful download, launch the URL in the default browser
        await launch(url);
      } else {
        // Failed
        print('Failed to download Excel. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error
      print('Failed to download Excel. Error: $e');
    }
  }
  Future<void> downloadExcel2() async {
    // String baseUrl = 'http://pos-test.shauryatechnosoft.com/excel-download-for-app';
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getInt('userId')!);
    Map<String, dynamic> obj = {
      'pageName': 'schoolLevel2',
      'UserId': pref.getInt('userId')!,
      'SchoolId': selectedSchoolId == null? salesSchoolIdL1! : selectedSchoolId!,
      'SchoolName': '',
      'StdId': selectedStdId == null? 0 : selectedStdId!,
      'standard': '',
      'DivId': selectedDivId == null? 0 : selectedDivId!,
      'division': '',
      'Time': timeId == null? 0 : timeId!,
      'OrderId': '',
      'InvoiceId': '',
      'FromDate': storedFromDate == null ? "":storedFromDate!,
      'ToDate': storedToDate == null ? "":storedToDate!,
      'BookSetId': 0,
      'BookSetName':'',
      'PageNo': 1,
      'PageSize': 10,
      'TextSearch': salesBySchoolL2Controller.text.isEmpty?"":salesBySchoolL2Controller.text,
    };

    // Convert data to JSON
    String jsonData = json.encode(obj);

    // Encrypt JSON data
    String encryptedData = encryptData(jsonData);

    // Construct URL with encrypted data as query parameter
    String url = '$excelBaseUrl?id=${Uri.encodeComponent(encryptedData)}';

    // Send request to the server
    try {
      http.Response response = await http.get(Uri.parse(url));

      // Check response status code
      if (response.statusCode == 200) {
        toastMessage(context, 'Excel sheet is being downloaded!');
        print(obj);
        // Success
        print('URI: $url');
        print('Excel downloaded successfully');

        // After successful download, launch the URL in the default browser
        await launch(url);
      } else {
        // Failed
        print('Failed to download Excel. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error
      print('Failed to download Excel. Error: $e');
    }
  }
  Future<void> downloadExcel3() async {
    // String baseUrl = 'http://pos-test.shauryatechnosoft.com/excel-download-for-app';
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getInt('userId')!);
    Map<String, dynamic> obj = {
      'pageName': 'schoolLevel3',
      'UserId': pref.getInt('userId')!,
      'SchoolId': selectedSchoolId == null? salesSchoolIdL1! : selectedSchoolId!,
      'SchoolName': '',
      'StdId': selectedStdId == null? salesSchoolStdId! : selectedStdId!,
      'standard': '',
      'DivId': selectedDivId == null? 0 : selectedDivId!,
      'division': '',
      'Time': timeId == null? 0 : timeId!,
      'OrderId': '',
      'InvoiceId': '',
      'FromDate': storedFromDate == null ? "":storedFromDate!,
      'ToDate': storedToDate == null ? "":storedToDate!,
      'BookSetId': 0,
      'BookSetName':'',
      'PageNo': 1,
      'PageSize': 10,
      'TextSearch': salesBySchoolL3Controller.text.isEmpty?"":salesBySchoolL3Controller.text,
    };

    // Convert data to JSON
    String jsonData = json.encode(obj);

    // Encrypt JSON data
    String encryptedData = encryptData(jsonData);

    // Construct URL with encrypted data as query parameter
    String url = '$excelBaseUrl?id=${Uri.encodeComponent(encryptedData)}';

    // Send request to the server
    try {
      http.Response response = await http.get(Uri.parse(url));

      // Check response status code
      if (response.statusCode == 200) {
        toastMessage(context, 'Excel sheet is being downloaded!');
        print(obj);
        // Success
        print('URI: $url');
        print('Excel downloaded successfully');

        // After successful download, launch the URL in the default browser
        await launch(url);
      } else {
        // Failed
        print('Failed to download Excel. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error
      print('Failed to download Excel. Error: $e');
    }
  }

  String encryptData(String data) {
    final key = encrypt.Key.fromUtf8(encryptionKey);
    final iv = encrypt.IV.fromUtf8(encryptionKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);
    final base64Encoded = encrypted.base64;
    return Uri.encodeFull(base64Encoded);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      if (_history.isNotEmpty) {
        setState(() {
          _currentIndex = _history.removeLast();
          print("-------$_currentIndex");
        });
      }
      return false;
      },
      child: Scaffold(
        key: _scaffoldKeys,

        ///L2
        endDrawer: _currentIndex == 1?Drawer(
            width: MediaQuery.of(context).size.width/2.95,
            child:  Obx(
                    () => ModalProgressHUD(
                    inAsyncCall:orderHistorySchoolStandardDropdownVM.isLoading.value == true
                        || orderHistorySchoolDivisionVm.isLoading.value == true,
                    progressIndicator: progressIndicator(),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/70,
                            vertical: MediaQuery.of(context).size.height/80),
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    _scaffoldKeys.currentState?.closeEndDrawer();
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: const Color(0xffE0DDFC),
                                      minRadius: MediaQuery.of(context).size.height/50,
                                      child: const Icon(
                                          Icons.close,color: Color(0xFF4D3FD9),
                                          size: 28)
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/1.73,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/100),
                                      child: ListView(
                                        children: [
                                          ///select time Dropdown
                                          Text(
                                            'Select Time',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.0)),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "This Month",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedTime,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistoryTimerFilterVm.ohTimerFilterDropListVm.map((time) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            clearDates();
                                                            timeId = time.id;
                                                            selectedTime = null;
                                                          },
                                                          value: time.text.toString(),
                                                          child: Text(
                                                            time.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          ))
                                                  ).toList(),
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      isToDateSelectable = false;
                                                      setDateRange(newValue);
                                                      selectedTime = newValue;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Date
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Text(
                                              'Select Date',
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height / 45,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'NatoSans',
                                                  color: const Color(0xff3B3B3B)),
                                            ),
                                          ),
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height / 80,
                                                  bottom: MediaQuery.of(context).size.height / 100),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: isFromDateSelectable ? () => selectDate(context, true) : null,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80, horizontal: MediaQuery.of(context).size.width/80),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(DateFormat('dd-MM-yyyy').format(fromDate)),
                                                            const Icon(Icons.calendar_month_rounded),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: isToDateSelectable ? () => selectDate(context, false) : null,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80, horizontal: MediaQuery.of(context).size.width/80),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(DateFormat('dd-MM-yyyy').format(toDate)),
                                                            const Icon(Icons.calendar_month_rounded),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ///Select School Dropdown
                                          Text(
                                            'Select School',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select School",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedSchool,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolDropdownVM.ohSchoolDropListVm.map((school) =>DropdownMenuItem<String>(
                                                      onTap: () async{
                                                        selectedSchoolId = school.id;
                                                        if(selectedSchoolId != null){
                                                          selectedDiv = null;
                                                          selectedStd = null;
                                                          orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                                          orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                                          orderHistorySchoolStandardDropdownVM.isLoading.value = true;
                                                          orderHistorySchoolStandardDropdownVM.getOhSchoolStandardDropdown(context,selectedSchoolId!);
                                                        }

                                                        print(selectedSchoolId);
                                                      },
                                                      value: school.schools,
                                                      child: Text(
                                                        school.schools.toString(),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.height / 35,
                                                            fontFamily: "NatoSans",
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400),
                                                      )) ).toList(),
                                                  onChanged: (school) {
                                                    setState(() {
                                                      selectedSchool = school;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Standard Dropdown
                                          Text(
                                            'Select Standard',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select Standard",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedStd,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.map((std) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            selectedStdId = std.id;
                                                            print(selectedStdId);
                                                            if(selectedStdId != null){
                                                              setState(() {
                                                                selectedDiv = null;
                                                                orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                                                orderHistorySchoolDivisionVm.isLoading.value = true;
                                                                orderHistorySchoolDivisionVm.getOhSchoolDivisionDropdown(selectedStdId!);
                                                              });
                                                            }
                                                          },
                                                          value: std.text,
                                                          child: Text(
                                                            std.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          )
                                                      )
                                                  ).toList(),
                                                  onChanged: (std) {
                                                    setState(() {
                                                      selectedStd = std;
                                                      print(selectedStd);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Division Dropdown
                                          Text(
                                            'Select Division',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select Division",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedDiv,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.map((div) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            selectedDivId = div.id;
                                                            print(selectedDivId);
                                                          },
                                                          value: div.text,
                                                          child: Text(
                                                            div.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          )
                                                      )
                                                  ).toList(),
                                                  onChanged: (div) {
                                                    setState(() {
                                                      selectedDiv = div;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height/80
                                        )),
                                    height: MediaQuery.of(context).size.height/15,
                                    color: const Color.fromRGBO(115, 103, 240, 1),
                                    minWidth: double.infinity,
                                    onPressed: () async {
                                      storedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
                                      storedToDate = DateFormat('yyyy-MM-dd').format(toDate);
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      salesBySchoolL2Vm.getSchoolSales2List.clear();
                                      salesBySchoolL2Vm.isLoading.value = true;
                                      salesBySchoolL2Vm.getSchoolSalesDetails2(pref.getInt('userId')!,selectedSchoolId == null?0:selectedSchoolId!,selectedStdId == null?0:selectedStdId!,selectedStdId == null?0:selectedStdId!,storedFromDate!,storedToDate!);
                                      setState(() {
                                        // selectedSchool = null;
                                        // selectedStd = null;
                                        // selectedStd = null;
                                        Get.back();
                                      });
                                    },
                                    child:  Text('Apply',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NatoSans',
                                        fontSize: MediaQuery.of(context).size.height/45)))
                              ],
                            ),
                          ],
                        )))))



        ///L3
            :_currentIndex==2?Drawer(
            width: MediaQuery.of(context).size.width/2.95,
            child:  Obx(
                    () => ModalProgressHUD(
                    inAsyncCall:orderHistorySchoolStandardDropdownVM.isLoading.value == true
                        || orderHistorySchoolDivisionVm.isLoading.value == true,
                    progressIndicator: progressIndicator(),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/70,
                            vertical: MediaQuery.of(context).size.height/80),
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    _scaffoldKeys.currentState?.closeEndDrawer();
                                    selectedSchool = null;
                                    selectedStd = null;
                                    selectedStd = null;
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                    orderHistorySchoolDropdownVM.ohSchoolDropListVm.clear();
                                    orderHistorySchoolDropdownVM.isLoading.value = true;
                                    await orderHistorySchoolDropdownVM.getSchoolDropdown(pref.getInt('userId')!);
                                    orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: const Color(0xffE0DDFC),
                                      minRadius: MediaQuery.of(context).size.height/50,
                                      child: const Icon(
                                          Icons.close,color: Color(0xFF4D3FD9),
                                          size: 28)
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/1.73,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/100),
                                      child: ListView(
                                        children: [
                                          ///select time Dropdown
                                          Text(
                                            'Select Time',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.0)),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "This Month",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedTime,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistoryTimerFilterVm.ohTimerFilterDropListVm.map((time) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            clearDates();
                                                            timeId = time.id;
                                                            selectedTime = null;
                                                          },
                                                          value: time.text.toString(),
                                                          child: Text(
                                                            time.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          ))
                                                  ).toList(),
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      isToDateSelectable = false;
                                                      setDateRange(newValue);
                                                      selectedTime = newValue;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Date
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Text(
                                              'Select Date',
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height / 45,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'NatoSans',
                                                  color: const Color(0xff3B3B3B)),
                                            ),
                                          ),
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height / 80,
                                                  bottom: MediaQuery.of(context).size.height / 100),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: isFromDateSelectable ? () => selectDate(context, true) : null,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80, horizontal: MediaQuery.of(context).size.width/80),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(DateFormat('dd-MM-yyyy').format(fromDate)),
                                                            const Icon(Icons.calendar_month_rounded),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: isToDateSelectable ? () => selectDate(context, false) : null,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80, horizontal: MediaQuery.of(context).size.width/80),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(DateFormat('dd-MM-yyyy').format(toDate)),
                                                            const Icon(Icons.calendar_month_rounded),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ///Select School Dropdown
                                          Text(
                                            'Select School',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select School",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedSchool,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolDropdownVM.ohSchoolDropListVm.map((school) =>DropdownMenuItem<String>(
                                                      onTap: () async{
                                                        selectedSchoolId = school.id;
                                                        if(selectedSchoolId != null){
                                                          selectedDiv = null;
                                                          selectedStd = null;
                                                          orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                                          orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                                          orderHistorySchoolStandardDropdownVM.isLoading.value = true;
                                                          orderHistorySchoolStandardDropdownVM.getOhSchoolStandardDropdown(context,selectedSchoolId!);
                                                        }

                                                        print(selectedSchoolId);
                                                      },
                                                      value: school.schools,
                                                      child: Text(
                                                        school.schools.toString(),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.height / 35,
                                                            fontFamily: "NatoSans",
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400),
                                                      )) ).toList(),
                                                  onChanged: (school) {
                                                    setState(() {
                                                      selectedSchool = school;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Standard Dropdown
                                          Text(
                                            'Select Standard',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select Standard",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedStd,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.map((std) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            selectedStdId = std.id;
                                                            print(selectedStdId);
                                                            if(selectedStdId != null){
                                                              setState(() {
                                                                selectedDiv = null;
                                                                orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                                                orderHistorySchoolDivisionVm.isLoading.value = true;
                                                                orderHistorySchoolDivisionVm.getOhSchoolDivisionDropdown(selectedStdId!);
                                                              });
                                                            }
                                                          },
                                                          value: std.text,
                                                          child: Text(
                                                            std.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          )
                                                      )
                                                  ).toList(),
                                                  onChanged: (std) {
                                                    setState(() {
                                                      selectedStd = std;
                                                      print(selectedStd);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Division Dropdown
                                          Text(
                                            'Select Division',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select Division",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedDiv,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.map((div) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            selectedDivId = div.id;
                                                            print(selectedDivId);
                                                          },
                                                          value: div.text,
                                                          child: Text(
                                                            div.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          )
                                                      )
                                                  ).toList(),
                                                  onChanged: (div) {
                                                    setState(() {
                                                      selectedDiv = div;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height/80
                                        )),
                                    height: MediaQuery.of(context).size.height/15,
                                    color: const Color.fromRGBO(115, 103, 240, 1),
                                    minWidth: double.infinity,
                                    onPressed: () async {
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      salesBySchoolL3Vm.getSchoolSales3List.clear();
                                      salesBySchoolL3Vm.isLoading.value = true;
                                      await salesBySchoolL3Vm.getSchoolSalesDetails2(pref.getInt('userId')!,selectedSchoolId == null?0:selectedSchoolId!,selectedStdId == null?0:selectedStdId!,selectedStdId == null?0:selectedStdId!,storedFromDate!,storedToDate!);
                                      setState(() {
                                        // selectedSchool = null;
                                        // selectedStd = null;
                                        // selectedStd = null;
                                        Get.back();
                                      });
                                    },
                                    child:  Text('Apply',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NatoSans',
                                        fontSize: MediaQuery.of(context).size.height/45)))
                              ],
                            ),
                          ],
                        )))))





        ///L1
            :Drawer(
            width: MediaQuery.of(context).size.width/2.95,
            child:  Obx(
                    () => ModalProgressHUD(
                    inAsyncCall:orderHistorySchoolStandardDropdownVM.isLoading.value == true
                        || orderHistorySchoolDivisionVm.isLoading.value == true,
                    progressIndicator: progressIndicator(),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/70,
                            vertical: MediaQuery.of(context).size.height/80),
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    _scaffoldKeys.currentState?.closeEndDrawer();
                                    selectedSchool = null;
                                    selectedStd = null;
                                    selectedStd = null;
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                    orderHistorySchoolDropdownVM.ohSchoolDropListVm.clear();
                                    orderHistorySchoolDropdownVM.isLoading.value = true;
                                    await orderHistorySchoolDropdownVM.getSchoolDropdown(pref.getInt('userId')!);
                                    orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: const Color(0xffE0DDFC),
                                      minRadius: MediaQuery.of(context).size.height/50,
                                      child: const Icon(
                                          Icons.close,color: Color(0xFF4D3FD9),
                                          size: 28)
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/1.73,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/100),
                                      child: ListView(
                                        children: [
                                          ///select time Dropdown
                                          Text(
                                            'Select Time',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.0)),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "This Month",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedTime,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistoryTimerFilterVm.ohTimerFilterDropListVm.map((time) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            clearDates();
                                                            timeId = time.id;
                                                            selectedTime = null;
                                                          },
                                                          value: time.text.toString(),
                                                          child: Text(
                                                            time.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          ))
                                                  ).toList(),
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      isToDateSelectable = false;
                                                      setDateRange(newValue);
                                                      selectedTime = newValue;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Date
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Text(
                                              'Select Date',
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height / 45,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'NatoSans',
                                                  color: const Color(0xff3B3B3B)),
                                            ),
                                          ),
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height / 80,
                                                  bottom: MediaQuery.of(context).size.height / 100),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: isFromDateSelectable ? () => selectDate(context, true) : null,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80, horizontal: MediaQuery.of(context).size.width/80),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(DateFormat('dd-MM-yyyy').format(fromDate)),
                                                            const Icon(Icons.calendar_month_rounded),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: isToDateSelectable ? () => selectDate(context, false) : null,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80, horizontal: MediaQuery.of(context).size.width/80),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(DateFormat('dd-MM-yyyy').format(toDate)),
                                                            const Icon(Icons.calendar_month_rounded),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ///Select School Dropdown
                                          Text(
                                            'Select School',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select School",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedSchool,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolDropdownVM.ohSchoolDropListVm.map((school) =>DropdownMenuItem<String>(
                                                      onTap: () async{
                                                        selectedSchoolId = school.id;
                                                        if(selectedSchoolId != null){
                                                          selectedDiv = null;
                                                          selectedStd = null;
                                                          orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                                          orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                                          orderHistorySchoolStandardDropdownVM.isLoading.value = true;
                                                          orderHistorySchoolStandardDropdownVM.getOhSchoolStandardDropdown(context,selectedSchoolId!);
                                                        }

                                                        print(selectedSchoolId);
                                                      },
                                                      value: school.schools,
                                                      child: Text(
                                                        school.schools.toString(),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.height / 35,
                                                            fontFamily: "NatoSans",
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400),
                                                      )) ).toList(),
                                                  onChanged: (school) {
                                                    setState(() {
                                                      selectedSchool = school;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Standard Dropdown
                                          Text(
                                            'Select Standard',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select Standard",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedStd,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.map((std) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            selectedStdId = std.id;
                                                            print(selectedStdId);
                                                            if(selectedStdId != null){
                                                              setState(() {
                                                                selectedDiv = null;
                                                                orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                                                orderHistorySchoolDivisionVm.isLoading.value = true;
                                                                orderHistorySchoolDivisionVm.getOhSchoolDivisionDropdown(selectedStdId!);
                                                              });
                                                            }
                                                          },
                                                          value: std.text,
                                                          child: Text(
                                                            std.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          )
                                                      )
                                                  ).toList(),
                                                  onChanged: (std) {
                                                    setState(() {
                                                      selectedStd = std;
                                                      print(selectedStd);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Select Division Dropdown
                                          Text(
                                            'Select Division',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height / 45,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NatoSans',
                                                color: const Color(0xff3B3B3B)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height / 80,
                                                bottom: MediaQuery.of(context).size.height / 100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Adjust the border radius as needed
                                              ),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  iconStyleData: const IconStyleData(
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      openMenuIcon: Icon(Icons.arrow_drop_up)),
                                                  hint: Text(
                                                    "Select Division",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NatoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                  value: selectedDiv,
                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity,
                                                  ),
                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey, width: 1.5))),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15,
                                                  ),
                                                  items: orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.map((div) =>
                                                      DropdownMenuItem<String>(
                                                          onTap: () {
                                                            selectedDivId = div.id;
                                                            print(selectedDivId);
                                                          },
                                                          value: div.text,
                                                          child: Text(
                                                            div.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NatoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400),
                                                          )
                                                      )
                                                  ).toList(),
                                                  onChanged: (div) {
                                                    setState(() {
                                                      selectedDiv = div;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height/80
                                        )),
                                    height: MediaQuery.of(context).size.height/15,
                                    color: const Color.fromRGBO(115, 103, 240, 1),
                                    minWidth: double.infinity,
                                    onPressed: () async {
                                      storedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
                                      storedToDate = DateFormat('yyyy-MM-dd').format(toDate);
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      salesBySchoolLevel1Vm.getSchoolSalesLevel1List.clear();
                                      salesBySchoolLevel1Vm.isLoading.value = true;
                                      await salesBySchoolLevel1Vm.getSchoolSalesDetails(pref.getInt('userId')!,selectedSchoolId == null?0:selectedSchoolId!,selectedStdId == null?0:selectedStdId!,selectedStdId == null?0:selectedStdId!,storedFromDate!,storedToDate!,"");
                                      setState(() {
                                        // selectedSchool = null;
                                        // selectedStd = null;
                                        // selectedStd = null;
                                        Get.back();
                                      });
                                    },
                                    child:  Text('Apply',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NatoSans',
                                        fontSize: MediaQuery.of(context).size.height/45)))
                              ],
                            ),
                          ],
                        ))))),





        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 130,
                  horizontal: MediaQuery.of(context).size.width / 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentIndex ==0?RichText(text: TextSpan(children: [
                        TextSpan(
                            text: 'Reports >> ',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height / 33,
                                color: Colors.black,
                                fontFamily: "NotoSansSemiBold",
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'Sales By School',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height / 33,
                                color: const Color(0xff5448D2),
                                fontFamily: "NotoSansSemiBold",
                                fontWeight: FontWeight.bold)),
                      ])):_currentIndex == 1?
                  RichText(text: TextSpan(children: [
                    TextSpan(
                        text: 'Reports >> Sales By School >> ',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 33,
                            color: Colors.black,
                            fontFamily: "NotoSansSemiBold",
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: salesSchoolName!,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 33,
                            color: const Color(0xff5448D2),
                            fontFamily: "NotoSansSemiBold",
                            fontWeight: FontWeight.bold)),
                  ])):_currentIndex == 2?
                  RichText(text: TextSpan(children: [
                    TextSpan(
                        text: 'Reports >> Sales By School >> ${salesSchoolName!} >> ',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 33,
                            color: Colors.black,
                            fontFamily: "NotoSansSemiBold",
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: salesSchoolStd!,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 33,
                            color: const Color(0xff5448D2),
                            fontFamily: "NotoSansSemiBold",
                            fontWeight: FontWeight.bold)),
                  ]))
                  :const Text(""),
                        _currentIndex == 0?const Text(""):InkWell(
                          onTap: () {
                        if (_history.isNotEmpty) {
                          setState(() {
                            _currentIndex = _history.removeLast();
                            print("-------$_currentIndex");
                          });
                          }
                        },
                        child: Text('<< Back',style: TextStyle(
                          color: const Color(0xff5448D2),
                          fontFamily: "NotoSansSemiBold",
                          fontSize: MediaQuery.of(context).size.height / 33,
                          fontWeight: FontWeight.bold))),
                ],
              )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/80,horizontal: MediaQuery.of(context).size.width/80),
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                decoration:  BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.06),
                        blurRadius: 3,
                        spreadRadius: 3,
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width/50,
                    vertical : MediaQuery.of(context).size.height/38),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                              controller: _currentIndex == 1?salesBySchoolL2Controller:_currentIndex == 2 ?salesBySchoolL3Controller:salesBySchoolL1Controller,
                              onChanged: (value) {
                                setState(() {
                                  // _currentIndex == 1? salesBySchoolFilterL2Books(value):_currentIndex == 2?salesBySchoolFilterL3Books(value):salesBySchoolFilterL1Books(value);
                                  _currentIndex == 1? salesBySchoolFilterL2Books(value):_currentIndex == 2?salesBySchoolFilterL3Books(value):
                                  _debounce.cancel();
                                  _debounce = Timer(const Duration(milliseconds: 550), () async {
                                    setState(() {

                                      salesBySchoolLevel1Vm.getSchoolSalesLevel1List.clear();
                                      salesBySchoolLevel1Vm.isLoading.value = true;

                                    });
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    await salesBySchoolLevel1Vm.getSchoolSalesDetails(pref.getInt('userId')!,0,0,0,"","",salesBySchoolL1Controller.text);

                                  });

                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height/90),
                                  hintText: _currentIndex == 1?'Search by Standard':_currentIndex == 2?'Search by Division':'Search by School or Location',
                                  hintStyle:  TextStyle(
                                      color: const Color.fromRGBO(129, 129, 129, 1),
                                      fontSize: MediaQuery.of(context).size.width/65,
                                      fontFamily: "NotoSans"
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset('assets/images/order_history_images/search.svg',
                                      height: 2,
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor:const Color.fromRGBO(243, 243, 243, 1),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none
                                  )))),
                      SizedBox(width: MediaQuery.of(context).size.width/40),
                      GestureDetector(
                          onTap: (){
                            _currentIndex == 0?downloadExcel1():_currentIndex == 1?downloadExcel2():downloadExcel3();
                          },
                          child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width/55,
                              backgroundColor: const Color(0xFFE0DDFC),
                              child: SvgPicture.asset("assets/images/dashboard_img/excel_icon.svg",height: MediaQuery.of(context).size.height/29))),
                      SizedBox(width: MediaQuery.of(context).size.width/40),
                      Builder(
                        builder: (BuildContext context) =>
                            InkWell(
                              onTap: () async {
                                selectedTime = null;
                                selectedSchool = null;
                                selectedStd = null;
                                selectedDiv = null;
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                orderHistorySchoolDropdownVM.ohSchoolDropListVm.clear();
                                orderHistorySchoolDropdownVM.isLoading.value = true;
                                await orderHistorySchoolDropdownVM.getSchoolDropdown(pref.getInt('userId')!);
                                orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                                toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                                selectedOption = 'This Month';
                                orderHistoryTimerFilterVm.ohTimerFilterDropListVm.clear();
                                orderHistoryTimerFilterVm.isLoading.value = true;
                                await orderHistoryTimerFilterVm.getOhTimerFilter();
                                setState(() {
                                  if (Scaffold.of(context).isEndDrawerOpen) {
                                    Navigator.of(context).pop();
                                  } else {
                                    Scaffold.of(context).openEndDrawer();
                                  }
                                });
                              },
                              child: CircleAvatar(
                                  radius: MediaQuery.of(context).size.width/55,
                                  backgroundColor: const Color(0xFFE0DDFC),
                                  child: SvgPicture.asset("assets/images/dashboard_img/filter_icon.svg")),
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildList(_currentIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(int index) {
    switch (index) {
      case 0:
        return FirstListWidget(
          onSwitch: (nextIndex) {
            setState(() {
              _history.add(_currentIndex);
              _currentIndex = nextIndex;
            });
          },
        );
      case 1:
        return SecondListWidget(onSwitch: (nextIndex) {
          setState(() {
            _history.add(_currentIndex);
            _currentIndex = nextIndex;
          });
        },);
      case 2:
        return ThirdListWidget();
      default:
        return Container();
    }
  }
}


