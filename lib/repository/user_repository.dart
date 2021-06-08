import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fleet_management/model/sign_in_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<SignInModel> currentUser = new ValueNotifier(SignInModel());

void setCurrentUser(String data) async{
  if(data!=null && data!=""){
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString(
        'current_user',
        data);
  }
}

Future<SignInModel> getCurrentUser() async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  if(prefs.containsKey('current_user')){
    currentUser.value=SignInModel.fromJson(json.decode(await prefs.getString('current_user')));
    currentUser.notifyListeners();
  }
  return currentUser.value;
}

Future<void> logout() async {
  currentUser.value = new SignInModel();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
  currentUser.notifyListeners();
}