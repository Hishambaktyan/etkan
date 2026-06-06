abstract class AdminStates {}

class AdminInitState extends AdminStates {}

class GetUsersSuccessState extends AdminStates {}

class GetUsersLoadingState extends AdminStates {}

class GetUsersErrorState extends AdminStates {
  final String error;

  GetUsersErrorState({required this.error});
}

//////////////////////////////////////

class GetServicesLoadingState extends AdminStates {}

class GetServicesSuccessState extends AdminStates {}

class GetServicesErrorState extends AdminStates {
  final String error;
  GetServicesErrorState({required this.error});
}

//////////////////////////////////////

class GetRequestsLoadingState extends AdminStates {}

class GetRequestsSuccessState extends AdminStates {}

class GetRequestsErrorState extends AdminStates {
  final String error;
  GetRequestsErrorState({required this.error});
}

//////////////////////////////////////

class GetProvidersLoadingState extends AdminStates {}

class GetProvidersSuccessState extends AdminStates {}

class GetProvidersErrorState extends AdminStates {
  final String error;
  GetProvidersErrorState({required this.error});
}

//////////////////////////////////////

class GetAdminDataSuccessState extends AdminStates {}

class GetAdminDataLoadingState extends AdminStates {}

class GetAdminDataErrorState extends AdminStates {
  final String error;

  GetAdminDataErrorState({required this.error});
}

//////////////////////////////////////

class AddCategorySuccessState extends AdminStates {}

class AddCategoryLoadingState extends AdminStates {}

class AddCategoryErrorState extends AdminStates {
  final String error;

  AddCategoryErrorState({required this.error});
}

//////////////////////////////////////

class GetCategorySuccessState extends AdminStates {}

class GetCategoryLoadingState extends AdminStates {}

class GetCategoryErrorState extends AdminStates {
  final String error;

  GetCategoryErrorState({required this.error});
}

//////////////////////////////////////

class DeleteCategorySuccessState extends AdminStates {}

class DeleteCategoryLoadingState extends AdminStates {}

class DeleteGetCategoryErrorState extends AdminStates {
  final String error;

  DeleteGetCategoryErrorState({required this.error});
}

//////////////////////////////////////

class EditCategorySuccessState extends AdminStates {}

class EditCategoryLoadingState extends AdminStates {}

class EditCategoryErrorState extends AdminStates {
  final String error;

  EditCategoryErrorState({required this.error});
}

//////////////////////////////////////

class EditUserSuccessState extends AdminStates {}

class EditUserLoadingState extends AdminStates {}

class EditUserErrorState extends AdminStates {
  final String error;

  EditUserErrorState({required this.error});
}
//////////////////////////////////////

class GetProviderReviewRequestsLoadingState extends AdminStates {}

class GetProviderReviewRequestsSuccessState extends AdminStates {}

class GetProviderReviewRequestsErrorState extends AdminStates {
  final String error;

  GetProviderReviewRequestsErrorState({required this.error});
}

//////////////////////////////////////

class ApproveSubscriptionRequestLoadingState extends AdminStates {}

class ApproveSubscriptionRequestSuccessState extends AdminStates {}

class ApproveSubscriptionRequestErrorState extends AdminStates {
  final String error;

  ApproveSubscriptionRequestErrorState({required this.error});
}

class RejectSubscriptionRequestLoadingState extends AdminStates {}

class RejectSubscriptionRequestSuccessState extends AdminStates {}

class RejectSubscriptionRequestErrorState extends AdminStates {
  final String error;

  RejectSubscriptionRequestErrorState({required this.error});
}

class StopProviderSubscriptionLoadingState extends AdminStates {}

class StopProviderSubscriptionSuccessState extends AdminStates {}

class StopProviderSubscriptionErrorState extends AdminStates {
  final String error;

  StopProviderSubscriptionErrorState({required this.error});
}

//////////////////////////////////////

class ApproveVerificationRequestLoadingState extends AdminStates {}

class ApproveVerificationRequestSuccessState extends AdminStates {}

class ApproveVerificationRequestErrorState extends AdminStates {
  final String error;

  ApproveVerificationRequestErrorState({required this.error});
}

class RejectVerificationRequestLoadingState extends AdminStates {}

class RejectVerificationRequestSuccessState extends AdminStates {}

class RejectVerificationRequestErrorState extends AdminStates {
  final String error;

  RejectVerificationRequestErrorState({required this.error});
}
