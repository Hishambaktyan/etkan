abstract class WorkerStates {}

class WorkerInitState extends WorkerStates{}

//////////////////////////////////////

class GetWorkerDataSuccessState extends WorkerStates{}

class GetWorkerDataLoadingState extends WorkerStates{}

class GetWorkerDataErrorState extends WorkerStates{
  final String error;

  GetWorkerDataErrorState({required this.error});
}

//////////////////////////////////////

class ChangeAvailabilityState extends WorkerStates{}

//////////////////////////////////////

class ChangeServiceActivitySuccessState extends WorkerStates{}

class ChangeServiceActivityErrorState extends WorkerStates{
  final String error;

  ChangeServiceActivityErrorState({required this.error});
}

//////////////////////////////////////

class GetWorkerServicesSuccessState extends WorkerStates{}

class GetWorkerServicesLoadingState extends WorkerStates{}

class GetWorkerServicesErrorState extends WorkerStates{
  final String error;

  GetWorkerServicesErrorState({required this.error});
}

//////////////////////////////////////

class GetWorkerRequestsSuccessState extends WorkerStates{}

class GetWorkerRequestsLoadingState extends WorkerStates{}

class GetWorkerRequestsErrorState extends WorkerStates{
  final String error;

  GetWorkerRequestsErrorState({required this.error});
}

//////////////////////////////////////

class UploadServiceLoadingState extends WorkerStates{}

class UploadServiceSuccessState extends WorkerStates{}

class UploadServiceErrorState extends WorkerStates{
  final String error;
  UploadServiceErrorState({required this.error});
}

//////////////////////////////////////

class EditServiceLoadingState extends WorkerStates {}

class EditServiceSuccessState extends WorkerStates {}

class EditServiceErrorState extends WorkerStates {
  final String error;

  EditServiceErrorState({required this.error});
}

//////////////////////////////////////

class DeleteServiceLoadingState extends WorkerStates {}

class DeleteServiceSuccessState extends WorkerStates {}

class DeleteServiceErrorState extends WorkerStates {
  final String error;

  DeleteServiceErrorState({required this.error});
}

//////////////////////////////////////

class UpdateRequestStatusLoadingState extends WorkerStates {}

class UpdateRequestStatusSuccessState extends WorkerStates {}

class UpdateRequestStatusErrorState extends WorkerStates {
  final String error;

  UpdateRequestStatusErrorState({required this.error});
}

//////////////////////////////////////

class EditWorkerDataLoadingState extends WorkerStates {}

class EditWorkerDataSuccessState extends WorkerStates {}

class EditWorkerDataErrorState extends WorkerStates {
  final String error;

  EditWorkerDataErrorState({required this.error});
}
