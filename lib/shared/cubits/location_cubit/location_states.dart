abstract class LocationStates{}

class LocationInitState extends LocationStates{}

//////////////////////////////////////////////////////////

class AddAddressesLoadingState extends LocationInitState{}

class AddAddressesSuccessState extends LocationInitState{}

class AddAddressesErrorState extends LocationInitState{
  final String error;

  AddAddressesErrorState({required this.error});
}

//////////////////////////////////////////////////////////

class GetAddressesLoadingState extends LocationStates{}

class GetAddressesSuccessState extends LocationStates{}

class GetAddressesErrorState extends LocationStates{
  final String error;

  GetAddressesErrorState({required this.error});
}

//////////////////////////////////////////////////////////

class ChangeLocationDefaultState extends LocationStates{}

class GetCurrentLocationLoadingState extends LocationStates{}

class GetCurrentLocationSuccessState extends LocationStates{}

class GetCurrentLocationFinishState extends LocationStates{}

class GetCurrentLocationErrorState extends LocationStates{
  final String error;

  GetCurrentLocationErrorState({required this.error});

}

//////////////////////////////////////////////////////////////

class SetDefaultAddressLoadingState extends LocationStates{}

class SetDefaultAddressSuccessState extends LocationStates{}

class SetDefaultAddressErrorState extends LocationStates{
  final String error;

  SetDefaultAddressErrorState({required this.error});
}

//////////////////////////////////////////////////////////////

class DeleteAddressLoadingState extends LocationStates{}

class DeleteAddressSuccessState extends LocationStates{}

class DeleteAddressErrorState extends LocationStates{
  final String error;

  DeleteAddressErrorState({required this.error});
}

//////////////////////////////////////////////////////////////

class EditAddressLoadingState extends LocationStates{}

class EditAddressSuccessState extends LocationStates{}

class EditAddressErrorState extends LocationStates {
  final String error;

  EditAddressErrorState({required this.error});
}




