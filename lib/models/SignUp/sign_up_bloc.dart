import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/models/SignUp/sign_up_event.dart';
import 'package:xo_game/models/SignUp/sign_up_state.dart';
import 'package:xo_game/services/auth_services.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthServices authServices;

  SignUpBloc({required this.authServices}) : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading());

      try {
        final worked = await authServices.signUp(
          event.userName,
          event.email,
          event.password,
          event.confirmPassword,
        );
        if (worked) {
          await authServices.sendVerifyCode(event.email, false);
          emit(SignUpSuccess());
        } else {
          emit(SignUpFailure('Sign Up Failed'));
        }
      } catch (e) {
        emit(SignUpFailure(e.toString()));
      }
    });
  }
}
