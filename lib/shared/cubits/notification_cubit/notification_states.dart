abstract class NotificationStates{}

class NotificationInitState extends NotificationStates{}

//////////////////////////////////////////////////////////

class NotificationLoadingState extends NotificationStates {}

class NotificationSuccessState extends NotificationStates {}

class NotificationReceivedState extends NotificationStates {}

class NotificationOpenedState extends NotificationStates {}

class NotificationErrorState extends NotificationStates {
  final String error;

  NotificationErrorState({required this.error});
}





