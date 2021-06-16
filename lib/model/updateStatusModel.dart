class UpdateStatusModel {
  bool success;

  UpdateStatusModel({this.success});

  factory UpdateStatusModel.fromJson(Map<String, dynamic> json) {
    return UpdateStatusModel(success: json['Success']);
  }
}
