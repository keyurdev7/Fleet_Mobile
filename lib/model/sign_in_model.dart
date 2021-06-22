class SignInModel {
  String userId;
  String email;
  String firstName;
  String lastName;
  String isAdmin;
  String password;
  String token;
  bool success;
  String errors;

  SignInModel(
      {this.password,
        this.userId,
        this.email,
        this.firstName,
        /*this.isAdmin,*/ this.lastName,
        this.token,
        this.success,
        this.errors});

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
        userId: json['UserId'],
        email: json['Email'],
        firstName: json['FirstName'],
        lastName: json['LastName'],
        // isAdmin: json['isAdmin'],
        password: json['password'],
        token: json['Token'],
        success: json['Success'],
        errors: json['Errors']);
  }
}
