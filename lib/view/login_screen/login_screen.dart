import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import '../../view_modal/login_view_modal/email_reset_password_vm.dart';
import '../../view_modal/login_view_modal/forgot_password_vm.dart';
import '../../view_modal/login_view_modal/login_get_school_vm.dart';
import '../../view_modal/login_view_modal/login_vm.dart';
import '../../view_modal/login_view_modal/verify_login_otp_vm.dart';
import '../common_widgets/progress_indicator.dart';
import 'login_widgets.dart';
import 'otp_design_widget.dart';
import 'package:countdown_widget/countdown_widget.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
late CountDownController countDownController;

String? selectedSchool;
String? schoolId;
bool forgotPass = false;
bool isSubmitClick = false;
var getOtp1 = false.obs;
var isShowResendBtn1 = true.obs;
var resendOtpbtn1 = false;
var otpVerifiedSuccessfully1 = false.obs;

final TextEditingController fieldOne1 = TextEditingController();
final TextEditingController fieldTwo1 = TextEditingController();
final TextEditingController fieldThree1 = TextEditingController();
final TextEditingController fieldFour1 = TextEditingController();

final userNameCtr = TextEditingController();
final userPassCtr = TextEditingController();
final forgotPassCtr = TextEditingController();
final newPassCtr = TextEditingController();
final confirmPassCtr = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {

  Future<dynamic> showExitDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(

          shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * 0.01,
              top: MediaQuery.of(context).size.width * 0.02
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsPadding: EdgeInsets.only(
            top:MediaQuery.of(context).size.width * 0.03 ,
            bottom:MediaQuery.of(context).size.width * 0.06,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          title: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close,size: 25,)),
              ),
              const Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 40,
              )
            ],
          ),
          content:  Container(
            width: MediaQuery.of(context).size.width/2,
            child:  Text(
              'Do you want to exit ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'NotoSans',
                fontSize: MediaQuery.of(context).size.height/25
              ),
            ),
          ),
          actions: [
            Container(
              height: MediaQuery.of(context).size.height/12,
              width: MediaQuery.of(context).size.width/8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient:  LinearGradient(colors: [
                  Colors.red,
                  Colors.redAccent.withOpacity(0.5)
                ],
                    begin:Alignment.topLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'No',
                  style: TextStyle(fontFamily: 'NotoSans'),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/12,
              width: MediaQuery.of(context).size.width/8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(colors: [
                  Color(0xff5448D2),
                  Color(0xff958BFF)
                ],
                    begin:Alignment.topLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  if(forgotPass){
                    setState(() {
                      obscureText = true;
                      forgotPass = false;
                      forgotPassCtr.clear();
                      getOtp1.value = false;
                      fieldOne1.clear();
                      fieldTwo1.clear();
                      fieldThree1.clear();
                      fieldFour1.clear();
                      userNameCtr.clear();
                      userPassCtr.clear();
                      errorText = null;
                      loginSchoolVM.getLoginSchools.clear();
                      selectedSchool = null;
                      Get.back();
                    });
                  }
                  else if(isSubmitClick){
                    setState(() {
                      obscureText = true;
                      forgotPass = false;
                      isSubmitClick = false;
                      forgotPassCtr.clear();
                      getOtp1.value = false;
                      newPassCtr.clear();
                      confirmPassCtr.clear();
                      fieldOne1.clear();
                      fieldTwo1.clear();
                      fieldThree1.clear();
                      fieldFour1.clear();
                      userNameCtr.clear();
                      userPassCtr.clear();
                      errorText = null;
                      loginSchoolVM.getLoginSchools.clear();
                      selectedSchool = null;
                      Get.back();
                    });
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  final loginSchoolVM = Get.put(LoginSchoolVM());
  final loginVm = Get.put(LoginVM());
  final forgotPasswordVm = Get.put(ForgotPasswordVm());
  final emailResetPasswordVm = Get.put(EmailResetPasswordVm());
  final verifyLoginOtpVm = Get.put(VerifyLoginOtpVm());
  final String securityKey = '8080808080808080';



  Duration dur = const Duration(seconds:60);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  final FocusNode emailFocusNode = FocusNode();
  bool obscureText = true;
  bool newPassObscureText = true;
  bool confirmPassObscureText = true;
  String? errorText;

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address.';
    } else if (!isValidEmail(value)) {
      return 'Please enter a valid email address.';
    }
    return null; // Email is valid
  }

  bool isValidEmail(String value) {
    // Implement your email validation logic here (regex, etc.)
    // Return true if the email is valid, false otherwise
    // For example:
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(value);
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if the email is valid before adding the listener

      emailFocusNode.addListener(() async {
        final emailIsValid = validateEmail(userNameCtr.text) == null;
        if (emailIsValid) {
          if (!emailFocusNode.hasFocus && userNameCtr.text.isNotEmpty) {
            loginSchoolVM.isLoading.value = true;
            await loginSchoolVM.getLoginSchoolVM(context, userNameCtr.text);
            setState(() {});
          }
        }
      });

      userNameCtr.clear();
      userPassCtr.clear();
      newPassCtr.clear();
      confirmPassCtr.clear();
      forgotPassCtr.clear();


      loginSchoolVM.isLoading.value = false;
      loginVm.isLoading.value = false;
      emailResetPasswordVm.isLoading.value = false;
      forgotPasswordVm.isLoading.value = false;
      verifyLoginOtpVm.isLoading.value = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

  }

  DateTime preBackPress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Widget content = Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Login Text
            Text(
              'Login',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(115, 103, 240, 1)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 20),

            ///EmailId
            Text(
              'Email ID',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 38,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSans',
                  color: const Color.fromRGBO(39, 39, 39, 1)),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 40,
                  bottom: MediaQuery.of(context).size.height / 40),
              child: TextFormField(
                controller: userNameCtr,
                focusNode: emailFocusNode,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 35,
                  fontFamily: 'NotoSans',
                ),
                onChanged: (value) async {
                  selectedSchool = null;
                  loginSchoolVM.getLoginSchools.clear();
                  setState(() {});
                  if (formKey.currentState!.validate()) {}
                },
                validator: (value) => validateEmail(value!),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(
                      r'\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]\s')),
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                maxLength: 128,
                decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Enter Email ID',
                    hintStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontFamily: 'NotoSans',
                    ),
                    errorStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/40
                    ),
                    contentPadding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 50,
                        bottom: MediaQuery.of(context).size.height / 50,
                        left: MediaQuery.of(context).size.width / 60),
                    filled: true,
                    isCollapsed: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(192, 195, 207, 1)))),
              ),
            ),

            Text(
              'Password',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 38,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSans',
                  color: const Color.fromRGBO(39, 39, 39, 1)),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 40,
                  bottom: MediaQuery.of(context).size.height / 60),
              child: TextFormField(
                controller: userPassCtr,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 35,
                  fontFamily: 'NotoSans',
                ),
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  setState(() {});
                  if (formKey.currentState!.validate()) {}
                },
                validator: (value) => validation(value, userPassCtr),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(
                      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: InputDecoration(
                  suffixIconConstraints: BoxConstraints.tight(
                      const Size(35, 16),
                  ),


                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child:obscureText
                            ? const Icon(
                          Icons.visibility_off,
                          color: Color(0xFF7367F0),
                        )
                            : const Icon(Icons.visibility,
                            color: Color(0xFF7367F0)) ,
                        ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width/60,
                      vertical: MediaQuery.of(context).size.height/50
                  ),
                    errorStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/40
                    ),

                    counterText: '',
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontFamily: 'NotoSans',
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 1),
                      isDense: true,
                    isCollapsed: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide:
                        const BorderSide(color: Color.fromRGBO(192, 195, 207, 1)))),
                obscureText: obscureText,
              ),
            ),


               Text(
                 'School',
                 style: TextStyle(
                     fontSize: MediaQuery.of(context).size.height / 38,
                     fontWeight: FontWeight.w600,
                     fontFamily: 'NotoSans',
                     color: const Color.fromRGBO(39, 39, 39, 1)),
               ),
               Padding(
                 padding: EdgeInsets.only(
                     top: MediaQuery.of(context).size.height / 40,
                     bottom: MediaQuery.of(context).size.height / 25),
                 child: DropdownButtonHideUnderline(
                   child: DropdownButton2<String>(
                     isExpanded: true,
                     iconStyleData: const IconStyleData(
                         icon: Icon(Icons.arrow_drop_down),
                         openMenuIcon: Icon(Icons.arrow_drop_up)),
                     hint: Text(
                       "Select",
                       style: TextStyle(
                           fontSize: MediaQuery.of(context).size.height / 38,
                           fontFamily: "NotoSans",
                           color: const Color(0xFF3B3B3B),
                           fontWeight: FontWeight.w400),
                     ),
                     value: selectedSchool,
                     buttonStyleData: ButtonStyleData(
                       padding: EdgeInsets.symmetric(
                           horizontal: MediaQuery.of(context).size.width / 100),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(1),
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
                     items: loginSchoolVM.getLoginSchools
                         .map((school) => DropdownMenuItem<String>(
                         onTap: () async {
                           loginSchoolVM.selectedSchoolId = school.id;
                           loginSchoolVM.selectedSchoolName = school.schools!;
                           SharedPreferences pref =
                           await SharedPreferences.getInstance();
                           pref.setInt('schoolId', school.id!);
                           pref.setString('schoolName', school.schools!);
                           print(loginSchoolVM.selectedSchoolId);
                           print(loginSchoolVM.selectedSchoolName);
                         },
                         value: school.schools,
                         child: Text(
                           school.schools.toString(),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                               fontSize: MediaQuery.of(context).size.height / 35,
                               fontFamily: "NotoSans",
                               color: Colors.black,
                               fontWeight: FontWeight.w400),
                         )))
                         .toList(),
                     onChanged: (school) {
                       setState(() {
                         selectedSchool = school;
                       });
                     },
                   ),
                 ),
               ),

            /// forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                    onTap: () {
                      setState(() {
                        forgotPass = true;
                        newPassObscureText = true;
                        confirmPassObscureText = true;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: MediaQuery.of(context).size.height / 40,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(25, 117, 255, 1),
                        ),
                      ),
                    ),
                  ),
            ),
            ///Login Button
            Padding(
                  padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 80)),
                    height: MediaQuery.of(context).size.height / 12,
                    color: const Color.fromRGBO(115, 103, 240, 1),
                    minWidth: double.infinity,
                    onPressed: () async {
                      if (selectedSchool == null &&
                          loginSchoolVM.getLoginSchools.isNotEmpty) {
                        toastMessage(context, 'Please select school');
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final key = encrypt.Key.fromUtf8(securityKey);
                        final iv = encrypt.IV.fromUtf8(securityKey);
                        final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc));
                        final encryptedPass = encrypter.encrypt(userPassCtr.text, iv: iv);
                        print('####${encryptedPass.base64}#####');
                        loginVm.isLoading.value = true;
                        loginVm.postLoginDetail(
                            context,
                            userNameCtr.text,
                            encryptedPass.base64,
                            selectedSchool == null?0:int.parse(loginSchoolVM.selectedSchoolId.toString()),
                            "fcmToken!");
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height / 35),
                    ),
                  ),
                )


          ],
        ),
      ),
    );

    if (forgotPass) {
      content = Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
        child: Form(
          key: formKey1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Forgot Password
                Text(
                  'Forgot Password',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 18,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(255, 118, 48, 1)),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),

                ///EmailId
                Text(
                  'Email ID',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 36,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(39, 39, 39, 1)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 40,
                      bottom: MediaQuery.of(context).size.height / 40),
                  child: TextFormField(
                    readOnly:getOtp1.value == true,
                    controller: forgotPassCtr,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 35,
                      fontFamily: 'NotoSans',
                    ),
                    onChanged: (value) {
                      loginSchoolVM.getLoginSchools.clear();
                      selectedSchool = null;
                      if (formKey1.currentState!.validate()) {}
                    },
                    onTapOutside: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                      final regExp = RegExp(emailPattern);
                      if (value!.isEmpty) {
                        return 'Please enter an email address.';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(
                          r'\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]\s')),
                    ],
                    maxLength: 60,
                    onFieldSubmitted: (value) async {},
                    decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Enter Email ID',
                        hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40,
                          fontFamily: 'NotoSans',
                        ),
                        contentPadding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50,
                            bottom: MediaQuery.of(context).size.height / 50,
                            left: MediaQuery.of(context).size.width / 60),
                        filled: true,
                        isCollapsed: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 1),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(192, 195, 207, 1)))),
                  ),
                ),
                ///Remember password textbutton
                getOtp1.value == false?GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = true;
                  forgotPass = false;
                  userNameCtr.clear();
                  userPassCtr.clear();
                  newPassCtr.clear();
                  confirmPassCtr.clear();
                  forgotPassCtr.clear();
                  errorText = null;
                  loginSchoolVM.getLoginSchools.clear();
                  selectedSchool = null;
                });
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Remember Password ?',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSans',
                      color: const Color.fromRGBO(25, 117, 255, 1)),
                ),
              )):const SizedBox.shrink(),
                Visibility(
                    visible: getOtp1.value == true,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OtpInput(fieldOne1, true),
                          OtpInput(fieldTwo1, true),
                          OtpInput(fieldThree1, true),
                          OtpInput(fieldFour1, true),

                        ],
                      ),
                    )),
                SizedBox(
                    height: MediaQuery.of(context).size.height /50),
                Visibility(
                  visible: getOtp1.value == true,
                  child:  Row(
                    children: [
                      const Spacer(),
                      Obx(()=> (isShowResendBtn1.value == true)?
                      GestureDetector(
                        onTap: () async {
                          if(resendOtpbtn1 == false){

                          }
                          dur  = const Duration(seconds: 60);

                          if (formKey1.currentState!.validate()) {
                            emailResetPasswordVm.isLoading.value = true;
                            await emailResetPasswordVm.emailResetPassword(
                                context, forgotPassCtr.text);
                          }


                        },
                        child: Padding(
                          padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/40,),
                          child: Text(
                            "Resend OTP",

                            style:  TextStyle(
                                decorationColor: const Color(0xFF505EBC),
                                decorationThickness: 1,
                                shadows: const [Shadow(color: Color(0xFF505EBC), offset: Offset(0, -4))],
                                decoration: TextDecoration.underline,
                                fontSize: MediaQuery.of(context).size.height / 30,
                                fontFamily: "NotoSans",
                                color: Colors.transparent),
                          ),
                        ),
                      ):
                      CountDownWidget(
                        duration: dur,
                        builder: (context, duration) {
                          return Text("${'Resend OTP in 00:'}${duration.inSeconds} ${'sec.'}",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height / 30,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontStyle: FontStyle.normal),
                          );
                        },
                        autoStart: true,

                        onFinish: () async {

                          isShowResendBtn1.value = true;
                          countDownController.restart();

                        },
                        onControllerReady: (controller) {
                          countDownController = controller;
                        },
                        onDurationRemainChanged: (duration) {
                          dur = duration;
                        },
                      )
                        ,
                      ),
                    ],
                  ),),
                SizedBox(
                    height:(getOtp1.value == true)? MediaQuery.of(context).size.height /60: 0),

                ///Submit Button
                GestureDetector(
                  onTap: () async {
                    if (formKey1.currentState!.validate() && getOtp1.value == false ) {
                      emailResetPasswordVm.isLoading.value = true;
                      await emailResetPasswordVm.emailResetPassword(
                          context, forgotPassCtr.text);
                      setState(() {});

                    }

                    else if(getOtp1.value == true){
                     if(fieldOne1.text.isEmpty && fieldTwo1.text.isEmpty && fieldThree1.text.isEmpty && fieldFour1.text.isEmpty){
                    toastMessage(context, "OTP is required",color: Colors.redAccent);
                    }
                    else if(fieldOne1.text == "" || fieldTwo1.text == "" ||fieldThree1.text == "" ||fieldFour1.text == ""){
                    toastMessage(context, "Invalid OTP",color: Colors.redAccent);
                    }
                    else{
                       verifyLoginOtpVm.isLoading.value = true;
                      await verifyLoginOtpVm.verifyLoginOtpVm(context, forgotPassCtr.text);
                       setState(() {
                         if (isSubmitClick) {
                           isSubmitClick = true;
                           forgotPass = false;
                         }
                       });


                     }



                    }



                  },
                  child: commonButton(context, (getOtp1.value == true)?'Verify':'Send OTP'),
                ),
                ///Submit Button
               /* Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).size.height / 25),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 80)),
                    height: MediaQuery.of(context).size.height / 12,
                    color: const Color.fromRGBO(115, 103, 240, 1),
                    minWidth: double.infinity,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        emailResetPasswordVm.isLoading.value = true;
                        await emailResetPasswordVm.emailResetPassword(
                            context, forgotPassCtr.text);
                      }
                      setState(() {
                        if (isSubmitClick) {
                          isSubmitClick = true;
                          forgotPassCtr.clear();
                        }
                      });
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSans',
                          fontSize: MediaQuery.of(context).size.height / 35),
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
      );
    }

    if (isSubmitClick == true) {
      content = Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
        child: Form(
          key: formKey2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Forgot Password
                Text(
                  'Reset Password',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                      color: const Color.fromRGBO(255, 118, 48, 1)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),

                ///New Password
                Text(
                  'New Password',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 38,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSans',
                      color: const Color.fromRGBO(39, 39, 39, 1)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 40,
                      bottom: MediaQuery.of(context).size.height / 40),
                  child: TextFormField(

                    controller: newPassCtr,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 35,
                      fontFamily: 'NotoSans',
                    ),
                    onTapOutside: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      if (RegExp(checkAll).hasMatch(value)) {}
                    },
                    autovalidateMode: newPassCtr.text.isNotEmpty
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: (value) => validation(value, newPassCtr,),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(
                          '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],

                    decoration: InputDecoration(
                        suffixIconConstraints: BoxConstraints.tight(
                          const Size(35, 16),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              newPassObscureText = !newPassObscureText;
                            });
                          },
                          child:newPassObscureText
                              ? const Icon(
                            Icons.visibility_off,
                            color: Color(0xFF7367F0),
                          )
                              : const Icon(Icons.visibility,
                              color: Color(0xFF7367F0)) ,
                        ),
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/60,
                            vertical: MediaQuery.of(context).size.height/50
                        ),
                        hintText: 'Enter New Password',
                        hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40,
                          fontFamily: 'NotoSans',
                        ),
                        errorStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.height/40
                        ),
                        filled: true,
                        isCollapsed: true,
                        isDense: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 1),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(192, 195, 207, 1)))),
                    obscureText: newPassObscureText,
                  ),
                ),

                ///Confirm New Password
                Text(
                  'Confirm New Password',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 38,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSans',
                      color: const Color.fromRGBO(39, 39, 39, 1)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 40,
                      bottom: MediaQuery.of(context).size.height / 40),
                  child: TextFormField(
                    controller: confirmPassCtr,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 35,
                      fontFamily: 'NotoSans',
                    ),
                    onTapOutside: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      if (RegExp(checkAll).hasMatch(value)) {}
                    },
                    autovalidateMode: confirmPassCtr.text.isNotEmpty
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: (value) => validation(value, confirmPassCtr),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(
                          '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    decoration: InputDecoration(
                        suffixIconConstraints: BoxConstraints.tight(
                          const Size(35, 16),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              confirmPassObscureText = !confirmPassObscureText;
                            });
                          },
                          child:confirmPassObscureText
                              ? const Icon(
                            Icons.visibility_off,
                            color: Color(0xFF7367F0),
                          )
                              : const Icon(Icons.visibility,
                              color: Color(0xFF7367F0)) ,
                        ),
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/60,
                            vertical: MediaQuery.of(context).size.height/50
                        ),
                        hintText: 'Confirm new Password',
                        hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40,
                          fontFamily: 'NotoSans',
                        ),
                        errorStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.height/40
                        ),
                        filled: true,
                        isCollapsed: true,
                        isDense: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 1),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(192, 195, 207, 1)))),
                    obscureText: confirmPassObscureText,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureText = true;
                        forgotPass = false;
                        isSubmitClick = false;
                        userNameCtr.clear();
                        userPassCtr.clear();
                        newPassCtr.clear();
                        confirmPassCtr.clear();
                        forgotPassCtr.clear();
                        loginSchoolVM.getLoginSchools.clear();
                        selectedSchool = null;
                        errorText = null;
                        getOtp1.value = false;
                        fieldOne1.clear();
                        fieldTwo1.clear();
                        fieldThree1.clear();
                        fieldFour1.clear();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 30),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Remember Password ?',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSans',
                              color: const Color.fromRGBO(25, 117, 255, 1)),
                        ),
                      ),
                    )),

                ///Update Button
                Padding(
                  padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 60),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 80)),
                    height: MediaQuery.of(context).size.height / 12,
                    color: const Color.fromRGBO(115, 103, 240, 1),
                    minWidth: double.infinity,
                    onPressed: ()   async {
                      if (formKey2.currentState!.validate()) {
                        final key = encrypt.Key.fromUtf8(securityKey);
                        final iv = encrypt.IV.fromUtf8(securityKey);
                        final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc));
                        final encryptedNewPass = encrypter.encrypt(newPassCtr.text, iv: iv);
                        final encryptedConfirmPass = encrypter.encrypt(confirmPassCtr.text, iv: iv);
                        print('####${encryptedNewPass.base64}#####');
                        print('####${encryptedConfirmPass.base64}#####');
                        forgotPasswordVm.isLoading.value = true;
                        print('######${forgotPassCtr.text}#####');
                        await forgotPasswordVm.forgotPassVm(context,encryptedNewPass.base64,
                            encryptedConfirmPass.base64, forgotPassCtr.text);
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSans',
                          fontSize: MediaQuery.of(context).size.height / 35),
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(preBackPress);
        final cantExit = timegap >= const Duration(seconds: 2);
        preBackPress = DateTime.now();
        if(isSubmitClick == true || forgotPass == true){
          showExitDialog(context);
        }
        else if (cantExit && (isSubmitClick == false && forgotPass == false)) {
          toastMessage(context,"Press back button again to exit");
          return false;
        }
        else{
          return true;
        }

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: loginSchoolVM.isLoading.value == true ||
                loginVm.isLoading.value == true ||
                emailResetPasswordVm.isLoading.value == true ||
                forgotPasswordVm.isLoading.value == true||
                verifyLoginOtpVm.isLoading.value == true,
            progressIndicator: progressIndicator(),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/login_images/login_banner.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                    child: Scaffold(
                      body: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/15),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context).size.width / 20,
                                ),
                            child: content,
                          ),
                        ],
                      ),
                    )
                )

              ],
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
            ),
      ),
    );
  }
}
