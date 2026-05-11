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

class ChangeServiceActivityState extends WorkerStates{}

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
