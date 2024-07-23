import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/reports_tabbar.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../modal/reports_modal/transaction_modal.dart';
import '../../utility/base_url.dart';
import '../../view_modal/order_history_view_modal/order_history_school_division_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_standard_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_timer_filter_vm.dart';
import '../../view_modal/reports/transaction_historyVm.dart';
import '../common_widgets/progress_indicator.dart';
import '../common_widgets/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;


String encryptionKey = '8080808080808080';
List<TransactionReportModal> getTransactionBooks() {
  if (searchString.isEmpty) {
    return transactionHistoryVm.transactionHistoryList;
  } else {
    return transactionHistoryVm.transactionHistoryList.where((book) {
      return book.orderId!.toLowerCase().contains(searchString.toLowerCase()) || book.studentName!.toLowerCase().contains(searchString.toLowerCase()) ||
          book.paymentType!.toLowerCase().contains(searchString.toLowerCase());
    }).toList();
  }
}
var searchString = ''.obs;
late DateTime fromDate;
late DateTime toDate;
late String selectedOption;

bool isFromDateSelectable = false;
bool isToDateSelectable = false;
void transactionFilterBooks(String query) {
  searchString.value = query;
}

final orderHistorySchoolDropdownVM = Get.put(OrderHistorySchoolDropdownVM());
final orderHistorySchoolStandardDropdownVM = Get.put(OrderHistorySchoolStandardDropdownVM());
final orderHistorySchoolDivisionVm = Get.put(OrderHistorySchoolDivisionVm());
final orderHistoryTimerFilterVm = Get.put(OrderHistoryTimerFilterVm());
final GlobalKey<ScaffoldState> _scaffoldKeys = GlobalKey<ScaffoldState>();
class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => TransactionHistoryState();
}


class TransactionHistoryState extends State<TransactionHistory> {
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
  TextEditingController transactionController = TextEditingController();
  TextEditingController transactionSearchController = TextEditingController();



  /// pagination
  int _page = 1;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      {
        Timer(const Duration(milliseconds: 800), () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          transactionHistoryVm.transactionHistoryList.clear();
          transactionHistoryVm.isLoading.value = true;
          await transactionHistoryVm.getTransactionDetail(_page.toString(),"10","","",pref.getInt('userId')!,0,0,0,"","");

        });
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await transactionHistoryVm.getTransactionDetail(_page.toString(),"10","","",pref.getInt('userId')!,0,0,0,"","");

        if (_page == transactionPageCount) {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }


ScrollController scrollController1 = ScrollController();
  late Timer _debounce;
  @override
  void initState() {
    // TODO: implement ini
    salesBySchoolL1Controller.clear();
    salesBySchoolL2Controller.clear();
    salesBySchoolL3Controller.clear();
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
    _debounce = Timer(const Duration(milliseconds: 500), () {});
    fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    selectedOption = 'This Month';
  }

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
          isToDateSelectable = true;
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

  /// dismiss keyboard
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose();
    _debounce.cancel();
    super.dispose();
  }
  void _dismissKeyboard(BuildContext context) {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
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

  Future<void> downloadExcel() async {
    // String baseUrl = 'http://pos-test.shauryatechnosoft.com/excel-download-for-app';
    // String baseUrl = 'https://bookmybookstuckshop.in/excel-download-for-app';
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getInt('userId')!);
    // print(selectedSchoolId!);
    print(transactionSearchController.text);
    Map<String, dynamic> obj = {
      'pageName': 'Transaction',
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
      'FromDate': storedFromDate == null ? '':storedFromDate!,
      'ToDate': storedToDate == null ? '':storedToDate!,
      'BookSetId': 0,
      'BookSetName':'',
      'PageNo': 1,
      'PageSize': 10,
      'TextSearch': transactionSearchController.text.isEmpty?'':transactionSearchController.text,
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
    return GestureDetector(
      onTap: (){
        _dismissKeyboard(context);
      },
      child: Scaffold(
          key: _scaffoldKeys,
          backgroundColor: Colors.white,
          endDrawer: Drawer(
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
                                                  menuItemStyleData: MenuItemStyleData(height: MediaQuery.of(context).size.height / 15),
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
                                                                fontWeight: FontWeight.w400)))
                                                  ).toList(),
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      isToDateSelectable = false;
                                                      setDateRange(newValue);
                                                      selectedTime = newValue;
                                                    }
                                                  },
                                                )))),
                                          ///Select Date
                                          Visibility(
                                            visible: selectedTime == 'Custom Date',
                                            child: Text(
                                              'Select Date',
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height / 45,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'NatoSans',
                                                  color: const Color(0xff3B3B3B)))),
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
                                                      print(selectedSchool);
                                                      print(selectedSchoolId);
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
                                                    8.0)),
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
                                          Text(
                                            'Enter Mobile No.',
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
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                  border: Border.all(color: const Color.fromRGBO(192, 195, 207, 1), width: 1.5)),
                                              height: MediaQuery.of(context).size.height / 15,
                                              child: TextFormField(
                                                controller: transactionController,
                                                cursorColor: Colors.grey,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(10),
                                                  FilteringTextInputFormatter.digitsOnly
                                                ],
                                                decoration: const InputDecoration(
                                                    enabledBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                        print("selectedSchoolId:$selectedSchoolId");
                                        print(DateFormat('yyyy-MM-dd').format(fromDate));
                                        print(DateFormat('yyyy-MM-dd').format(toDate));
                                        storedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
                                        storedToDate = DateFormat('yyyy-MM-dd').format(toDate);
                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                         if (transactionController.text
                                            .startsWith("0")) {
                                          toastMessage(context, "Invalid mobile no.",
                                              color: Colors.white);return;
                                        } else if (transactionController.text
                                            .startsWith("1")) {
                                          toastMessage(context, "Invalid mobile no.",
                                              color: Colors.white);return;
                                        } else if (transactionController.text
                                            .startsWith("2")) {
                                          toastMessage(context, "Invalid mobile no.",
                                              color: Colors.white);return;
                                        } else if (transactionController.text
                                            .startsWith("3")) {
                                          toastMessage(context, "Invalid mobile no.",
                                              color: Colors.white);return;
                                        } else if (transactionController.text
                                            .startsWith("4")) {
                                          toastMessage(context, "Invalid mobile no.",
                                              color: Colors.white);return;
                                        } else if (transactionController.text
                                            .startsWith("5")) {
                                          toastMessage(context, "Invalid mobile no.",
                                              color: Colors.white);
                                          return;
                                        }
                                        transactionHistoryVm.transactionHistoryList.clear();
                                        transactionHistoryVm.isLoading.value = true;
                                        await transactionHistoryVm.getTransactionDetail("1", "10",storedFromDate!,storedToDate!, pref.getInt('userId')!,selectedSchoolId == null?0:selectedSchoolId!,selectedStdId == null?0:selectedStdId!,selectedStdId == null?0:selectedStdId!,transactionController.text.isEmpty ?"":transactionController.text,"");
                                        setState(() {
                                          selectedSchool = null;
                                          selectedStd = null;
                                          selectedStd = null;
                                          transactionController.clear();
                                          Get.back();
                                        });
                                      },
                                      child: Text('Apply',style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'NatoSans',
                                          fontSize: MediaQuery.of(context).size.height/45)))
                                ],
                              ),
                            ],
                          ))))),
          body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child:
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 100,
                        horizontal: MediaQuery.of(context).size.width / 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Reports >> ',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height / 33,
                                      color: Colors.black,
                                      fontFamily: "NotoSansSemiBold",
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: reportsSelectedIndex ==0?'Transaction History':reportsSelectedIndex == 1?'Sales by School': 'Pending Books',
                                  style: TextStyle(
                                      color: const Color(0xff5448D2),
                                      fontFamily: "NotoSansSemiBold",
                                      fontSize: MediaQuery.of(context).size.height / 33,
                                      fontWeight: FontWeight.bold)),
                            ])),
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
                                controller: transactionSearchController,
                                focusNode: _focusNode,
                                onChanged: (value) async {
                                  // setState(() {
                                  //   transactionFilterBooks(value);
                                  //   print(transactionSearchController.text);
                                  // });


                                  SharedPreferences preference = await SharedPreferences.getInstance();
                                  _debounce.cancel();
                                  _debounce = Timer(const Duration(milliseconds: 550), () async {
                                    setState(() {

                                      transactionHistoryVm.transactionHistoryList.clear();
                                      transactionHistoryVm.isLoading.value = true;
                                    });
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    await transactionHistoryVm.getTransactionDetail(_page.toString(),"10","","",pref.getInt('userId')!,0,0,0,"",transactionSearchController.text);

                                    _hasNextPage = true;
                                  });

                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height/90
                                    ),
                                    hintText: 'Search by Order Id',
                                    hintStyle: TextStyle(
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
                                    )
                                ),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/40),
                            GestureDetector(
                              onTap: (){
                                downloadExcel();
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
                                      // selectedTime = null;
                                      // selectedSchool = null;
                                      // selectedStd = null;
                                      // selectedDiv = null;
                                      // transactionController.clear();
                                      // SharedPreferences pref = await SharedPreferences.getInstance();
                                      // orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
                                      // orderHistorySchoolDropdownVM.ohSchoolDropListVm.clear();
                                      // orderHistorySchoolDropdownVM.isLoading.value = true;
                                      // await orderHistorySchoolDropdownVM.getSchoolDropdown(pref.getInt('userId')!);
                                      // orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
                                      // fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                                      // toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                                      // selectedOption = 'This Month';
                                      // orderHistoryTimerFilterVm.ohTimerFilterDropListVm.clear();
                                      // orderHistoryTimerFilterVm.isLoading.value = true;
                                      // await orderHistoryTimerFilterVm.getOhTimerFilter();
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
                                        child: SvgPicture.asset("assets/images/dashboard_img/filter_icon.svg"))))
                          ],
                        )))),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/80,vertical: MediaQuery.of(context).size.height/100),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF7367F0)),
                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF7367F0).withOpacity(0.2),
                                        // border: Border.all(color: const Color(0xFF7367F0)),
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                    ),

                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                              flex:1,
                                              child: Center(child: Text("Sr No.",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("Order ID",textAlign:TextAlign.left,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("School Name",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("Student Name",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("Payment Method",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("Date",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                          Expanded(
                                              flex:1,
                                              child: Center(child: Text("Amount",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 0,color: Color(0xFF7367F0))
                                ],
                              ),

                              Card(
                                  elevation: 0,
                                  child: SizedBox(
                                      height: MediaQuery.of(context).size.height/2.35,
                                      child:
                                      Obx(()=> ModalProgressHUD(
                                          inAsyncCall : transactionHistoryVm.isLoading.value == true,
                                          progressIndicator: progressIndicator(),
                                          child:
                                          getTransactionBooks().isEmpty?const Center(child: Text("No Data Found")):ListView.builder(
                                            controller: _controller,
                                              shrinkWrap: true,
                                              itemCount: getTransactionBooks().length,
                                              itemBuilder: (BuildContext context,index){
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            flex:1,
                                                            child: Center(child: Text("${index+1}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                        Expanded(
                                                            flex:2,
                                                            child: Center(child: Text(getTransactionBooks()[index].orderId!,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                        Expanded(
                                                            flex:2,
                                                            child: Center(child: Text(getTransactionBooks()[index].schoolName!,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                        Expanded(
                                                            flex:2,
                                                            child: Center(child: Text(getTransactionBooks()[index].studentName == null ? "-":getTransactionBooks()[index].studentName!,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                        Expanded(
                                                            flex:2,
                                                            child: Center(child: Text(getTransactionBooks()[index].paymentType!,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                        Expanded(
                                                            flex:2,
                                                            child: Center(child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(getTransactionBooks()[index].date.toString())),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                        Expanded(
                                                            flex:1,
                                                            child: Center(child: Text("₹ ${getTransactionBooks()[index].totalAmount}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }))))),
                            ],
                          ))),
                ],
              ))),
    );
  }
}



