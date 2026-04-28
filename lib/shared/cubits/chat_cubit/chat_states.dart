abstract class ChatStates{}

class ChatInitState extends ChatStates{}

//////////////////////////////////////

class SendMessageSuccessState extends ChatStates{}

class SendMessageLoadingState extends ChatStates{}

class SendMessageErrorState extends ChatStates{
  final String error;

  SendMessageErrorState({required this.error});
}