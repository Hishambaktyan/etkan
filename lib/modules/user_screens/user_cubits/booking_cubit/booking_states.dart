abstract class BookingStates{}

class BookingInitState extends BookingStates{}

//////////////////////////////////////

class GetUserRequestSuccessState extends BookingStates{}

class GetUserRequestLoadingState extends BookingStates{}

class GetUserRequestErrorState extends BookingStates{
  final String error;

  GetUserRequestErrorState({required this.error});
}

//////////////////////////////////////

class CreateRequestSuccessState extends BookingStates{}

class CreateRequestLoadingState extends BookingStates{}

class CreateRequestErrorState extends BookingStates{
  final String error;

  CreateRequestErrorState({required this.error});
}

//////////////////////////////////////

