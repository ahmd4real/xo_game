import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/services/auth_services.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/Auth/verificaton_code_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class EnterYourEmail extends StatefulWidget {
  const EnterYourEmail({super.key});
  static String id = 'EnterYourEmail';

  @override
  State<EnterYourEmail> createState() => _EnterYourEmailState();
}

class _EnterYourEmailState extends State<EnterYourEmail> {
  TextEditingController verifyCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  final AuthServices authService = AuthServices(baseUrl: baseUrl);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(
        color: Colors.amber,
      ),
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: BounceInDown(
            child: ListView(
              children: [
                titleWidget(context),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: emailController,
                        hidden: false,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        prefixIcon: Icons.key_outlined,
                        controller: passwordController,
                        hidden: true,
                        labelText: 'New Password',
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        prefixIcon: Icons.key_outlined,
                        controller: confirmPasswordController,
                        hidden: true,
                        labelText: 'Confirm New Password',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field is Required';
                          }
                          if (!passwordMatched(passwordController.text, value)) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        color1: kRed,
                        color2: kOrange,
                        text: 'Continue',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await authService.sendVerifyCode(
                              emailController.text,
                              true,
                            )
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerificationCodePage(
                                              email: emailController.text,
                                              resetPass: true,
                                              newPassword:
                                                  passwordController.text,
                                            )),
                                  )
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Center(
                                        child: Text(
                                          'Failed to send verification code, please try again',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: font),
                                        ),
                                      ),
                                    ),
                                  );
            
                            setState(() {
                              loading = false;
                            });
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
    );
  }
}
