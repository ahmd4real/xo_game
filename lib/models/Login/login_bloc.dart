import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';
import 'package:xo_game/services/auth_services.dart';
import 'login_event.dart';
import 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices authServices;

  AuthBloc({required this.authServices}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authServices.login(
            event.email, event.password, event.context);
        emit(AuthSuccess(user['email'], user['userName'], profilePic));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
