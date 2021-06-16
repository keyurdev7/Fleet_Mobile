import 'package:fleet_management/app_translations.dart';
import 'package:fleet_management/application.dart';
import 'package:fleet_management/model/dataListModel.dart';
import 'package:fleet_management/components/schedule_list.dart';
import 'package:fleet_management/model/updateStatusModel.dart';
import 'package:fleet_management/services/services.dart';
import 'package:flutter/material.dart';
import 'package:fleet_management/repository/user_repository.dart' as userRp;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  static String id = "/SplashScreen";

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String selectedDate;
  String startTime;
  String cuurentStatus;
  String endTime;
  bool isEnabled = true;

  DateTime startDate, endDate, date;
  bool spinner = false;
  ScheduleListModel scheduleListModel;
  UpdateStatusModel updateStatusModel;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  String dropdownValue = 'One';

  List<ScheduleListBlock> blocks = [];
  List<Map<String, dynamic>> dataList = [];
  List<ScheduleData> scheduleDataList = [];

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

    date = DateTime.now();
    getList(date);
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  Future getDates(DateTime date) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      getList(picked);
      setState(() {
        selectedDate = months[picked.month - 1] + " " + picked.year.toString();
      });
    }
  }

  void _select(String language) {
    print("dd " + language);
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

  void arrowPress(String direction) async {
    if (direction == "back") {
      date = date.subtract(Duration(days: 7));
    } else if (direction == "forward") {
      date = date.add(Duration(days: 7));
    }
    selectedDate = months[date.month - 1] + " " + date.year.toString();
    setState(() {});
    getList(date);
  }

  String arrangeDate(DateTime date) {
    String arrangedDate;
    var day = date.day.toString().length > 1
        ? date.day.toString()
        : "0" + date.day.toString();
    var month = date.month.toString().length > 1
        ? date.month.toString()
        : "0" + date.month.toString();
    arrangedDate = date.year.toString() + "-" + month + "-" + day;
    return arrangedDate;
  }

  Future getList(DateTime date) async {
    blocks.clear();
    scheduleDataList.clear();
    setState(() {
      spinner = true;
    });
    endDate = date.add(Duration(days: (7 - date.weekday)));
    startDate = date.subtract(Duration(days: (date.weekday - 1)));
    startTime = arrangeDate(startDate);
    endTime = arrangeDate(endDate);
    print('getList>>>' + startTime);
    print('getList>>>' + endTime);
    print('getList>>>' + userRp.currentUser.value.userId);
    print('getList>>>' + userRp.currentUser.value.token);
    var response =
    await getSchedule(startTime, endTime, userRp.currentUser.value.userId);
    setState(() {
      spinner = false;
    });
    if (response.isNotEmpty) {
      scheduleListModel = ScheduleListModel.fromList(response);
      for (var data in scheduleListModel.scheduleList) {
        scheduleDataList.add(data);
      }
      if (scheduleDataList.isNotEmpty) {
        cuurentStatus = scheduleDataList.first.status;
        if (cuurentStatus == "Accept" || cuurentStatus == "Reject") {
          setState(() {
            isEnabled = false;
          });
        }
        if (cuurentStatus == "New") {
          updateScheduleStatus("Read");
          setState(() {
            isEnabled = true;
          });
        } else {
          setState(() {
            for (var data in scheduleDataList) {
              String weekDate = getDateNumberFromDate(data.date);
              String weekDay = getDayFromDate(data.date);
              // var dateString = data.date.split("-");
              // String weekDate = dateString[2].split("T")[0];
              // String weekDay = getWeekDay(startDate, int.parse(weekDate));
              blocks.add(ScheduleListBlock(
                timeSlot: data.beginTime + " - " + data.endTime,
                labelText: data.service,
                day: weekDate,
                weekDay: weekDay,
              ));
            }
          });
          print(blocks);
        }
      }else{
        setState(() {
          isEnabled = false;
        });
      }
    }
  }

  Future updateScheduleStatus(String status) async {
    blocks.clear();
    scheduleDataList.clear();
    setState(() {
      spinner = true;
    });
    print('updateScheduleStatus>>>' + startTime);
    print('updateScheduleStatus>>>' + endTime);
    print('updateScheduleStatus>>>' + userRp.currentUser.value.userId);
    print('updateScheduleStatus>>>' + userRp.currentUser.value.userId);
    var response = await updateStatus(
        startTime,
        endTime,
        userRp.currentUser.value.userId,
        status,
        userRp.currentUser.value.token);
    setState(() {
      spinner = false;
    });
    if (response.isNotEmpty) {
      updateStatusModel = UpdateStatusModel.fromJson(response);

      if (updateStatusModel.success) {
        getList(date);
      }
    }
  }

  // get day from the date
  String getDayFromDate(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    return DateFormat('EEE').format(parseDate);
  }

  // get day from the date
  String getDateNumberFromDate(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    return DateFormat('d').format(parseDate);
  }

  String getWeekDay(DateTime date, int day) {
    int weekDay = day - date.weekday + 1;
    return weekDays[weekDay];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          AppTranslations.of(context).text("my_duty_schedule"),
          style: new TextStyle(color: Colors.white),
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
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[700], Colors.lightBlueAccent],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 4.0,
                          ),
                          // Text(
                          //   AppTranslations.of(context)
                          //       .text("my_duty_schedule"),
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 16.0,
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_outlined),
                                onPressed: () {
                                  arrowPress("back");
                                },
                                color: Colors.white,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (date != null) {
                                      getDates(date);
                                    } else {
                                      getDates(DateTime.now());
                                    }
                                  }),
                              Text(
                                selectedDate != null && selectedDate != ""
                                    ? selectedDate
                                    : months[DateTime.now().month - 1] +
                                    " " +
                                    DateTime.now().year.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_outlined),
                                onPressed: () {
                                  arrowPress("forward");
                                },
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                elevation: 2.0,
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.25, //1.2
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    child: Stack(children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: blocks.isNotEmpty
                            ? ListView(
                          children: blocks,
                        )
                            : Center(
                          child: Container(
                            child: Text(AppTranslations.of(context)
                                .text("no_duty_schedule")),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          // padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 130, // <-- Your width
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blue[500]),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        )),
                                  ),
                                  child: Text(
                                      AppTranslations.of(context)
                                          .text("btn_accept"),
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white)),
                                  onPressed: isEnabled ?() => updateScheduleStatus("Accept") : null,
                                  // {
                                  //   if (cuurentStatus == "Read")
                                  //     updateScheduleStatus("Accept");
                                  // },
                                ),
                              ),
                              SizedBox(width: 16),
                              SizedBox(
                                width: 130, // <-- Your width
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        Colors.red[500]),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16.0),
                                        )),
                                  ),
                                  child: Text(
                                      AppTranslations.of(context)
                                          .text("btn_decline"),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white)),
                                  onPressed: isEnabled ?() => updateScheduleStatus("Reject") : null,
                                  /*{
                                      if (cuurentStatus == "Read")
                                        updateScheduleStatus("Reject");
                                    }*/),
                              ),
                            ],
                          ))
                    ])
                  //   Padding(
                  //   padding: EdgeInsets.all(4.0),
                  //   child: blocks.isNotEmpty
                  //       ? ListView(
                  //           children: blocks,
                  //         )
                  //       : Center(
                  //           child: Container(
                  //             child: Text(AppTranslations.of(context)
                  //                 .text("no_duty_schedule")),
                  //           ),
                  //         ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
