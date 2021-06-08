class ScheduleListModel{

  List<ScheduleData> scheduleList;

  ScheduleListModel({this.scheduleList});

  factory ScheduleListModel.fromList(List<dynamic> json){
    List<ScheduleData> list=[];
    for(var data in json){
      list.add(ScheduleData(
        beginTime: data['BeginTime'],
        date: data['DutyDate'],
        endTime: data['EndTime'],
        service: data['Service'],
        status: data['Status'],
      ));
    }
    return ScheduleListModel(scheduleList: list);
  }

}

class ScheduleData{

  String beginTime;
  String endTime;
  String date;
  String service;
  String status;

  ScheduleData({this.date,this.status,this.beginTime,this.endTime,this.service});

}