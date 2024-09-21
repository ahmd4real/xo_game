import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: IconThemeData(color: kOrange),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ListView(children: [
         titleWidget(context),
         const SizedBox(height: 32,),
          CustomTextFormField(
            hidden: false,
            controller: emailController,
            hintText: 'Email',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hidden: true,
            controller: passwordController,
            hintText: 'Password',
          ),
          const SizedBox(height: 16),
          CustomButton(color1: kPink, color2: kPurple, text: 'Login')
        ]),
      ),
    );
  }
}
