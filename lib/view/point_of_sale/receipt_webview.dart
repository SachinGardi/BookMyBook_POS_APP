import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuck_shop/view/common_widgets/progress_indicator.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import '../../utility/base_url.dart';
import '../../view_modal/print_invoice_vm/view_modal.dart';




class ReceiptWebView extends StatefulWidget {
  const ReceiptWebView({Key? key}) : super(key: key);

  @override
  State<ReceiptWebView> createState() => ReceiptWebViewState();
}

PrintReceiptVm printReceiptVm = Get.put(PrintReceiptVm());

class ReceiptWebViewState extends State<ReceiptWebView> {
  InAppWebViewController? webViewController;
  String? encodedDecryptedUrl;
  var receiptLoader = true.obs;
  String encryptionKey = '8080808080808080';
  var encryptedInvoiceId;
  bool isSharing = false;

  ///Print Receipt data
  apiCalling() async {
    printReceiptVm.receiptListVm.clear();
    printReceiptVm.isLoading.value = true;
    await printReceiptVm.getReceiptDetail(Get.arguments[0]);
    print(Get.arguments[0]);
    print(Get.arguments[0]);
    print(Get.arguments[0]);
    print(Get.arguments[0]);
  }
  int? argIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    argIndex = Get.arguments[1];
    final key = encrypt.Key.fromUtf8(encryptionKey);
    final iv = encrypt.IV.fromUtf8(encryptionKey);
    final encrypter =
    encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    encryptedInvoiceId = encrypter.encrypt(Get.arguments[0], iv: iv);
    encodedDecryptedUrl = Uri.encodeComponent(encryptedInvoiceId.base64).replaceAll('%20', '+');
    apiCalling();
  }
  ///Pos page Redirection  Popup

  Future<void> posRedirection(BuildContext context) async {
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
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width/51,
                                vertical: MediaQuery.of(context).size.height /60
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Confirmation',
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
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/80),
                      child: Text(argIndex == 1?
                      'Are You Sure You Want to Redirect to The POS Screen?':
                      'Are You Sure You Want to Redirect to The Order History Screen?',
                        style: TextStyle(
                            fontFamily: "NotoSans",
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height /35,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                                        "No",
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
                              Get.offAllNamed("/dashboard", arguments:argIndex);
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
                                        "Yes",
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
                    SizedBox(height: MediaQuery.of(context).size.height /55),
                  ],
                ),
              ),
            ),
          );
        });

  }



  Future<void> shareReceipt() async {
    Timer(Duration(seconds: 3),(){
      isSharing = false;
    });
    await Share.share("$pdfBaseUrl$encodedDecryptedUrl");
  }



  ///For the Bluetooth Permission Handling
  Future<void> _checkBluetoothStatus() async {
    bool bluetoothStatus = await Permission.bluetooth.serviceStatus.isEnabled;
    print(bluetoothStatus);
    if (bluetoothStatus == false) {
      bluetoothPrint.disconnect();
      bluetoothPrint.stopScan();
      isConnectedTest = false;
      _showEnableBluetoothDialog();
    }
    else{
      if (isConnectedTest == true) {
        await printReceipt(context);

        Timer(const Duration(seconds: 4), () {
          posRedirection(context);
        });
      }
      else{
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return DeviceListBottomSheet();
          },
        );
      }

    }
  }

  void _showEnableBluetoothDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Bluetooth'),
          content: Text('Please enable your device\'s Bluetooth.'),
          actions: <Widget>[
            MaterialButton(
              child: Text('Open Settings'),
              onPressed: () {
                openBluetoothSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void openBluetoothSettings() async {
    AndroidIntent intent = const AndroidIntent(
      action: 'android.settings.BLUETOOTH_SETTINGS',
    );

    await intent.launch();
  }



  ///For the location Handling
  Future<void> _checkLocationStatus() async {
    PermissionStatus appLocationStatus = await Permission.location.request();
    if (appLocationStatus.isPermanentlyDenied || appLocationStatus.isDenied) {
      await Permission.location.request();
      if (appLocationStatus == PermissionStatus.permanentlyDenied ||
          appLocationStatus == PermissionStatus.denied ) {
        {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 3),
              content: Row(
                children: [
                  const Text("Please allow all permissions"),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      child: Text("setting".tr))
                ],
              ),
            ));
          });
        }
      }

    } else if (appLocationStatus.isGranted) {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        _showEnableLocationDialog();
      }
      else {
        _checkBluetoothStatus();
      }
    }
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Location'),
          content: Text('Please enable your device\'s location.'),
          actions: <Widget>[
            MaterialButton(
              child: Text('Open Settings'),
              onPressed: () {
                Get.back();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 5,
              backgroundColor: const Color(0xFF7367F0),
              title: Text("Payment Invoice",
                style: TextStyle(
                    fontFamily: "NotoSansSemiBold",
                    fontSize: MediaQuery.of(context).size.height/30
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [

                GestureDetector(
                  onTap: () async {
                    if(isSharing ==  false){
                      isSharing = true;
                      await shareReceipt();
                    }
                  },
                  child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width /9.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.share,color: const Color(0xff7367F0),size:MediaQuery.of(context).size.height/30),

                                Text(
                                  "Share",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                      MediaQuery.of(context).size.height /45,
                                      fontFamily: "NotoSans",
                                      color:  Colors.black),
                                ),
                              ],
                            )),
                      )),
                ),
                SizedBox(width: MediaQuery.of(context).size.width /35,),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _checkLocationStatus();
                    });

                  },
                  child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width /9.5,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.print,color: const Color(0xff7367F0),
                                  size:MediaQuery.of(context).size.height/25,
                                ),

                                Text(
                                  "Print",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                      MediaQuery.of(context).size.height /45,
                                      fontFamily: "NotoSans",
                                      color: Colors.black),
                                ),
                              ],
                            )),
                      )),
                ),
                SizedBox(width: MediaQuery.of(context).size.width /38),
                GestureDetector(
                    onTap: () async {
                      Get.offAllNamed("/dashboard", arguments: Get.arguments[1]);
                    },
                    child: Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width /10,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Get.arguments[1]== 1?
                                    SvgPicture.asset(
                                        'assets/images/dashboard_img/pos_icon.svg',
                                        color:const Color(0xff7367F0),
                                        height:MediaQuery.of(context).size.height/40,
                                        width: MediaQuery.of(context).size.width/30):
                                    Icon(Icons.arrow_back_ios,color: Color(0xff7367F0),
                                        size: MediaQuery.of(context).size.height/30),
                                    Text(Get.arguments[1]== 1?
                                    "New Order": "Back",
                                      style: TextStyle(
                                          fontSize: Get.arguments[1]== 1?MediaQuery.of(context).size.height /50:
                                          MediaQuery.of(context).size.height /45,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: "NotoSans",
                                          color:  Colors.black),
                                    ),
                                  ],
                                ))))),
                SizedBox(width: MediaQuery.of(context).size.width /30),


              ],
            ),
            body: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Obx(
                        () => ModalProgressHUD(
                        inAsyncCall: receiptLoader.value == true,
                        progressIndicator: progressIndicator(),
                        child: InAppWebView(
                            initialUrlRequest: URLRequest(
                                url: Uri.parse("$pdfBaseUrl$encodedDecryptedUrl")),
                            onWebViewCreated: (InAppWebViewController controller) {
                              webViewController = controller;
                            },
                            onLoadStart: (InAppWebViewController controller, url) {
                              print("onLoadStart URL : $url");
                            },
                            onLoadStop: (InAppWebViewController controller, url) async {
                              receiptLoader.value = false;
                              print("onLoadStop URL : $url");
                            },
                            initialOptions: InAppWebViewGroupOptions(
                                crossPlatform: InAppWebViewOptions(
                                  useShouldOverrideUrlLoading: true,
                                  mediaPlaybackRequiresUserGesture: false,
                                  javaScriptCanOpenWindowsAutomatically: true,
                                  useShouldInterceptFetchRequest: true,
                                ),
                                android: AndroidInAppWebViewOptions(
                                  useShouldInterceptRequest: true,
                                  useHybridComposition: true,
                                ),
                                ios: IOSInAppWebViewOptions(
                                  allowsInlineMediaPlayback: true,
                                ))))))));
  }
}

bool? isConnectedTest;

Future<void> printReceipt(BuildContext context) async {

  /// \x1B\x21\x00 sets the text to the default/normal size.
  /// \x1B\x21\x01 is used to set a smaller font size.
  /// \x1B\x21\x02 is a hypothetical larger font size command (the exact sequence might vary depending on the printer).


  if (isConnectedTest == true) {
    Map<String, dynamic> config = Map();
    List<LineText> list = [];
    var dividerLine = LineText(
      weight: 2,
      type: LineText.TYPE_TEXT,
      content: '------------------------------------------------',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    );
    int maxItemWidth = 29;
    int maxCGSTWidth = 6;
    int maxSGSTWidth = 6;
    int maxQtyWidth = 4;
    int maxAmtWidth = 4;


    list.add(LineText(
        fontZoom: 4,
        type: LineText.TYPE_TEXT,
        content: 'VYANKATESH TRADING',
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
        weight: 2
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'GST NO : 27AQEPK4036A1ZC',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    list.add(LineText(
        size: 1,
        fontZoom: 2,
        type: LineText.TYPE_TEXT,
        content: 'EKLAVYA NOTEBOOKS',
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
        weight: 2
    ));
    list.add(LineText(
      size: 2,
      fontZoom: 2,
      type: LineText.TYPE_TEXT,
      content: 'GST NO : 27AAFFE4247G1Z',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));
    list.add(LineText(
      size: 2,
      fontZoom: 2,
      type: LineText.TYPE_TEXT,
      content: ' PHONE : 9309519009',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'INVOICE',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    list.add(dividerLine);

    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content:
      'Date : ${DateFormat('dd-MM-yyyy   hh:mm a').format(invoiceDatee!)}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));

    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'Invoice No: ${invoiceNo!}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'Payment Mode: ${payment!}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    remark == "" || remark == null?"":list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'Remark: ${remark!}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'School: ${schoolName!}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));

    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'Student: ${studentName!}   Std: ${standard!}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'Mobile No.: ${customerMobileNo!}',
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    list.add(dividerLine);


    ///Items
    String header = 'Items'.padRight(maxItemWidth) +
        'CGST'.padRight(maxCGSTWidth) +
        'SGST'.padRight(maxSGSTWidth) +
        'Amt'.padRight(maxAmtWidth);

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: header,
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    list.add(dividerLine);



    for (var item in printReceiptVm.itemListVm) {
      String itemName = item.item;
      List<String> wrappedNameLines = [];

      while (itemName.isNotEmpty) {
        if (itemName.length > maxItemWidth) {
          int splitIndex = itemName.substring(0, maxItemWidth).lastIndexOf(' ');
          if (splitIndex <= 0) {
            splitIndex = maxItemWidth;
          }
          wrappedNameLines.add(itemName.substring(0, splitIndex));
          itemName = itemName.substring(splitIndex).trimLeft();
        } else {
          wrappedNameLines.add(itemName);
          itemName = '';
        }
      }
      int itemNameLinesCount = wrappedNameLines.length;


      for (int i = 0; i < itemNameLinesCount; i++) {
        String cgstContent = (i == 0 && item.cgstAmount != 0) ? item.cgstAmount.toStringAsFixed(2).padRight(maxCGSTWidth) : ' '.padRight(maxCGSTWidth);
        String sgstContent = (i == 0 && item.sgstAmount != 0) ? item.sgstAmount.toStringAsFixed(2).padRight(maxSGSTWidth) : ' '.padRight(maxSGSTWidth);
        // String qtyContent = (i == 0) ? item.qty.toString().padRight(maxQtyWidth) : '';
        String amtContent = (i == 0) ? item.amount.toStringAsFixed(2).padRight(maxAmtWidth) : '';

        String contentLine = wrappedNameLines[i].padRight(maxItemWidth) +
            cgstContent + sgstContent + amtContent;


        if (i == 0 && item.cgst.toString().isNotEmpty && item.sgst.toString().isNotEmpty) {
          String gstPercentLine = '${item.price.toStringAsFixed(0)} * ${item.qty}'.padRight(maxItemWidth) + (item.cgst == 0 ? "":"${item.cgst.toStringAsFixed(1)}%").padRight(maxCGSTWidth) + (item.sgst == 0 ?"":"${item.sgst.toStringAsFixed(1)}%").padRight(maxSGSTWidth);
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: contentLine,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          ));
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: gstPercentLine,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          ));
        }
      }
    }


    /// SubTotal
    list.add(dividerLine);
    String subTotalHeader = 'SubTotal'.padRight(22) +
        ' ${totalQty!} Qty'.padRight(7) +
        ''.padRight(maxCGSTWidth) +
        'Rs.${subTotal!.toStringAsFixed(2)}'.padLeft(12);
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: subTotalHeader,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
        weight: 2
    ));

    /// Pending Items
    if(printReceiptVm.pendingItemListVm.isNotEmpty) {
      list.add(dividerLine);
      String header2 = 'Pending Items'.padRight(maxItemWidth) +
          'CGST'.padRight(maxCGSTWidth) +
          'SGST'.padRight(maxSGSTWidth) +
          // 'Qty'.padRight(maxQtyWidth) +
          'Amt'.padRight(maxAmtWidth);
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: header2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));
      list.add(dividerLine);
      for (var item in printReceiptVm.pendingItemListVm) {
        String itemName = item.item;
        List<String> wrappedNameLines = [];

        while (itemName.isNotEmpty) {
          if (itemName.length > maxItemWidth) {
            int splitIndex = itemName.substring(0, maxItemWidth).lastIndexOf(' ');
            if (splitIndex <= 0) {
              splitIndex = maxItemWidth;
            }
            wrappedNameLines.add(itemName.substring(0, splitIndex));
            itemName = itemName.substring(splitIndex).trimLeft();
          } else {
            wrappedNameLines.add(itemName);
            itemName = '';
          }
        }
        // Calculate the number of lines for itemName
        int itemNameLinesCount = wrappedNameLines.length;

        // Add columns (CGST, SGST, Quantity, Amount) in a horizontal line for each itemName line
        for (int i = 0; i < itemNameLinesCount; i++) {
          String cgstContent = (i == 0 && item.cgstAmount != 0) ? item.cgstAmount
              .toStringAsFixed(2).padRight(maxCGSTWidth) : ' '.padRight(maxCGSTWidth);
          String sgstContent = (i == 0 && item.sgstAmount != 0) ? item.sgstAmount
              .toStringAsFixed(2).padRight(maxSGSTWidth) : ' '.padRight(maxSGSTWidth);
          // String qtyContent = (i == 0) ? item.qty.toString().padRight(maxQtyWidth) : '';
          String amtContent = (i == 0) ? item.amount.toStringAsFixed(2).padRight(maxAmtWidth) : '';

          String contentLine = wrappedNameLines[i].padRight(maxItemWidth) + cgstContent + sgstContent + amtContent;

          if (i == 0 && item.cgst.toString().isNotEmpty && item.sgst.toString().isNotEmpty) {
            String gstPercentLine = '${item.price.toStringAsFixed(0)} * ${item.qty}'.padRight(maxItemWidth) +
                (item.cgst == 0 ? "" : "${item.cgst.toStringAsFixed(1)}%").padRight(maxCGSTWidth) +
                (item.sgst == 0 ? "" : "${item.sgst.toStringAsFixed(1)}%").padRight(maxSGSTWidth);

            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: contentLine,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
            ));
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: gstPercentLine,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
            ));
          }}}}
    list.add(dividerLine);


    String discountLine = ''.padRight(24)+ "Discount (-)".padRight(10) + ''.padRight(5) + discount!.toStringAsFixed(2).padLeft(maxAmtWidth);
    list.add(LineText(
      fontZoom: 5,
      type: LineText.TYPE_TEXT,
      content: discountLine,
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));

    /// Total
    list.add(dividerLine);
    list.add(LineText(
        fontZoom: 5,
        type: LineText.TYPE_TEXT,
        content:
        'TOTAL${''.padRight(32)} Rs.${total!.toStringAsFixed(2)}',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
        weight: 2));
    list.add(dividerLine);


    /// GST Breakup


    Map<double, double> cgstTotals = {};
    Map<double, double> sgstTotals = {};

// Calculate total CGST and SGST
    for (var item in printReceiptVm.gstBreakUpVm) {
      cgstTotals[item.cgst] = (cgstTotals[item.cgst] ?? 0) + item.cgstAmount;
      sgstTotals[item.sgst] = (sgstTotals[item.sgst] ?? 0) + item.sgstAmount;
    }

// Combine CGST and SGST totals and sort based on the key
    List<MapEntry<double, double>> combinedTotals = [];
    cgstTotals.forEach((cgst, total) {
      if (total != 0) {
        combinedTotals.add(MapEntry(cgst, total));
      }
    });
    sgstTotals.forEach((sgst, total) {
      if (total != 0) {
        combinedTotals.add(MapEntry(sgst, total));
      }
    });
    combinedTotals.sort((a, b) => a.key.compareTo(b.key));

// Construct the breakdown strings with alternating prefixes CGST and SGST
    String currentPrefix = 'CGST';
    List<String> breakdownList = combinedTotals.map((entry) {
      String prefix = currentPrefix;
      currentPrefix = (currentPrefix == 'CGST') ? 'SGST' : 'CGST';
      return ''.padRight(0) +
          '$prefix @ ${entry.key == entry.key.toInt() ? entry.key.toStringAsFixed(2) : entry.key.toStringAsFixed(2)} %'.padRight(16) +
          entry.value.toStringAsFixed(2).padLeft(5);
    }).toList();
    breakdownList == [] || breakdownList.isEmpty?"":list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Tax Breakup',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
        weight: 2
    ));
// Add the breakdown strings to the printing list
    for (var breakdown in breakdownList) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: breakdown,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));
    }



    breakdownList == [] || breakdownList.isEmpty?"":list.add(dividerLine);


    list.add(LineText(
        size: 4,
        fontZoom: 3,
        type: LineText.TYPE_TEXT,
        content: 'Disclaimer',
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
        weight: 2
    ));
    list.add(LineText(
      size: 4,
      fontZoom: 3,
      type: LineText.TYPE_TEXT,
      content: 'Please check the book set as per invoice.',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    list.add(dividerLine);
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Powered by Shaurya Technosoft Pvt. Ltd.',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    int numberOfEmptyLines = 2;
    for (int i = 0; i < numberOfEmptyLines; i++) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: ' ',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));
    }


    await bluetoothPrint.printReceipt(config, list);
  } else {
    toastMessage(context, 'Printer is not connected. Please connect to a device first.');
  }
}


BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
class DeviceListBottomSheet extends StatefulWidget {
  const DeviceListBottomSheet({super.key});

  @override
  DeviceListBottomSheetState createState() => DeviceListBottomSheetState();
}

Future<void> printToBluetoothPrinter(BluetoothDevice selectedDevice,BuildContext context) async {
  try {
    await bluetoothPrint.connect(selectedDevice);
    print("selectedDevice1$selectedDevice");
    bluetoothPrint.state.listen((state) async {
      print('cur device status: $state');
      if(state == 1){
        isConnectedTest = await bluetoothPrint.isConnected;
        toastMessage(context, "Printer connected successfully");
        Get.back();
      }
      else if(state == 0){
        isConnectedTest = await bluetoothPrint.isConnected;
        toastMessage(context, "Printer is not connected. Please connect to a device first.");
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
BluetoothDevice? selectedDevice;
class DeviceListBottomSheetState extends State<DeviceListBottomSheet> {
  bool isScanning = false;

  List<BluetoothDevice> devicesList = [];
  @override
  void initState() {
    super.initState();

    bluetoothPrint.disconnect();
    bluetoothPrint.stopScan();
    _initializeBluetooth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeBluetooth() async {
    await _startScan();
  }


  ///For searching bluetooth on devices
  Future<void> _startScan() async {
    if (!isScanning) {
      isScanning = true;
      await bluetoothPrint.startScan(timeout: const Duration(seconds: 4));
      _listenToBluetoothState();
      isScanning = false;
    }
  }


  ///searched Bluetooth devices list
  void _listenToBluetoothState() {
    bluetoothPrint.scanResults.listen((List<BluetoothDevice> devices) {
      if (mounted) {
        setState(() {
          for (var device in devices) {
            if (!devicesList.any(
                    (existingDevice) => existingDevice.address == device.address)) {
              devicesList.add(device);
            }
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: devicesList.isEmpty
                ? const Center(
                child:
                CircularProgressIndicator()) // Display loader when devicesList is empty
                : ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (BuildContext context, int index) {
                BluetoothDevice device = devicesList[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text("${device.address}"),
                  onTap: () {
                    setState(() {
                      selectedDevice = device;
                      print(selectedDevice);
                      if (selectedDevice != null) {
                        printToBluetoothPrinter(device,context);
                      } else {

                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




