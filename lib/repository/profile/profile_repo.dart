import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../modal/profile/profile_modal.dart';
import '../../utility/base_url.dart';
class ProfileRepo {

  static List<ProfileModal> profileDetails= [];

  static getProfileDetail(String userId)async{
    var queryParams ={
      "UserId":userId,
    };

    Uri uri = Uri.http(baseUrl,"tuckshop/api/Login/GetUserProfile",queryParams);
    try{
        http.Response response =(await http.get(uri));
          if(response.statusCode == 200){
            Map temp  = json.decode(response.body);
            final data = ProfileModal.fromJson(temp['responseData']);
            profileDetails.add(data);
            return profileDetails;
          }
        }
        catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
  }

}