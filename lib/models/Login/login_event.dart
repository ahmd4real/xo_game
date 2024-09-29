import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginEvent(this.email, this.password,this.context);

  @override
  List<Object> get props => [email, password,context];
}


