import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/SignUp/sign_up_bloc.dart';
import 'package:xo_game/models/SignUp/sign_up_event.dart';
import 'package:xo_game/models/SignUp/sign_up_state.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/Auth/login_page.dart';
import 'package:xo_game/view/screens/Auth/verificaton_code_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  static String id = 'SignUpPage';

  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          
        } else if (state is SignUpSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodePage(
                email: emailController.text,
              ),
            ),
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.amber,
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
        inAsyncCall: context.watch<SignUpBloc>().state is SignUpLoading,
        child: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: BounceInDown(
              child: ListView(
                children: [
                  titleWidget(context, sz: 12),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: userNameController,
                            hidden: false,
                            labelText: 'User Name',
                            prefixIcon: Icons.person_outlined,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: emailController,
                            hidden: false,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                            prefixIcon: Icons.mail_outlined,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: passwordController,
                            hidden: true,
                            labelText: 'Password',
                            prefixIcon: Icons.key_outlined,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: confirmPasswordController,
                            hidden: true,
                            labelText: 'Confirm Password',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field is Required';
                              }
                              if (!passwordMatched(
                                  passwordController.text, value)) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            prefixIcon: Icons.key_outlined,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            color1: kPink,
                            color2: Colors.amber,
                            text: 'Sign Up',
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                context.read<SignUpBloc>().add(SignUpSubmitted(
                                      userName: userNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    ));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey, fontFamily: font),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: font,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
