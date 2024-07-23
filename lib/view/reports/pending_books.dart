import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/pending_booksL1.dart';
import 'package:tuck_shop/view/reports/pending_booksL2.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';
import 'package:tuck_shop/view/reports/transaction_history.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utility/base_url.dart';
import '../../view_modal/reports/pending_level1Vm.dart';
import '../../view_modal/reports/pendingreportsLevel2Vm.dart';
import '../common_widgets/progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import '../common_widgets/snack_bar.dart';




bool pendingBookClick = false;
class PendingBooks extends StatefulWidget {
  const PendingBooks({Key? key}) : super(key: key);

  @override
  State<PendingBooks> createState() => _PendingBooksState();
}
final pendingLevel1Vm = Get.put(PendingLevel1Vm());
final pendingLevel2ReportVm = Get.put(PendingLevel2ReportVm());

apiCalling() async {
  salesBySchoolL1Controller.clear();
  salesBySchoolL2Controller.clear();
  salesBySchoolL3Controller.clear();
}

int? pendingLevel1SchoolId;
String? pendingLevel1Std;
String? pendingLevel1SchoolName;
String? pendingLevel1Location;
String? pendingLevel1BookSetName;
int? pendingLevel1QtyPending;
int? pendingLevel1BookSetID;

int? pendingLevel2SchoolId;
String? pendingLevel2Std;
String? pendingLevel2SchoolName;
String? pendingLevel2Location;
String? pendingLevel2BookSetName;
int? pendingLevel2QtyPending;
class _PendingBooksState extends State<PendingBooks> {

  /// dismiss keyboard
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pendingBookClick = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: PendingReportsListViewSwitcher(),
      ),
    );
  }
}


class PendingReportsListViewSwitcher extends StatefulWidget {
  @override
  _PendingReportsListViewSwitcherState createState() => _PendingReportsListViewSwitcherState();
}
final GlobalKey<ScaffoldState> _scaffoldKeys =  GlobalKey<ScaffoldState>();
class _PendingReportsListViewSwitcherState extends State<PendingReportsListViewSwitcher> {

bool? reportsTab;
  String? selectedSchool;
  int? selectedSchoolId;
  String? selectedStd;
  int? selectedStdId;
  String? selectedDiv;
  int? selectedDivId;
  String? selectedTime;
  int? timeId;

  String? storedFromDate;
  String? storedToDate;

TextEditingController pendingSearchController = TextEditingController();
  int _currentIndexes = 0;
  List<int> _history = [];

  /// dismiss keyboard
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  void _dismissKeyboard(BuildContext context) {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }
  late DateTime fromDate;
  late DateTime toDate;
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
        isToDateSelectable = false;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportsTab = true;
    fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    selectedOption = 'This Month';
  }

///'pageName': _currentIndexes == 0?'pendingBookLevel1':'pendingBookLevel2',
Future<void> downloadExcel1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> obj = {
    'pageName': 'pendingBookLevel1',
    'UserId': pref.getInt('userId')!,
    'SchoolId': selectedSchoolId == null? 0 : selectedSchoolId!,
    'SchoolName': '',
    'StdId': selectedStdId == null? 0 : selectedStdId!,
    'standard': '',
    'DivId': selectedDivId == null? 0 :  selectedDivId!,
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
    'TextSearch': pendingSearchController.text,
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
      await launch(url);
    } else {
      // Failed
      if (kDebugMode) {
        print('Failed to download Excel. Server responded with status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    // Error
    if (kDebugMode) {
      print('Failed to download Excel. Error: $e');
    }
  }
}
Future<void> downloadExcel2() async {

  SharedPreferences pref = await SharedPreferences.getInstance();

  Map<String, dynamic> obj = {
    'pageName': 'pendingBookLevel2',
    'UserId': pref.getInt('userId')!,
    'SchoolId': selectedSchoolId == null? pendingLevel1SchoolId! : selectedSchoolId!,
    'SchoolName': pendingLevel1SchoolName!,
    'StdId': selectedStdId == null? 0 : selectedStdId!,
    'standard': '',
    'DivId': selectedDivId == null? 0 : selectedDivId!,
    'division': '',
    'Time': timeId == null? 0 : timeId!,
    'OrderId': '',
    'InvoiceId': '',
    'FromDate': storedFromDate == null ? "":storedFromDate!,
    'ToDate': storedToDate == null ? "":storedToDate!,
    'BookSetId': pendingLevel1BookSetID == null? 0 : pendingLevel1BookSetID!,
    'BookSetName':'',
    'PageNo': 1,
    'PageSize': 10,
    'TextSearch': pendingSearchController.text,
  };

  String jsonData = json.encode(obj);
  String encryptedData = encryptData(jsonData);
  String url = '$excelBaseUrl?id=${Uri.encodeComponent(encryptedData)}';
  try {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      toastMessage(context, 'Excel sheet is being downloaded!');
      await launch(url);
    } else {
      // Failed
      if (kDebugMode) {
        print('Failed to download Excel. Server responded with status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    // Error
    if (kDebugMode) {
      print('Failed to download Excel. Error: $e');
    }
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
              _currentIndexes = _history.removeLast();
              pendingBookClick = false;
              pendingSearchController.clear();
            });
          }
          return false;
        },
      child: GestureDetector(
          onTap: (){
            _dismissKeyboard(context);
          },
        child: Scaffold(
          key: _scaffoldKeys,
          endDrawer: pendingBookClick == true?



          Drawer(
              width: MediaQuery.of(context).size.width/2.95,
              child: Obx(
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
                                                    color: const Color(0xff3B3B3B))),
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
                                                        "Select Standard",
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.height / 38,
                                                            fontFamily: "NatoSans",
                                                            color: const Color(0xFF3B3B3B),
                                                            fontWeight: FontWeight.w400)),
                                                    value: selectedStd,
                                                    buttonStyleData: ButtonStyleData(
                                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 100),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: const Color.fromRGBO(192, 195, 207, 1))),
                                                        height: MediaQuery.of(context).size.height / 13,
                                                        width: double.infinity),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey, width: 1.5))),
                                                    menuItemStyleData: MenuItemStyleData(height: MediaQuery.of(context).size.height / 15),
                                                    items: orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.map((std) =>
                                                        DropdownMenuItem<String>(
                                                            onTap: () {
                                                              selectedStdId = std.id;

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
                                ],
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
                                    pendingLevel2ReportVm.pendingLevel2List.clear();
                                    pendingLevel2ReportVm.isLoading.value = true;
                                    await pendingLevel2ReportVm.getReportLevel2Detail("1","10",pref.getInt('userId')!,selectedSchoolId == null?0 :selectedSchoolId!,selectedStdId ==null? 0:selectedStdId!,pendingLevel1BookSetID!,selectedDivId == null? 0:selectedDivId!,storedFromDate!,storedToDate!);
                                    setState(() {
                                      // selectedSchool = null;
                                      // selectedStd = null;
                                      // selectedStd = null;
                                      Get.back();
                                    });
                                  },
                                  child: Text('Apply',style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NatoSans',
                                      fontSize: MediaQuery.of(context).size.height/45)))
                            ],
                          ))))):






          Drawer(
              width: MediaQuery.of(context).size.width/2.95,
              child: Obx(
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
                                                    color: const Color(0xff3B3B3B))),
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
                                                        "Select Standard",
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.height / 38,
                                                            fontFamily: "NatoSans",
                                                            color: const Color(0xFF3B3B3B),
                                                            fontWeight: FontWeight.w400)),
                                                    value: selectedStd,
                                                    buttonStyleData: ButtonStyleData(
                                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 100),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: const Color.fromRGBO(192, 195, 207, 1))),
                                                        height: MediaQuery.of(context).size.height / 13,
                                                        width: double.infinity),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey, width: 1.5))),
                                                    menuItemStyleData: MenuItemStyleData(height: MediaQuery.of(context).size.height / 15),
                                                    items: orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.map((std) =>
                                                        DropdownMenuItem<String>(
                                                            onTap: () {
                                                              selectedStdId = std.id;

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
                                ],
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

                                    pendingLevel1Vm.pendingLevel1List.clear();
                                    pendingLevel1Vm.isLoading.value = true;
                                    pendingLevel1Vm.getPendingLevel1Detail("1", "10", pref.getInt('userId')!,selectedSchoolId == null?0 :selectedSchoolId!,selectedStdId ==null? 0:selectedStdId!,selectedDivId == null? 0:selectedDivId!,storedFromDate!,storedToDate!);
                                    // pendingLevel2ReportVm.pendingLevel2List.clear();
                                    // pendingLevel2ReportVm.isLoading.value = true;
                                    // await pendingLevel2ReportVm.getReportLevel2Detail(pref.getInt('userId')!,selectedSchoolId == null?0 :selectedSchoolId!,selectedStdId ==null? 0:selectedStdId!,selectedDivId == null? 0:selectedDivId!,storedFromDate!,storedToDate!);
                                    setState(() {
                                      selectedSchool = null;
                                      selectedStd = null;
                                      selectedStd = null;
                                      Get.back();
                                    });
                                  },
                                  child: Text('Apply',style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NatoSans',
                                      fontSize: MediaQuery.of(context).size.height/45)))
                            ],
                          ))))),










          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 130,
                    horizontal: MediaQuery.of(context).size.width / 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentIndexes == 0?RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Reports >> ',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height / 33,
                                  color: Colors.black,
                                  fontFamily: "NotoSansSemiBold",
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Pending Books',
                              style: TextStyle(
                                  color: const Color(0xff5448D2),
                                  fontFamily: "NotoSansSemiBold",
                                  fontSize: MediaQuery.of(context).size.height / 33,
                                  fontWeight: FontWeight.bold)),

                        ])):RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Reports >> Pending Books >> ',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height / 33,
                                  color: Colors.black,
                                  fontFamily: "NotoSansSemiBold",
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: pendingLevel1SchoolName!,
                              style: TextStyle(
                                  color: const Color(0xff5448D2),
                                  fontFamily: "NotoSansSemiBold",
                                  fontSize: MediaQuery.of(context).size.height / 33,
                                  fontWeight: FontWeight.bold)),
                        ])),
                     InkWell(
                         onTap: (){
                           if (_history.isNotEmpty) {
                             setState(() {
                               _currentIndexes = _history.removeLast();
                               pendingBookClick = false;
                               pendingSearchController.clear();
                             });
                           }
                         },
                         child:pendingBookClick == false?const Text(""): Text('<< Back',style: TextStyle(
                             color: const Color(0xff5448D2),
                             fontFamily: "NotoSansSemiBold",
                             fontSize: MediaQuery.of(context).size.height / 33,
                             fontWeight: FontWeight.bold))),

                  ],
                ),
              ),
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
                      vertical : MediaQuery.of(context).size.height/38,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              focusNode: _focusNode,
                            controller: pendingSearchController,
                            onChanged: (value) {
                              setState(() {
                               pendingBookClick == false? pendingBooksL1(value):pendingBooksL2(value);
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height/90),
                                hintText: _currentIndexes==1?'Search by Order No or Mobile or Student Name':
                                'Search by School or Location',
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
                              _currentIndexes == 1?downloadExcel2():downloadExcel1();
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
                                    // clearDates();
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
                child: _buildList(_currentIndexes),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(int index) {
    switch (index) {
      case 0:
        return PendingFirstListWidget(
          onSwitch: (nextIndex) {
            setState(() {
              _history.add(_currentIndexes);
              _currentIndexes = nextIndex;
            });
          },
        );
      case 1:
        return const PendingSecondListWidget();
      default:
        return Container();
    }
  }
}




