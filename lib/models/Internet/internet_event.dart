part of 'internet_bloc.dart';

abstract class InternetEvent {}

class ConnectedEvent extends InternetEvent {}
class DisconnectedEvent extends InternetEvent {}