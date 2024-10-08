import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/Verification/verification_bloc.dart';
import 'package:xo_game/models/Verification/verification_event.dart';
import 'package:xo_game/models/Verification/verification_state.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/Auth/login_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage({
    super.key,
    required this.email,
    this.resetPass = false,
    this.newPassword = "",
  });
  static String id = 'VerificationCodePage';
  final String email;
  final bool resetPass;
  late String newPassword;

  TextEditingController verifyCodeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCodeBloc, VerificationCodeState>(
      listener: (context, state) {
        if (state is VerificationCodeLoading) {
          // Show loading
        } else if (state is VerificationCodeSuccess) {
          if (resetPass) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            // Handle password reset success
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
          }
        } else if (state is VerificationCodeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor:kGreen,
                content: Center(
                    child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white, fontFamily: font),
                ))),
          );
        }
      },
      child: ModalProgressHUD(
        progressIndicator: snipkit(context),
        inAsyncCall: context.watch<VerificationCodeBloc>().state
            is VerificationCodeLoading,
        child: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: BounceInDown(
              child: ListView(
                children: [
                  titleWidget(context),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                      
                        CustomTextFormField(
                          prefixIcon: Icons.verified_user_outlined,
                          keyboardType: TextInputType.number,
                          controller: verifyCodeController,
                          hidden: false,
                          labelText: 'Enter your verification code',
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          color1: kRed,
                          color2: kOrange,
                          text: 'Continue',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<VerificationCodeBloc>()
                                  .add(VerifyCodeSubmitted(
                                    email: email,
                                    code: verifyCodeController.text,
                                    isForResetPassword: resetPass,
                                    newPassword: newPassword,
                                  ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
