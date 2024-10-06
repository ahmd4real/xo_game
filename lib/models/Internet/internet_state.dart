part of 'internet_bloc.dart';

sealed class InternetState extends Equatable {
  const InternetState();
  
  @override
  List<Object> get props => [];
}

final class InternetInitial extends InternetState {}

class ConnectedState extends InternetState {
   final bool internetState;

  const ConnectedState({required this.internetState});
}
class NotConnectedState extends InternetState {
  final bool internetState;

  const NotConnectedState({required this.internetState});
}