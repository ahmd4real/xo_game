import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: IconThemeData(color: kOrange),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 48,
              color: kOrange,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ListView(children: [
          SizedBox(height: MediaQuery.sizeOf(context).height / 3),
          CustomTextFormField(hidden: false, controller: controller,hintText: 'Email',),
          const SizedBox(height: 16),
          CustomTextFormField(hidden: true, controller: controller,hintText: 'Password',),
          const SizedBox(height: 16),
          CustomButton(color1: kPink, color2: kPurple, text: 'Login')
        
        ]),
      ),
    );
  }
}
