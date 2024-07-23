import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/modal/profile/profile_modal.dart';
import 'package:tuck_shop/repository/profile/profile_repo.dart';
String? userName;
String? userDesignation;
String? userEmail;
String? userMob;
String? userDob;
String? userGender;


class ProfileVM extends GetxController{
  var isLoading = true.obs;
  List<ProfileModal> profileDetail = [];
  @override
  Future<void> onReady() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoading.value = true;
    profileDetail.clear();
    getProfileData(pref.getInt('userId')!.toString());
    super.onReady();
  }


  getProfileData(String userId)async{
    var data = await ProfileRepo.getProfileDetail(userId);
    if(data!= null){
      profileDetail = data;
      isLoading.value = false;
    }
    else{
      Timer(const Duration(seconds: 2),(){
        isLoading.value = false;
      });
    }
    for (var element in profileDetail) {
      userName= element.name;
    //  userDesignation = element.;
      userEmail = element.emailId;
      userMob = element.mobileNo;
      userDob= element.dob;
      userGender = element.gender;
    }

  }
}