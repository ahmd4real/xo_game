import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/Login/login_bloc.dart';
import 'package:xo_game/models/Login/login_event.dart';
import 'package:xo_game/models/Login/login_state.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/Auth/enter_email.dart';
import 'package:xo_game/view/screens/Auth/signup_page.dart';

import 'package:xo_game/view/screens/profile_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static String id = 'loginPage';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
        } else if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      userName: state.userName,
                    )),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.green,
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
        inAsyncCall: context.watch<AuthBloc>().state is AuthLoading,
        child: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ListView(
                children: [
                  titleWidget(context),
                  const SizedBox(
                    height: 32,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: emailController,
                    hidden: false,
                    labelText: 'Email',
                    validator: emailValidator,
                    prefixIcon: Icons.mail_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: passwordController,
                    hidden: true,
                    labelText: 'Password',
                    prefixIcon: Icons.key_outlined,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EnterYourEmail()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: font,
                            decorationColor: Colors.grey,
                            color: Colors.grey,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    color1: kPink,
                    color2: kPurple,
                    text: 'Login',
                    onTap: () {
                      print(
                          '${emailController.text}  ${passwordController.text}');
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(LoginEvent(
                            emailController.text, passwordController.text));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12, fontFamily: font),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: font,
                            decorationColor: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
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
