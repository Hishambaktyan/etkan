abstract class UserServicesStates {}

class UserServicesInitState extends UserServicesStates {}

//////////////////////////////////////

class GetUserAllServicesSuccessState extends UserServicesStates {}

class GetUserAllServicesLoadingState extends UserServicesStates {}

class GetUserAllServicesErrorState extends UserServicesStates {
  final String error;

  GetUserAllServicesErrorState({required this.error});
}

//////////////////////////////////////

class GetUserElecServicesSuccessState extends UserServicesStates {}

class GetUserElecServicesLoadingState extends UserServicesStates {}

class GetUserElecServicesErrorState extends UserServicesStates {
  final String error;

  GetUserElecServicesErrorState({required this.error});
}

//////////////////////////////////////

class GetCategoryLoadingState extends UserServicesStates {}

class GetCategorySuccessState extends UserServicesStates {}

class GetCategoryErrorState extends UserServicesStates {
  final String error;

  GetCategoryErrorState({required this.error});
}
