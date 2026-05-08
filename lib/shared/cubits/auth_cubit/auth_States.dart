abstract class AuthStates {}

class AuthInitSatate extends AuthStates {}

//////////////////////////////////////

class ChangePasswordVisiability extends AuthStates {}

//////////////////////////////////////

class WorkerSignUpSuccessState extends AuthStates {}

class WorkerSignUpLoadingState extends AuthStates {}

class WorkerSignUpErrorState extends AuthStates {
  final String error;

  WorkerSignUpErrorState({required this.error});
}

//////////////////////////////////////

class UserSignUpSuccessState extends AuthStates {}

class UserSignUpLoadingState extends AuthStates {}

class UserSignUpErrorState extends AuthStates {
  final String error;

  UserSignUpErrorState({required this.error});
}

//////////////////////////////////////

class LoginSuccessState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState({required this.error});
}

//////////////////////////////////////

class LogOutSuccessState extends AuthStates {}

class LogOutLoadingState extends AuthStates {}

class LogOutErrorState extends AuthStates {
  final String error;

  LogOutErrorState({required this.error});
}

//////////////////////////////////////

/*class SendVerficationCodeSuccessState extends AuthStates {}

class SendVerficationCodeLoadingState extends AuthStates {}

class SendVerficationCodeErrorState extends AuthStates {
  final String error;

  SendVerficationCodeErrorState({required this.error});
}*/

//////////////////////////////////////

class DeleteUserAccSuccessState extends AuthStates {}

class DeleteUserAccLoadingState extends AuthStates {}

class DeleteUserAccErrorState extends AuthStates {
  final String error;

  DeleteUserAccErrorState({required this.error});
}

//////////////////////////////////////

class SendPhoneCodeSuccessState extends AuthStates {
  final String phone;
  final String userType;

  SendPhoneCodeSuccessState({
    required this.phone,
    required this.userType,
  });
}

class SendPhoneCodeLoadingState extends AuthStates {}

class SendPhoneCodeErrorState extends AuthStates {
  final String error;

  SendPhoneCodeErrorState({required this.error});
}

//////////////////////////////////////

class CheckPhoneCodeSuccessState extends AuthStates {
  final String phone;
  final String userType;

  CheckPhoneCodeSuccessState({
    required this.phone,
    required this.userType,
  });
}

class CheckPhoneCodeLoadingState extends AuthStates {}

class CheckPhoneCodeErrorState extends AuthStates {
  final String error;

  CheckPhoneCodeErrorState({required this.error});
}
