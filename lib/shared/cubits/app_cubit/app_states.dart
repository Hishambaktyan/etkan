abstract class AppStates{}

class InitState extends AppStates{}

//////////////////////////////////////

class ChangeNavBarState extends AppStates{}

//////////////////////////////////////

class ChangeAvailabilityState extends AppStates{}

//////////////////////////////////////

class ChangeServiceActivityState extends AppStates{}

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

class GetAdminDataSuccessState extends AppStates{}

class GetAdminDataLoadingState extends AppStates{}

class GetAdminDataErrorState extends AppStates{
  final String error;

  GetAdminDataErrorState({required this.error});

}

//////////////////////////////////////

class AddCategorySuccessState extends AppStates{}

class AddCategoryLoadingState extends AppStates{}

class AddCategoryErrorState extends AppStates{
  final String error;

  AddCategoryErrorState({required this.error});

}

//////////////////////////////////////

class GetCategorySuccessState extends AppStates{}

class GetCategoryLoadingState extends AppStates{}

class GetCategoryErrorState extends AppStates{
  final String error;

  GetCategoryErrorState({required this.error});

}

//////////////////////////////////////

class DeleteCategorySuccessState extends AppStates{}

class DeleteCategoryLoadingState extends AppStates{}

class DeleteGetCategoryErrorState extends AppStates{
  final String error;

  DeleteGetCategoryErrorState({required this.error});

}

//////////////////////////////////////

class EditCategorySuccessState extends AppStates{}

class EditCategoryLoadingState extends AppStates{}

class EditGetCategoryErrorState extends AppStates{
  final String error;

  EditGetCategoryErrorState({required this.error});

}


