import 'dart:convert';

import 'package:fleet_management/app_translations.dart';
import 'package:fleet_management/application.dart';
import 'package:fleet_management/components/InputFormField.dart';
import 'package:fleet_management/model/sign_in_model.dart';
import 'package:fleet_management/screens/dashboard.dart';
import 'package:fleet_management/services/services.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fleet_management/repository/user_repository.dart' as userRp;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = "/LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  Color clr = Colors.grey[200];
  String countryCode, passWord, userId;
  bool visibility = true;
  bool showSpinner = false;
  final controller = TextEditingController();
  SignInModel signInModel;
  final _loginFormKey = GlobalKey<FormState>();

  void hideKb() {
    FocusScope.of(context).unfocus();
  }

  loginProcess() async {
    setState(() {
      showSpinner = true;
    });
    var form = _loginFormKey.currentState;
    if (form.validate()) {
      form.save();
      hideKb();
      var response = await signUser(userId, passWord, true);
      var status = response["Success"] as bool;
      print("++++++ status: "+status.toString());
      signInModel = SignInModel.fromJson(response);
      if (status/*signInModel.userId != null*/) {
        setState(() {
          showSpinner = false;
        });
        userRp.setCurrentUser(jsonEncode(response));
        userRp.currentUser.value = signInModel;
        userRp.currentUser.notifyListeners();

        if (userRp.currentUser.value.userId != null) {
          Navigator.pushReplacementNamed(context, DashBoard.id);
        }
      }else{
        setState(() {
          showSpinner = false;
        });
        final alert = AlertDialog(
          title: Text("Log"),
          content: Text(signInModel.errors),
          actions: [FlatButton(child: Text("OK"), onPressed: () {
            Navigator.pop(context);
          })],
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    // final prefs = await SharedPreferences.getInstance();
    // String lang = prefs.getString('lang') ?? '';
    // if (lang.isEmpty)
    onLocaleChange(Locale(languagesMap['German']));
    // else
    //   onLocaleChange(Locale(languagesMap[lang]));

    // onLocaleChange(Locale(languagesMap[userRp.getCurrentLanguage()]));
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  void _select(String language) {
    print("dd " + language);
    hideKb();
    // userRp.setCurrentLanguage(language);
    onLocaleChange(Locale(languagesMap[language]));
    // setState(() {
    //   // if (language == "German") {
    //   //   label = "Deutsche";
    //   // } else {
    //   //   label = language;
    //   // }
    //   label = AppTranslations.of(context).text("my_duty_schedule");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.of(context).text("login"),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.blue[800],
                  Colors.lightBlue[500],
                  Colors.blue[200],
                ]),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            // overflow menu
            onSelected: _select,
            icon: new Icon(Icons.language, color: Colors.white),
            itemBuilder: (BuildContext context) {
              return languagesList.map<PopupMenuItem<String>>((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: 'logoAnimation',
                      child: Image.asset(
                        "assets/images/fleet.png",
                        // height: 200.0,
                        // width: 200.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: InputFormField(
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText:
                            AppTranslations.of(context).text("no_username"),
                          ),
                        ]),
                        prefixIcon: Icon(
                          Icons.verified_user,
                          color: Colors.lightBlueAccent,
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          userId = value;
                        },
                        hintText: AppTranslations.of(context).text("username"),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          InputFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: AppTranslations.of(context)
                                      .text("no_password")),
                            ]),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.lightBlueAccent,
                            ),
                            obscureText: visibility,
                            hintText:
                            AppTranslations.of(context).text("password"),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  visibility = !visibility;
                                });
                              },
                              icon: visibility
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              color: Colors.black,
                            ),
                            onSave: (value) {
                              passWord = value;
                            },
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlueAccent),
                          shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          )),
                        ),
                        onPressed: () async {
                          loginProcess();
                        },
                        child: Text(
                          AppTranslations.of(context).text("login"),
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
