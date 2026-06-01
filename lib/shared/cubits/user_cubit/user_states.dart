abstract class UserStates {}

class UserInitState extends UserStates {}

//////////////////////////////////////

class GetUserAllServicesSuccessState extends UserStates {}

class GetUserAllServicesLoadingState extends UserStates {}

class GetUserAllServicesErrorState extends UserStates {
  final String error;

  GetUserAllServicesErrorState({required this.error});
}

//////////////////////////////////////

class GetUserSpecServicesSuccessState extends UserStates {}

class GetUserSpecServicesLoadingState extends UserStates {}

class GetUserSpecServicesErrorState extends UserStates {
  final String error;

  GetUserSpecServicesErrorState({required this.error});
}

//////////////////////////////////////

class GetCategoryLoadingState extends UserStates {}

class GetCategorySuccessState extends UserStates {}

class GetCategoryErrorState extends UserStates {
  final String error;

  GetCategoryErrorState({required this.error});
}

class GetUserRequestSuccessState extends UserStates {}

class GetUserRequestLoadingState extends UserStates {}

class GetUserRequestErrorState extends UserStates {
  final String error;

  GetUserRequestErrorState({required this.error});
}

//////////////////////////////////////

class CreateRequestSuccessState extends UserStates {}

class CreateRequestLoadingState extends UserStates {}

class CreateRequestErrorState extends UserStates {
  final String error;

  CreateRequestErrorState({required this.error});
}

//////////////////////////////////////

class DeleteUserRequestLoadingState extends UserStates {}

class DeleteUserRequestSuccessState extends UserStates {}

class DeleteUserRequestErrorState extends UserStates {
  final String error;

  DeleteUserRequestErrorState({required this.error});
}

//////////////////////////////////////

class EditUserDataLoadingState extends UserStates {}

class EditUserDataSuccessState extends UserStates {}

class EditUserDataErrorState extends UserStates {
  final String error;

  EditUserDataErrorState({required this.error});
}
