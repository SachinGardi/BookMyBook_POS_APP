import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../modal/order_history_modal/get_order_history_modal.dart';
import '../../repository/order_history_repository/get_order_history_repo.dart';
import '../../utility/base_url.dart';
import '../../view_modal/order_history_view_modal/get_order_history_vm.dart';
import '../../view_modal/order_history_view_modal/invoice_popup_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_division_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_standard_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_timer_filter_vm.dart';
import '../common_widgets/progress_indicator.dart';
import 'order_history_tabbar_class.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}
final TextEditingController orderHistorySearchCtx = TextEditingController();

late TabController tabController;
final TextEditingController orderIdController = TextEditingController();
final TextEditingController invoiceIdController = TextEditingController();
int? divId;
int? stdId;
int? timeId;
String? storedFromDate;
String? storedToDate;
int? selectSchoolId;

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  DateTime? fromDate;
  DateTime? toDate;

  final ScrollController _controller = ScrollController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final orderHistorySchoolDropdownVM = Get.put(OrderHistorySchoolDropdownVM());
  final orderHistorySchoolStandardDropdownVM = Get.put(OrderHistorySchoolStandardDropdownVM());
  final orderHistorySchoolDivisionVm = Get.put(OrderHistorySchoolDivisionVm());
  final orderHistoryTimerFilterVm = Get.put(OrderHistoryTimerFilterVm());
  final getOrderHistoryVm = Get.put(GetOrderHistoryVm());
  final invoicePopupVm = Get.put(InvoicePopupVm());

  String? selectSchool;

  String? selectedStd;

  String? selectedDiv;

  String? selectedTime;


  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate =
    isFromDate ? fromDate ?? DateTime.now() : toDate ?? DateTime.now();
    DateTime firstCalendarDate = DateTime(1900);
    DateTime lastCalendarDate = DateTime(2101);

    if (isFromDate) {
      lastCalendarDate =
          DateTime.now(); // Limit the first date picker to the current date
    } else if (fromDate != null) {
      firstCalendarDate = fromDate!;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstCalendarDate,
      lastDate: toDate != null ? lastCalendarDate : DateTime.now(),
      helpText: 'Select ${isFromDate ? 'from' : 'to'} date',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      // Set initial entry mode
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff5448D2),
              colorScheme: const ColorScheme.light(primary: Color(0xff5448D2)),
              buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isFromDate ? fromDate : toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          if (fromDate != null && picked.isBefore(fromDate!)) {
            toDate = fromDate;
            fromDate = picked;
          } else {
            toDate = picked;
          }
        }
      });
    }
  }

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  ///This filter logic method
  void timeFilterValue(int timeId) async {
    ///This month logic
    if (timeId == 1) {
      final now = DateTime.now();
      fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      toDate = now;
      print('#####$fromDate');
      print('#####$toDate');
      // Format the dates as strings
      setState(() {
        fromController.text = formatter.format(fromDate!);
        toController.text = formatter.format(toDate!);
      });
    }

    ///Last month logic
    else if (timeId == 2) {
      final now = DateTime.now();
      toDate = DateTime(now.year, now.month, 0);
      fromDate = DateTime(toDate!.year, toDate!.month, 1);
      print('#####$fromDate');
      print('#####$toDate');
      // Format the dates as strings
      setState(() {
        toController.text = formatter.format(toDate!);
        fromController.text = formatter.format(fromDate!);
      });
    }

    ///This Quarter logic
    else if (timeId == 3) {
      // Calculate the first and last dates of the current quarter when the widget is created.
      final now = DateTime.now();
      final currentQuarter =
          (now.month - 1) ~/ 3; // Determine the current quarter (0, 1, 2, 3).
      final startMonth = currentQuarter * 3 + 1;
      final endMonth = startMonth + 2;
      fromDate = DateTime(now.year, startMonth, 1);
      toDate = DateTime.now();

      // Format the dates as strings
      setState(() {
        toController.text = formatter.format(toDate!);
        fromController.text = formatter.format(fromDate!);
      });
    }

    ///Last quarter logic
    else if (timeId == 4) {
      // Calculate the first and last dates of the previous quarter when the widget is created.
      final now = DateTime.now();
      final currentQuarter =
          (now.month - 1) ~/ 3; // Determine the current quarter (0, 1, 2, 3).
      final endMonthOfPreviousQuarter = currentQuarter * 3;
      final startMonthOfPreviousQuarter = endMonthOfPreviousQuarter - 2;
      fromDate = DateTime(now.year, startMonthOfPreviousQuarter, 1);
      toDate = DateTime(now.year, endMonthOfPreviousQuarter + 1, 0);
      // Format the dates as strings
      setState(() {
        toController.text = formatter.format(toDate!);
        fromController.text = formatter.format(fromDate!);
      });
    }
  }

  void _onFromDateChanged(String value) {
    if (value.isNotEmpty) {
      setState(() {
        fromDate = formatter.parse(value);
      });
    }
  }

  void _onToDateChanged(String value) {
    if (value.isNotEmpty) {
      setState(() {
        toDate = formatter.parse(value);
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;
  int selectedIndex = 0;
  String searchOrderText = '';


  Future<void> downloadExcel() async {
    // String baseUrl = 'http://pos-test.shauryatechnosoft.com/excel-download-for-app';
    // String baseUrl = 'https://bookmybookstuckshop.in/excel-download-for-app?id=';
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getInt('userId')!);
    Map<String, dynamic> obj = {
      'pageName': 'orderHistory',
      'UserId': pref.getInt('userId')!,
      'SchoolId': selectSchoolId == null? 0 : selectSchoolId!,
      'SchoolName': '',
      'StdId': stdId == null? 0 : stdId!,
      'standard': '',
      'DivId': divId == null? 0 : divId!,
      'division': '',
      'Time': timeId == null? 0 : timeId!,
      'OrderId': orderIdController.text.isEmpty ? "" : orderIdController.text,
      'InvoiceId': invoiceIdController.text.isEmpty ? "": invoiceIdController.text,
      'FromDate': storedFromDate == null ? "":storedFromDate!,
      'ToDate': storedToDate == null ? "":storedToDate!,
      'PageNo': 1,
      'PageSize': 10,
      'TextSearch': orderHistorySearchCtx.text.isEmpty?"" : orderHistorySearchCtx.text,
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

  String encryptionKey = '8080808080808080';
  String encryptData(String data) {
    final key = encrypt.Key.fromUtf8(encryptionKey);
    final iv = encrypt.IV.fromUtf8(encryptionKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);
    final base64Encoded = encrypted.base64;
    return Uri.encodeFull(base64Encoded);
  }


  @override
  void initState() {
    super.initState();
    GetOrderHistoryRepo.orderHistoryList.clear();
    orderHistorySearchCtx.clear();
    tabController = TabController(animationDuration: Duration.zero, length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getOrderHistoryVm.isLoading.value = false;
      orderHistorySchoolStandardDropdownVM.isLoading.value = false;
      orderHistoryTimerFilterVm.isLoading.value = false;
      orderHistorySchoolDivisionVm.isLoading.value = false;
      invoicePopupVm.isLoading.value = false;
      orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
      orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
      SharedPreferences pref = await SharedPreferences.getInstance();
      orderHistorySchoolDropdownVM.getSchoolDropdown(pref.getInt('userId')!);
      getOrderHistoryVm.invoiceListVm.clear();
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.isLoading.value = true;
      AllRecordState.page = 1;
      AllRecordState.hasNextPage = true;
      selectSchoolId = null;
      await getOrderHistoryVm.getOrderHistoryVm(AllRecordState.page, orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');
      await orderHistoryTimerFilterVm.getOhTimerFilter();
      selectedTime = orderHistoryTimerFilterVm.ohTimerFilterDropListVm.first.text;
      timeId = orderHistoryTimerFilterVm.ohTimerFilterDropListVm.first.id;
      print('####$selectedTime');
      print('####$timeId');
      fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      toDate = DateTime.now();
      toController.text = formatter.format(toDate!);
      fromController.text = formatter.format(fromDate!);
      tabController.addListener(handleTabChange);
    });
  }

  Timer? timer;

  @override
  void dispose() {
    tabController.removeListener(handleTabChange);
    tabController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void handleTabChange() {
    setState(() {
      selectedIndex = tabController.index;
      selectSchoolId = null;
      print('#####$selectedIndex');
      fetchDataForTab(selectedIndex);
    });
  }

  fetchDataForTab(int tabIndex) async {
    print('#####$tabIndex####');

    /// All data api
    if (tabIndex == 0) {
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.invoiceListVm.clear();
      invoicePopupVm.invoiceDataListVm.clear();
      getOrderHistoryVm.isLoading.value = true;
      AllRecordState.hasNextPage = true;
      AllRecordState.page = 1;
      if(selectSchoolId == null){
        await getOrderHistoryVm.getOrderHistoryVm(
            AllRecordState.page, orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');
      }
      else{
        await getOrderHistoryVm.getOrderHistoryVm(
            AllRecordState.page,
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

    }

    ///Completed data api
    if (tabIndex == 1) {
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.invoiceListVm.clear();
      invoicePopupVm.invoiceDataListVm.clear();
      getOrderHistoryVm.isLoading.value = true;
      CompletedRecordState.page = 1;
      CompletedRecordState.hasNextPage = true;
      if(selectSchoolId == null){
        await getOrderHistoryVm.getOrderHistoryVm(
            CompletedRecordState.page, orderHistorySearchCtx.text,2, 0, '', '', 0, 0, 0, '', '');
      }
      else{
        await getOrderHistoryVm.getOrderHistoryVm(
            CompletedRecordState.page,
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

    }

    ///Pending data api
    if (tabIndex == 2) {
      getOrderHistoryVm.orderHistoryListVm.clear();
      getOrderHistoryVm.invoiceListVm.clear();
      invoicePopupVm.invoiceDataListVm.clear();
      getOrderHistoryVm.isLoading.value = true;
      PendingRecordState.page = 1;
      PendingRecordState.hasNextPage = true;
      if(selectSchoolId == null){
        await getOrderHistoryVm.getOrderHistoryVm(
            PendingRecordState.page, orderHistorySearchCtx.text,1, 0, '', '', 0, 0, 0, '', '');
      }
      else{
        await getOrderHistoryVm.getOrderHistoryVm(
            CompletedRecordState.page,
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

    }
  }

  ///For Elastic orderHistory search
  void _filterOrderHistory(String query) {
    setState(() {
      searchOrderText = query;
      print('####$searchOrderText####');
      if(searchOrderText.isNotEmpty){
        getOrderHistoryVm.orderHistoryListVm.clear();
        getOrderHistoryVm.invoiceListVm.clear();
        invoicePopupVm.invoiceDataListVm.clear();
        getOrderHistoryVm.isLoading.value = true;
        getData();
      }
      else if(searchOrderText.isEmpty){
        selectSchoolId = null;
        getOrderHistoryVm.orderHistoryListVm.clear();
        getOrderHistoryVm.invoiceListVm.clear();
        invoicePopupVm.invoiceDataListVm.clear();
        getOrderHistoryVm.isLoading.value = true;
        AllRecordState.hasNextPage = true;
        CompletedRecordState.hasNextPage = true;
        PendingRecordState.hasNextPage = true;
        getData2();
      }
    });
  }

  getData() async {
    if(selectedIndex == 0){
      AllRecordState.page = 1;
      if(selectSchoolId == null){
        getOrderHistoryVm.getOrderHistoryVm(
            AllRecordState.page, orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');
      }
      else{
        await getOrderHistoryVm.getOrderHistoryVm(
            AllRecordState.page,
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


    }
    else if(selectedIndex == 1){
      CompletedRecordState.page = 1;
      if(selectSchoolId == null){
        getOrderHistoryVm.getOrderHistoryVm(
            CompletedRecordState.page, orderHistorySearchCtx.text,2, 0, '', '', 0, 0, 0, '', '');
      }
      else{
        await getOrderHistoryVm.getOrderHistoryVm(
            CompletedRecordState.page,
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

    }
    else if(selectedIndex == 2){
      PendingRecordState.page = 1;
      if(selectSchoolId == null){
        getOrderHistoryVm.getOrderHistoryVm(
            PendingRecordState.page, orderHistorySearchCtx.text,1, 0, '', '', 0, 0, 0, '', '');
      }

      else{
        await getOrderHistoryVm.getOrderHistoryVm(
            PendingRecordState.page,
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
    }

  }

  getData2(){
    GetOrderHistoryRepo.orderHistoryList.clear();
    GetOrderHistoryRepo.orderHistoryPageDetail.clear();
    getOrderHistoryVm.orderHistoryListVm.clear();
    getOrderHistoryVm.invoiceListVm.clear();
    invoicePopupVm.invoiceDataListVm.clear();
    getOrderHistoryVm.isLoading.value = true;
    AllRecordState.page = 1;
    CompletedRecordState.page = 1;
    getOrderHistoryVm.getOrderHistoryVm(
        selectedIndex==0?AllRecordState.page:selectedIndex==1?CompletedRecordState.page:1, orderHistorySearchCtx.text,selectedIndex == 0?0:selectedIndex==1?2:1, 0, '', '', 0, 0, 0, '', '');
  }


  List<GetOrderHistoryModal> getFilteredOrderHistory() {
    if (searchOrderText.isEmpty) {
      return getOrderHistoryVm.orderHistoryListVm;
    } else if (searchOrderText.isNotEmpty) {
      return getOrderHistoryVm.orderHistoryListVm.where((order) {
        return order.studentName
            .toLowerCase()
            .contains(searchOrderText.toLowerCase()) ||
            order.schoolName
                .toLowerCase()
                .contains(searchOrderText.toLowerCase()) ||
            order.mobileNo
                .toLowerCase()
                .contains(searchOrderText.toLowerCase()) ||
            order.invoiceList.any((element) => element.invoiceId
                .toLowerCase()
                .contains(searchOrderText.toLowerCase()));
      }).toList();
    } else {
      return getOrderHistoryVm.orderHistoryListVm.where((order) {
        order.invoiceList.where((invoice) {
          return invoice.invoiceId.toLowerCase()
              .contains(searchOrderText.toLowerCase());
        });
        return false;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timeId == 5) {
      fromController.text = fromDate == null ? '' : formatDate(fromDate!);
      toController.text = toDate == null ? '' : formatDate(toDate!);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width / 3,
        child: Obx(
              () => ModalProgressHUD(
            inAsyncCall:
            orderHistorySchoolStandardDropdownVM.isLoading.value == true ||
                orderHistorySchoolDivisionVm.isLoading.value == true,
            progressIndicator: progressIndicator(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 70,
                vertical: MediaQuery.of(context).size.height / 60,
              ),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _scaffoldKey.currentState!.closeEndDrawer(),
                        child: CircleAvatar(
                            backgroundColor: const Color(0xffE0DDFC),
                            minRadius: MediaQuery.of(context).size.height / 50,
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF4D3FD9),
                              size: 28,
                            )),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 70),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _controller,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                  MediaQuery.of(context).size.width / 100),
                              child: ListView(
                                controller: _controller,
                                children: [
                                  ///select time Dropdown
                                  Text(
                                    'Select Time',
                                    style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            45,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        color: const Color(0xff3B3B3B)),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top:
                                          MediaQuery.of(context).size.height /
                                              60,
                                          bottom:
                                          MediaQuery.of(context).size.height /
                                              40),
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
                                                    "Select Time",
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height / 38,
                                                        fontFamily: "NotoSans",
                                                        color: const Color(0xFF3B3B3B),
                                                        fontWeight: FontWeight.w400)),
                                                value: selectedTime,
                                                buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.of(context).size.width / 100),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: const Color.fromRGBO(192, 195, 207, 1))),
                                                    height: MediaQuery.of(context).size.height / 13,
                                                    width: double.infinity),
                                                dropdownStyleData: DropdownStyleData(
                                                    maxHeight: MediaQuery.of(context).size.height / 2.5,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1.5))),
                                                menuItemStyleData: MenuItemStyleData(
                                                    height: MediaQuery.of(context).size.height / 15),
                                                items: orderHistoryTimerFilterVm
                                                    .ohTimerFilterDropListVm
                                                    .map((time) =>
                                                    DropdownMenuItem<String>(
                                                        onTap: () {
                                                          timeId = time.id;
                                                          print('#####$timeId');
                                                        },
                                                        value: time.text,
                                                        child: Text(
                                                            time.text.toString(),
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height / 35,
                                                                fontFamily: "NotoSans",
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400))))
                                                    .toList(),
                                                onChanged: (time) {
                                                  setState(() {
                                                    fromDate = null;
                                                    toDate = null;
                                                    timeFilterValue(timeId!);
                                                    selectedTime = time;
                                                  });
                                                },
                                              )))),

                                  ///Select Date
                                  Text(
                                      'Select Date',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height / 45,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'NotoSans',
                                          color: const Color(0xff3B3B3B))),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height / 60,
                                        bottom: MediaQuery.of(context).size.height / 40),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (timeId == 5) {
                                                _selectDate(context, true);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: const Color(
                                                          0xffA8A8A8))),
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  15,
                                              child: TextFormField(
                                                style: TextStyle(
                                                    fontSize:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                        45,
                                                    color: Colors.black),
                                                controller: fromController,
                                                enabled: false,
                                                onTapOutside: (value) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                onChanged: _onFromDateChanged,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                        left:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                            90),
                                                    suffixIcon: Container(
                                                      decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .only(
                                                            topRight: Radius
                                                                .circular(
                                                                5),
                                                            bottomRight:
                                                            Radius
                                                                .circular(
                                                                5),
                                                          ),
                                                          color: Color(
                                                              0xaa818181)),
                                                      child: SvgPicture.asset(
                                                        'assets/images/order_history_images/calendar.svg',
                                                        fit: BoxFit.scaleDown,
                                                        height: 6,
                                                        width: 5,
                                                      ),
                                                    ),
                                                    hintText: 'From',
                                                    hintStyle: TextStyle(
                                                      fontSize:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                          50,
                                                    ),
                                                    filled: true,
                                                    isDense: true,
                                                    fillColor: timeId == 5
                                                        ? const Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                        : Colors.grey.shade300,
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                        borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xffA8A8A8)))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              35,
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (timeId == 5) {
                                                  if (fromDate != null) {
                                                    _selectDate(context, false);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: const Color(
                                                            0xffA8A8A8))),
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    15,
                                                child: TextFormField(
                                                  controller: toController,
                                                  enabled: false,
                                                  onTapOutside: (value) {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  },
                                                  style: TextStyle(
                                                      fontSize:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                          45,
                                                      color: Colors.black),
                                                  onChanged: _onToDateChanged,
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(
                                                          left:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                              90),
                                                      suffixIcon: Container(
                                                        width: double.minPositive,
                                                        decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .only(
                                                              topRight: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                              Radius
                                                                  .circular(
                                                                  5),
                                                            ),
                                                            color: Color(
                                                                0xaa818181)),
                                                        child: SvgPicture.asset(
                                                          'assets/images/order_history_images/calendar.svg',
                                                          fit: BoxFit.scaleDown,
                                                          height: 6,
                                                          width: 5,
                                                        ),
                                                      ),
                                                      hintText: 'To',
                                                      hintStyle: TextStyle(
                                                        fontSize:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                            45,
                                                        fontFamily: 'NotoSans',
                                                      ),
                                                      filled: true,
                                                      isDense: true,
                                                      fillColor: timeId == 5
                                                          ? const Color.fromRGBO(
                                                          255, 255, 255, 1)
                                                          : Colors.grey.shade300,
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                          borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffA8A8A8)))),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),

                                  ///Select School Dropdown
                                  Text(
                                    'Select School',
                                    style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            45,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        color: const Color(0xff3B3B3B)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                        MediaQuery.of(context).size.height /
                                            60,
                                        bottom:
                                        MediaQuery.of(context).size.height /
                                            40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the border radius as needed
                                      ),
                                      height:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(Icons.arrow_drop_down),
                                              openMenuIcon:
                                              Icon(Icons.arrow_drop_up)),
                                          hint: Text(
                                            "Select School",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    38,
                                                fontFamily: "NotoSans",
                                                color: const Color(0xFF3B3B3B),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          value: selectSchool,
                                          buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    100),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        192, 195, 207, 1))),
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                13,
                                            width: double.infinity,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                              maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  2.5,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.5))),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                15,
                                          ),
                                          items: orderHistorySchoolDropdownVM
                                              .ohSchoolDropListVm
                                              .map((school) => DropdownMenuItem<
                                              String>(
                                              onTap: () async {
                                                selectSchoolId = school.id;
                                                if (selectSchoolId !=
                                                    null) {
                                                  selectedDiv = null;
                                                  selectedStd = null;
                                                  orderHistorySchoolStandardDropdownVM
                                                      .ohSchoolStdListVm
                                                      .clear();
                                                  orderHistorySchoolDivisionVm
                                                      .ohSchoolDivisionDropListVm
                                                      .clear();
                                                  orderHistorySchoolStandardDropdownVM
                                                      .isLoading
                                                      .value = true;
                                                  orderHistorySchoolStandardDropdownVM
                                                      .getOhSchoolStandardDropdown(
                                                      context,
                                                      selectSchoolId!);
                                                }

                                                print(selectSchoolId);
                                              },
                                              value: school.schools,
                                              child: Text(
                                                school.schools.toString(),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .height /
                                                        35,
                                                    fontFamily: "NotoSans",
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              )))
                                              .toList(),
                                          onChanged: (school) {
                                            setState(() {
                                              selectSchool = school;
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
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            45,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        color: const Color(0xff3B3B3B)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                        MediaQuery.of(context).size.height /
                                            60,
                                        bottom:
                                        MediaQuery.of(context).size.height /
                                            40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the border radius as needed
                                      ),
                                      height:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(Icons.arrow_drop_down),
                                              openMenuIcon:
                                              Icon(Icons.arrow_drop_up)),
                                          hint: Text(
                                            "Select Standard",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    38,
                                                fontFamily: "NotoSans",
                                                color: const Color(0xFF3B3B3B),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          value: selectedStd,
                                          buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    100),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        192, 195, 207, 1))),
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                13,
                                            width: double.infinity,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                              maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  2.5,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.5))),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                15,
                                          ),
                                          items:
                                          orderHistorySchoolStandardDropdownVM
                                              .ohSchoolStdListVm
                                              .map((std) =>
                                              DropdownMenuItem<String>(
                                                  onTap: () {
                                                    stdId = std.id;
                                                    if (stdId != null) {
                                                      setState(() {
                                                        orderHistorySchoolDivisionVm
                                                            .isLoading
                                                            .value = true;
                                                        selectedDiv =
                                                        null;
                                                        orderHistorySchoolDivisionVm
                                                            .getOhSchoolDivisionDropdown(
                                                            stdId!);
                                                      });
                                                    }
                                                  },
                                                  value: std.text,
                                                  child: Text(
                                                    std.text.toString(),
                                                    style: TextStyle(
                                                        fontSize: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .height /
                                                            35,
                                                        fontFamily:
                                                        "NotoSans",
                                                        color: Colors
                                                            .black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400),
                                                  )))
                                              .toList(),
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
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            45,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        color: const Color(0xff3B3B3B)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                        MediaQuery.of(context).size.height /
                                            60,
                                        bottom:
                                        MediaQuery.of(context).size.height /
                                            40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the border radius as needed
                                      ),
                                      height:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(Icons.arrow_drop_down),
                                              openMenuIcon:
                                              Icon(Icons.arrow_drop_up)),
                                          hint: Text(
                                            "Select Division",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    38,
                                                fontFamily: "NotoSans",
                                                color: const Color(0xFF3B3B3B),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          value: selectedDiv,
                                          buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    100),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        192, 195, 207, 1))),
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                13,
                                            width: double.infinity,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                              maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  2.5,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.5))),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                15,
                                          ),
                                          items: orderHistorySchoolDivisionVm
                                              .ohSchoolDivisionDropListVm
                                              .map((div) =>
                                              DropdownMenuItem<String>(
                                                  onTap: () {
                                                    divId = div.id;
                                                  },
                                                  value: div.text,
                                                  child: Text(
                                                    div.text.toString(),
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .height /
                                                            35,
                                                        fontFamily:
                                                        "NotoSans",
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400),
                                                  )))
                                              .toList(),
                                          onChanged: (div) {
                                            setState(() {
                                              selectedDiv = div;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///Enter Order ID Field
                                  Text(
                                    'Order ID',
                                    style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            45,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        color: const Color(0xff3B3B3B)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                        MediaQuery.of(context).size.height /
                                            60,
                                        bottom:
                                        MediaQuery.of(context).size.height /
                                            40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the border radius as needed
                                      ),
                                      height:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      child: TextFormField(
                                        controller: orderIdController,
                                        onTapOutside: (value) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            setState(() {});
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Enter Order ID',
                                            hintStyle: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  45,
                                              fontFamily: 'NotoSans',
                                            ),
                                            filled: true,
                                            isDense: true,
                                            fillColor: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffA8A8A8)))),
                                      ),
                                    ),
                                  ),

                                  ///Enter Invoice ID Field
                                  Text(
                                    'Invoice ID',
                                    style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            45,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        color: const Color(0xff3B3B3B)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                        MediaQuery.of(context).size.height /
                                            60,
                                        bottom:
                                        MediaQuery.of(context).size.height /
                                            40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the border radius as needed
                                      ),
                                      height:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      child: TextFormField(
                                        controller: invoiceIdController,
                                        onTapOutside: (value) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            setState(() {});
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Enter Invoice ID',
                                            hintStyle: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  45,
                                              fontFamily: 'NotoSans',
                                            ),
                                            filled: true,
                                            isDense: true,
                                            fillColor: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    color: Color(0xffA8A8A8)))),
                                      ),
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

                  ///Apply Button
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 80)),
                    height: MediaQuery.of(context).size.height / 15,
                    color: const Color.fromRGBO(115, 103, 240, 1),
                    minWidth: double.infinity,
                    onPressed: () async {
                      if (selectedTime == null) {
                        toastMessage(context, 'Please select time!');
                      } else if (timeId == 5 &&
                          (fromController.text.isEmpty ||
                              toController.text.isEmpty)) {
                        if (fromController.text.isEmpty) {
                          toastMessage(context, 'Please select fromDate!');
                        } else if (fromController.text.isNotEmpty &&
                            toController.text.isEmpty) {
                          toastMessage(context, 'Please select toDate!');
                        }
                      }
                      /*  else if(selectSchool == null){
                          toastMessage(context, 'Please select school!');
                        }
                        else if(selectedStd == null && orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.isNotEmpty){
                          toastMessage(context, 'Please select standard!');
                        }
                        else if(selectedDiv == null && orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.isNotEmpty){
                          toastMessage(context, 'Please select division!');
                        }*/

                      else {
                        storedFromDate =
                            DateFormat('yyyy-MM-dd').format(fromDate!);
                        storedToDate = DateFormat('yyyy-MM-dd').format(toDate!);
                        getOrderHistoryVm.orderHistoryListVm.clear();
                        getOrderHistoryVm.invoiceListVm.clear();
                        getOrderHistoryVm.isLoading.value = true;
                        if(selectedIndex == 0){
                          AllRecordState.page = 1;
                          AllRecordState.hasNextPage = true;
                        }
                        else if(selectedIndex == 1){
                          CompletedRecordState.page = 1;
                          CompletedRecordState.hasNextPage = true;
                        }
                        else if(selectedIndex == 2){
                          PendingRecordState.page = 1;
                          PendingRecordState.hasNextPage = true;
                        }
                        await getOrderHistoryVm.getOrderHistoryVm(
                            selectedIndex == 0?AllRecordState.page:selectedIndex == 1?CompletedRecordState.page:PendingRecordState.page,
                            orderHistorySearchCtx.text,
                            selectedIndex == 0
                                ? 0
                                : selectedIndex == 1
                                ? 2
                                : 1,
                            timeId!,
                            storedFromDate!,
                            storedToDate!,
                            selectSchoolId ?? 0,
                            stdId ?? 0,
                            divId ?? 0,
                            orderIdController.text,
                            invoiceIdController.text);
                        _scaffoldKey.currentState!.closeEndDrawer();
                      }
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                          fontSize: MediaQuery.of(context).size.height / 45),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 35,
            right: MediaQuery.of(context).size.width / 35,
            top: MediaQuery.of(context).size.height / 60,
          ),
          child: ListView(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: selectedIndex == 0
                        ? 'Order History'
                        : 'Order History >> ',
                    style: TextStyle(
                        color: selectedIndex == 0
                            ? const Color.fromRGBO(115, 103, 240, 1)
                            : const Color(0xff272727),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                        fontSize: MediaQuery.of(context).size.width / 75),
                  ),
                  TextSpan(
                      text: selectedIndex == 0
                          ? ''
                          : selectedIndex == 1
                          ? 'Completed'
                          : 'Pending',
                      style: TextStyle(
                          color: const Color(0xff5448D2),
                          fontFamily: "NotoSans",
                          fontSize: MediaQuery.of(context).size.width / 75,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Container(
                height: MediaQuery.of(context).size.height / 10,
                decoration: BoxDecoration(
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
                    horizontal: MediaQuery.of(context).size.width / 50,
                    vertical: MediaQuery.of(context).size.height / 45,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          style: TextStyle(fontSize: MediaQuery.of(context).size.height / 45),
                          controller: orderHistorySearchCtx,
                          onChanged: (value) {
                            if (timer?.isActive ?? false) timer!.cancel();
                            timer = Timer(const Duration(milliseconds: 1000), () {
                              _filterOrderHistory(value);
                            });
                          },
                          maxLength: 50,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 45,
                            ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: const Color.fromRGBO(129, 129, 129, 1),
                              fontSize: MediaQuery.of(context).size.height / 50,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/images/order_history_images/search.svg',
                                height: 2,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            suffixIcon: orderHistorySearchCtx.text.isNotEmpty?GestureDetector(
                                onTap: () {
                                  setState(() {
                                    orderHistorySearchCtx.clear();
                                    searchOrderText = '';
                                    getOrderHistoryVm.orderHistoryListVm.clear();
                                    getOrderHistoryVm.invoiceListVm.clear();
                                    invoicePopupVm.invoiceDataListVm.clear();
                                    getOrderHistoryVm.isLoading.value = true;
                                    selectSchoolId = null;
                                    if(selectedIndex == 0){
                                      AllRecordState.page = 1;
                                      AllRecordState.hasNextPage = true;
                                      getOrderHistoryVm.getOrderHistoryVm(
                                          AllRecordState.page, orderHistorySearchCtx.text,0, 0, '', '', 0, 0, 0, '', '');
                                    }
                                    else if(selectedIndex == 1){
                                      CompletedRecordState.page = 1;
                                      CompletedRecordState.hasNextPage = true;
                                      getOrderHistoryVm.getOrderHistoryVm(
                                          CompletedRecordState.page, orderHistorySearchCtx.text,2, 0, '', '', 0, 0, 0, '', '');
                                    }
                                    else if(selectedIndex == 2){
                                      PendingRecordState.page = 1;
                                      PendingRecordState.hasNextPage = true;
                                      getOrderHistoryVm.getOrderHistoryVm(
                                          PendingRecordState.page, orderHistorySearchCtx.text,1, 0, '', '', 0, 0, 0, '', '');
                                    }
                                  });
                                },
                                child: Icon(Icons.cancel_outlined,
                                    size:
                                    MediaQuery.of(context).size.height / 25,
                                    color: Colors.redAccent)):const SizedBox.shrink(),
                            filled: true,
                            fillColor: const Color.fromRGBO(243, 243, 243, 1),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 25),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            ///Search Button
                            /*      MaterialButton(
                              height: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: const Color.fromRGBO(115, 103, 240, 1),
                              onPressed: () {},
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            ),*/
                            const Spacer(),
                            GestureDetector(
                                onTap: (){
                                  downloadExcel();
                                },
                                child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.width/55,
                                    backgroundColor: const Color(0xFFE0DDFC),
                                    child: SvgPicture.asset("assets/images/dashboard_img/excel_icon.svg",height: MediaQuery.of(context).size.height/29))),
                            SizedBox(width: MediaQuery.of(context).size.width/40),
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                                setState(() {
                                  selectedStd = null;
                                  selectedDiv = null;
                                  selectSchool = null;
                                  orderHistorySchoolStandardDropdownVM
                                      .ohSchoolStdListVm
                                      .clear();
                                  orderHistorySchoolDivisionVm
                                      .ohSchoolDivisionDropListVm
                                      .clear();
                                });
                              },
                              child: CircleAvatar(
                                  radius:
                                  MediaQuery.of(context).size.width / 60,
                                  backgroundColor: const Color(0xFFE0DDFC),
                                  child: SvgPicture.asset(
                                      "assets/images/dashboard_img/filter_icon.svg")),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 30,
                ),
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.06),
                          blurRadius: 2,
                          spreadRadius: 0.5,
                        )
                      ],
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Card(
                      elevation: 0,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            TabBar(
                              controller: tabController,
                              indicatorColor:
                              const Color.fromRGBO(115, 103, 240, 1),
                              indicatorPadding: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.width / 20),
                              unselectedLabelStyle: TextStyle(
                                  color: const Color(0xFF818181),
                                  fontFamily: 'NotoSans',
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                  MediaQuery.of(context).size.height / 40),
                              labelStyle: TextStyle(
                                  color: const Color(0xFF4D3FD9),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize:
                                  MediaQuery.of(context).size.height / 40),
                              labelColor: const Color(0xFF4D3FD9),
                              unselectedLabelColor: const Color(0xFF818181),
                              tabs: const [
                                Tab(text: 'All',),
                                Tab(text: 'Completed'),
                                Tab(text: 'Pending'),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 1.8,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  AllRecord(
                                    getOrderHistory: getFilteredOrderHistory,
                                  ),
                                  CompletedRecord(
                                      getOrderHistory: getFilteredOrderHistory),
                                  PendingRecord(
                                      getOrderHistory: getFilteredOrderHistory),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
