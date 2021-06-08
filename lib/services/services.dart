import 'dart:convert';

import 'package:fleet_management/utils/URL.dart';
import 'package:http/http.dart' as http;

Future signUser(String userName,String password,bool isAdmin) async{
  http.Response response=await http.post(
    Uri.parse(urlSignIn),
      headers: {
        "Accept": "application/json",
        "content-type":"application/json"
      },
      body: jsonEncode(
          {
            "UserId": "",
            "Email": userName,
            "FirstName": "",
            "LastName": "",
            "IsAdmin": isAdmin,
            "Password": password
          }
      ),
  );
  if(response.statusCode==200){
    return jsonDecode(response.body);
  }
  else{
    return null;
  }
}

Future getSchedule(String startTime,String endTime,String userId) async{
  http.Response response=await http.post(
    Uri.parse(urlGetSchedule),
    headers: {
      "Accept": "application/json",
      "content-type":"application/json"
    },
    body: jsonEncode(
        {
          "UserId":userId,
          "BeginTime":startTime,
          "EndTime":endTime,
        }
    ),
  );
  if(response.statusCode==200){
    return jsonDecode(response.body);
  }
  else{
    return null;
  }
}