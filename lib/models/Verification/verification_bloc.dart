
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/models/Verification/verification_event.dart';
import 'package:xo_game/models/Verification/verification_state.dart';
import 'package:xo_game/services/auth_services.dart';


class VerificationCodeBloc extends Bloc<VerificationCodeEvent, VerificationCodeState> {
  final AuthServices authServices;

  VerificationCodeBloc({required this.authServices}) : super(VerificationCodeInitial()) {
    on<VerifyCodeSubmitted>((event, emit) async {
      emit(VerificationCodeLoading());
      try {
        final isValid = await authServices.validateCode(
          event.email,
          event.code,
          isForResetPassword: event.isForResetPassword,
        );
        if (isValid) {
          if (event.isForResetPassword) {
            final resetSuccess = await authServices.resetPassword(
              event.email,
              event.newPassword,
            );
            if (resetSuccess) {
              emit(VerificationCodeSuccess());
            } else {
              emit(VerificationCodeFailure('Failed to Reset Password'));
            }
          } else {
            emit(VerificationCodeSuccess());
          }
        } else {
          emit(VerificationCodeFailure('Invalid verification code'));
        }
      } catch (e) {
        emit(VerificationCodeFailure(e.toString()));
      }
    });
  }
}
