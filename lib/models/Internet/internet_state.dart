
part of 'internet_bloc.dart';

abstract class InternetState  {}


class InternetInitial extends InternetState {
  
}
class ConnectedState extends InternetState {
  final bool internetState;
  ConnectedState({required this.internetState});
}

class DisconnectedState extends InternetState {
   final bool internetState;
  DisconnectedState({required this.internetState});
}