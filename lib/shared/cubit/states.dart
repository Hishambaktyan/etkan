abstract class States{}

class InitState extends States{}

class ChangeNavBarState extends States{}

class ChangeAvailabilityState extends States{}

class ChangeServiceActivityState extends States{}

class ChangePasswordVisiability extends States{}

class SignUpSuccessState extends States{}

class SignUpLoadingState extends States{}

class SignUpErrorState extends States{
  final String error;

  SignUpErrorState({required this.error});

}

class LoginSuccessState extends States{}

class LoginLoadingState extends States{}

class LoginErrorState extends States{
  final String error;

  LoginErrorState({required this.error});

}

class LogOutSuccessState extends States{}

class LogOutLoadingState extends States{}

class LogOutErrorState extends States{
  final String error;

  LogOutErrorState({required this.error});

}

class SendVerficationCodeSuccessState extends States{}

class SendVerficationCodeLoadingState extends States{}

class SendVerficationCodeErrorState extends States{
  final String error;

  SendVerficationCodeErrorState({required this.error});


}

class DeleteUserAccSuccessState extends States{}

class DeleteUserAccLoadingState extends States{}

class DeleteUserAccErrorState extends States{
  final String error;

  DeleteUserAccErrorState({required this.error});
}

class SendMessageSuccessState extends States{}

class SendMessageLoadingState extends States{}

class SendMessageErrorState extends States{
  final String error;

  SendMessageErrorState({required this.error});
}

class GetWorkerDataSuccessState extends States{}

class GetWorkerDataLoadingState extends States{}

class GetWorkerDataErrorState extends States{
  final String error;

  GetWorkerDataErrorState({required this.error});
}

class ChangeThemeState extends States {}

class UploadServiceImagesLoadingState extends States {}

class UploadServiceImagesSuccessState extends States  {}

class UploadServiceImagesErrorState extends States {
  final String error;

  UploadServiceImagesErrorState({required this.error});
}

class ClearUploadedImages extends States{}

class UploadServiceLoadingState extends States{}
class UploadServiceSuccessState extends States{}
class UploadServiceErrorState extends States{
  final String error;
  UploadServiceErrorState({required this.error});
}

class GetWorkerRequestsSuccessState extends States{}

class GetWorkerRequestsLoadingState extends States{}

class GetWorkerRequestsErrorState extends States{
  final String error;

  GetWorkerRequestsErrorState({required this.error});
}


