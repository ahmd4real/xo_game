import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/profile_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  static String id = 'ChangePasswordPage';

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: snipkit(context),
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              titleWidget(context),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: oldPasswordController,
                      hidden: false,
                      labelText: 'Enter old Password',
                      prefixIcon: Icons.key_off_outlined,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: newPasswordController,
                      hidden: false,
                      labelText: 'Enter New Password',
                      prefixIcon: Icons.key_outlined,
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
                        if (!passwordMatched(
                            newPasswordController.text, value)) {
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

                          if (await changePassword(oldPasswordController.text,
                              newPasswordController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Center(
                                      child: Text(
                                    'Your Password changed successfully',
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: font),
                                  ))),
                            );
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfilePage(userName: '',email: '',)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Center(
                                      child: Text(
                                    'Failed to change password',
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: font),
                                  ))),
                            );
                          }

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
    );
  }
}
