import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String email;
  final String userName;
   String? profilePicture;  // Add profile picture here

  AuthSuccess(this.email, this.userName, this.profilePicture);

  @override
  List<Object> get props => [email, userName, profilePicture??''];
}
class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
