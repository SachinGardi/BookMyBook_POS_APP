


import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/common_widgets/progress_indicator.dart';
import 'package:tuck_shop/view/dashboard/tabbar_dashboard_view.dart';
import 'package:tuck_shop/view/login_screen/login_widgets.dart';
import 'package:tuck_shop/view/profile_screen/profile_widegts.dart';
import 'package:tuck_shop/view_modal/profile/profile_vm.dart';
import '../../view_modal/change_password/change_password_vm.dart';


TextEditingController oldPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

int selectedIndex = 1;
class ProfileScreen extends StatefulWidget {
   const ProfileScreen({Key? key}) : super(key: key);


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
Color? profileBtn ;
Color? changePassBtn;
class _ProfileScreenState extends State<ProfileScreen> {
  ProfileVM profileVM =Get.put(ProfileVM());
  ChangePasswordVm changePasswordVm = Get.put(ChangePasswordVm());
  final _formKey = GlobalKey<FormState>();

  final String securityKey = '8080808080808080';


  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter,\none number, and one special character(!@#\$&*~)';
    }
    return null;
  }

  String? _validateMatch(String? value1, String? value2,) {
    if(value1!.isEmpty){
      return 'Please enter password!';
    }
    else if(value1.trim().length < 8){
      return 'Password must contain atleast 8 character!';
    }
    else if(!RegExp(checkSmallLetters).hasMatch(value1)){
      return 'Password must contain at least 1 small character!';
    }
    else if(!RegExp(checkCapitalLetters).hasMatch(value1)){
      return 'Password must contain at least 1 capital character!';
    }
    else if (!RegExp(checkNumbers).hasMatch(value1)) {
      return 'password must contain at least 1 number!';
    }
    else if (!RegExp(checkSpecial).hasMatch(value1)) {
      return 'password must contain at least 1 special character!';
    }
     else if (value1 != value2) {
      return 'New and Confirm password does not match!';
    }
    return null;
  }

  apiBinding()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    profileVM.isLoading.value = true;
    profileVM.profileDetail.clear();
    await profileVM.getProfileData(pref.getInt('userId')!.toString());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiBinding();
    if(selectedIndex == 2){
      changePassBtn = const Color.fromRGBO(243, 242, 255, 0.85);
      profileBtn = null;
    }


  }

  int _selectedBtnIndex = 2;

  Color saveBtn = const Color.fromRGBO(115, 103, 240, 1);
  Color cancelBtn = const Color.fromRGBO(255, 255, 255, 1);

  void _changeButtonColor(int buttonNumber) {
    setState(() {
      if (buttonNumber == 1) {
        selectedIndex = 1;
        profileBtn = const Color.fromRGBO(243, 242, 255, 0.85);
        changePassBtn = null;
      }  else if (buttonNumber == 2) {
        selectedIndex = 2;
        changePassBtn = const Color.fromRGBO(243, 242, 255, 0.85);
        profileBtn = null;
      }
    });
  }

  void _changePasswordButtonColor(int buttonNumber) {
    setState(() {
      if (buttonNumber == 2) {
        _selectedBtnIndex = 2;
        saveBtn = saveBtn;
        cancelBtn = cancelBtn;

      } else if (buttonNumber == 1) {
        _selectedBtnIndex = 1;
        cancelBtn = saveBtn;
        saveBtn = cancelBtn;
      }
    });
  }
  bool newPassword = false;
  bool confirmPassword = false;
  @override
  Widget build(BuildContext context) {

    Widget cardContent = Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 15,
            left: MediaQuery.of(context).size.width / 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: profileInfo(context,
                          labelName: 'Email ID', labelValue: (userEmail == null || userEmail == '')?'-': userEmail!),
                    ),
                    Expanded(
                      flex: 3,
                      child: profileInfo(context,
                          labelName: 'Mobile No.', labelValue: (userMob == null || userMob == '')?'-': userMob!),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
           /*     Row(
                  children: [
                    userDob == null?Expanded(
                      flex: 3,
                      child: profileInfo(context,
                          labelName: 'DOB', labelValue: (userDob == null || userDob == '')?'-': userDob!),
                    ):const SizedBox.shrink(),
                    userGender == null?Expanded(
                      flex: 3,
                      child: profileInfo(context,
                          labelName: 'Gender', labelValue:(userGender == null || userGender == '')?'-': userGender!),
                    ):const SizedBox.shrink(),
                  ],
                ),*/
              ],
            ),
          ),
        );


    if (selectedIndex == 2) {
      cardContent = Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 30,
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20,
            ),
        child:Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            children: [
              ///Old and New Password field
              Row(
                children: [
                  ///Old password field
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Old Password',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height /40,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSans',
                              color: const Color.fromRGBO(59, 59, 59, 1))),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 40,
                              bottom: MediaQuery.of(context).size.height / 40),
                          child: TextFormField(
                            maxLength: 20,
                            controller: oldPasswordController,
                            validator: (value)=>validation(value, oldPasswordController),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(
                                  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            onTapOutside: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              setState(() {});
                              if (_formKey.currentState!.validate()) {}
                            },
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 35,
                              fontFamily: 'NotoSans',
                            ),
                            decoration:  InputDecoration(
                                errorMaxLines: 2,
                                counterText: '',
                                hintText: 'Enter Old Password',
                                hintStyle: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height / 40,
                                    fontFamily: 'NotoSans',
                                ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/60,
                                  vertical: MediaQuery.of(context).size.height/40
                              ),
                              errorStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height/35
                              ),
                                filled: true,
                                isCollapsed: true,
                                isDense: true,
                                fillColor: const Color.fromRGBO(255, 255, 255, 1),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1),
                                  borderSide:
                                  const BorderSide(color: Color.fromRGBO(192, 195, 207, 1))),

                            ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/10),
                  ///New Password field
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Password',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSans',
                              color: const Color.fromRGBO(59, 59, 59, 1)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 40,
                              bottom: MediaQuery.of(context).size.height / 40),
                          child: TextFormField(
                            maxLength: 20,
                            controller: newPasswordController,
                            validator: (value)=>validation(value, newPasswordController),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(
                                  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            onTapOutside: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              setState(() {});
                              if (_formKey.currentState!.validate()) {}
                            },
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 35,
                              fontFamily: 'NotoSans',
                            ),
                            decoration:  InputDecoration(
                              errorMaxLines: 2,
                                suffixIconConstraints: BoxConstraints.tight(
                                  const Size(35, 32),
                                ),
                                counterText: '',
                                hintText: 'Enter New Password',
                                hintStyle: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height / 40,
                                    fontFamily: 'NotoSans'),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      newPassword = !newPassword;
                                    });
                                  },
                                  icon: Icon(
                                    // password ? Icons.visibility_off : Icons.visibility,
                                    newPassword ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFF7367F0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width/60,
                                    vertical: MediaQuery.of(context).size.height/40
                                ),
                                errorStyle: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height/35
                                ),
                                filled: true,
                                isCollapsed: true,
                                isDense: true,
                                fillColor: const Color.fromRGBO(255, 255, 255, 1),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(1),
                                    borderSide:
                                    const BorderSide(color: Color.fromRGBO(192, 195, 207, 1)))),
                            obscureText: !newPassword,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
            Row(
              children: [
                Expanded(
                flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm New Password',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'NotoSans',
                            color: const Color.fromRGBO(59, 59, 59, 1)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 40),
                        child: TextFormField(
                            obscureText: !confirmPassword,
                            maxLength: 20,
                            controller: confirmPasswordController,
                            validator: (value) => _validateMatch(value, newPasswordController.text),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(
                                  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            onTapOutside: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              setState(() {});
                              if (_formKey.currentState!.validate()) {}
                            },
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 35,
                              fontFamily: 'NotoSans',
                            ),
                            decoration:  InputDecoration(
                              errorMaxLines: 2,
                              suffixIconConstraints: BoxConstraints.tight(
                                const Size(35, 32),
                              ),
                              counterText: "",
                              hintText: 'Confirm New Password',
                              hintStyle: TextStyle(
                                fontSize: MediaQuery.of(context).size.height / 40,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'NotoSans',
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    confirmPassword = !confirmPassword;
                                  });
                                },
                                icon: Icon(
                                  confirmPassword ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF7367F0),
                                ),
                              ),

                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width/60,
                                  vertical: MediaQuery.of(context).size.height/40
                              ),
                              errorStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height/35
                              ),
                              filled: true,
                              isCollapsed: true,
                              isDense: true,
                              fillColor: const Color.fromRGBO(255, 255, 255, 1),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1),
                                  borderSide:
                                  const BorderSide(color: Color.fromRGBO(192, 195, 207, 1))),

                            )),

                      ),

                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(), // or other widgets
                ),
              ],

            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container()),
                SizedBox(width: MediaQuery.of(context).size.width/10,),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        elevation: 0,
                      height: MediaQuery.of(context).size.height/17,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side:  BorderSide(
                                color: const Color.fromRGBO(192, 195, 207, 1),
                                width: _selectedBtnIndex == 1?0:1
                            )
                        ),
                        color: _selectedBtnIndex == 1?cancelBtn:const Color.fromRGBO(255, 255, 255, 1),
                        onPressed: () {
                          _changePasswordButtonColor(1);
                        },
                        padding: EdgeInsets.symmetric(

                            horizontal: MediaQuery.of(context).size.width/16
                        ),
                        child:  Text('Cancel',style: TextStyle(
                            color: _selectedBtnIndex == 1?const Color.fromRGBO(255, 255, 255, 1):const Color.fromRGBO(177, 177, 177, 1),
                            fontSize: MediaQuery.of(context).size.height/50,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                        ),),
                      ),
                      MaterialButton(
                        elevation: 0,
                        height: MediaQuery.of(context).size.height/17,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                            side:  BorderSide(
                                color: const Color.fromRGBO(192, 195, 207, 1),
                                width: _selectedBtnIndex == 2?0:1
                            )
                        ),
                        color:_selectedBtnIndex == 2? saveBtn:const Color.fromRGBO(255, 255, 255, 1),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height/65,
                            horizontal: MediaQuery.of(context).size.width/16
                        ),
                        onPressed: () async {
                          _changePasswordButtonColor(2);
                            if (_formKey.currentState!.validate()) {
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              final key = encrypt.Key.fromUtf8(securityKey);
                              final iv = encrypt.IV.fromUtf8(securityKey);
                              final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc));
                              final encryptedOldPass = encrypter.encrypt(oldPasswordController.text, iv: iv);
                              final encryptedNewPass = encrypter.encrypt(confirmPasswordController.text, iv: iv);
                              print('####${encryptedOldPass.base64}#####');
                              print('####${encryptedNewPass.base64}#####');
                              changePasswordVm.isLoading.value = true;
                                await changePasswordVm.postPassword(pref.getInt('userId')!,encryptedOldPass.base64,encryptedNewPass.base64,context);
                            } else {
                              setState(() {});
                            }
                        },
                        child:Text('Save',style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height/50,
                            color: _selectedBtnIndex == 2?const Color.fromRGBO(255, 255, 255, 1):const Color.fromRGBO(177, 177, 177, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                        ),),
                      )
                    ],
                  ),
                ),

              ],
            )
          ],
          ),
        ));
    }

    return WillPopScope(
      onWillPop: () async{
        setState(() {
          currentIndex = 0;
          Get.offAndToNamed('/dashboard');
        });
        return false;
      },
      child: Scaffold(
        body: Obx(()=>
            ModalProgressHUD(
              inAsyncCall: profileVM.isLoading.value == true,
              progressIndicator: progressIndicator(),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: const Color.fromRGBO(241, 241, 241, 1),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.8,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/profile_images/Group 20152@2x.png'),
                        fit: BoxFit.cover),
                  ),
                ),

                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/profile_images/user.svg',
                                height: MediaQuery.of(context).size.height / 11,
                              ),
                              Expanded(
                                flex: 1,
                                child: ListTile(
                                  title: Text(
                                      (userName == null || userName == '')?'-': userName!,
                                    style: TextStyle(
                                        color: const Color.fromRGBO(243, 242, 255, 1),
                                        fontSize: MediaQuery.of(context).size.height / 32,
                                        fontFamily: 'NotoSans',
                                    ),
                                  ),
                                  subtitle:  Text(
                                    'Salesman',
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height / 45,
                                        color: const Color.fromRGBO(255, 118, 48, 1),
                                        fontFamily: 'NotoSans',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/60,),
                          Row(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height/15,
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width/40
                                  ),
                                  onPressed: () {
                                    _changeButtonColor(1);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: selectedIndex == 1
                                      ? const Color.fromRGBO(243, 242, 255, 0.85)
                                      : profileBtn,
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height / 31,
                                        fontFamily: 'NotoSans',
                                        color: selectedIndex == 1
                                            ? const Color.fromRGBO(39, 39, 39, 1)
                                            : const Color.fromRGBO(243, 242, 255, 1)),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: MediaQuery.of(context).size.height/15,
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width/40
                                  ),
                                  onPressed: () {
                                    _changeButtonColor(2);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: changePassBtn,
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height / 31,
                                        fontFamily: 'NotoSans',
                                        color: selectedIndex == 2
                                            ? const Color.fromRGBO(39, 39, 39, 1)
                                            : const Color.fromRGBO(243, 242, 255, 1)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height/20,
                        left: MediaQuery.of(context).size.width / 20,
                        right: MediaQuery.of(context).size.width / 20,
                      ),
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: cardContent,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
