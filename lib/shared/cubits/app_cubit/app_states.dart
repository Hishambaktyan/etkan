abstract class AppStates{}

class InitState extends AppStates{}

//////////////////////////////////////

class ChangeNavBarState extends AppStates{}

//////////////////////////////////////

class ChangeAvailabilityState extends AppStates{}

//////////////////////////////////////

class ChangeServiceActivityState extends AppStates{}

//////////////////////////////////////

class ChangePasswordVisiability extends AppStates{}

//////////////////////////////////////

class WorkerSignUpSuccessState extends AppStates{}

class WorkerSignUpLoadingState extends AppStates{}

class WorkerSignUpErrorState extends AppStates{
  final String error;

  WorkerSignUpErrorState({required this.error});

}

//////////////////////////////////////

class UserSignUpSuccessState extends AppStates{}

class UserSignUpLoadingState extends AppStates{}

class UserSignUpErrorState extends AppStates{
  final String error;

  UserSignUpErrorState({required this.error});

}

//////////////////////////////////////

class LoginSuccessState extends AppStates{}

class LoginLoadingState extends AppStates{}

class LoginErrorState extends AppStates{
  final String error;

  LoginErrorState({required this.error});

}

//////////////////////////////////////

class LogOutSuccessState extends AppStates{}

class LogOutLoadingState extends AppStates{}

class LogOutErrorState extends AppStates{
  final String error;

  LogOutErrorState({required this.error});

}

//////////////////////////////////////

class SendVerficationCodeSuccessState extends AppStates{}

class SendVerficationCodeLoadingState extends AppStates{}

class SendVerficationCodeErrorState extends AppStates{
  final String error;

  SendVerficationCodeErrorState({required this.error});


}

//////////////////////////////////////

class DeleteUserAccSuccessState extends AppStates{}

class DeleteUserAccLoadingState extends AppStates{}

class DeleteUserAccErrorState extends AppStates{
  final String error;

  DeleteUserAccErrorState({required this.error});
}

//////////////////////////////////////

class SendMessageSuccessState extends AppStates{}

class SendMessageLoadingState extends AppStates{}

class SendMessageErrorState extends AppStates{
  final String error;

  SendMessageErrorState({required this.error});
}

//////////////////////////////////////

class GetWorkerDataSuccessState extends AppStates{}

class GetWorkerDataLoadingState extends AppStates{}

class GetWorkerDataErrorState extends AppStates{
  final String error;

  GetWorkerDataErrorState({required this.error});
}

//////////////////////////////////////

class ChangeThemeState extends AppStates {}

class UploadServiceImagesLoadingState extends AppStates {}

class UploadServiceImagesSuccessState extends AppStates  {}

class UploadServiceImagesErrorState extends AppStates {
  final String error;

  UploadServiceImagesErrorState({required this.error});
}

//////////////////////////////////////

class ClearUploadedImages extends AppStates{}

//////////////////////////////////////

class UploadServiceLoadingState extends AppStates{}
class UploadServiceSuccessState extends AppStates{}
class UploadServiceErrorState extends AppStates{
  final String error;
  UploadServiceErrorState({required this.error});
}

//////////////////////////////////////

class GetWorkerRequestsSuccessState extends AppStates{}

class GetWorkerRequestsLoadingState extends AppStates{}

class GetWorkerRequestsErrorState extends AppStates{
  final String error;

  GetWorkerRequestsErrorState({required this.error});
}

//////////////////////////////////////



