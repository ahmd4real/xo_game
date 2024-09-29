import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.userName});
  final String userName;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final imageState = context.watch<ProfileImageCubit>().state;
    final imageCubit = context.read<ProfileImageCubit>();
    final TextEditingController userNameController = TextEditingController();

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: snipkit(context),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 32,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kDarkPurple,
                          border: Border.all(color: Colors.white, width: 5),
                        ),
                        child: CircleAvatar(
                          backgroundImage: imageState.avatarImg.image,
                          radius: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width * 0.45,
                        left: MediaQuery.of(context).size.width * 0.45,
                        child: editWidget(imageCubit, context),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
                CustomTextFormField(
                  controller: userNameController,
                  hidden: false,
                  labelText: 'new user name',
                  hintText: userNameController.text,
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomButton(
                  color1: kPink,
                  color2: kPurple,
                  text: 'Save',
                  onTap: () async {
                    // if (formKey.currentState!.validate() ) {
                    //   updateUserData(
                    //     updateUserName: userName != userNameController.text,
                    //   );

                    setState(() {
                      isLoading = true;
                    });

                    if (imageToupload != null) {
                      if (await uploadImage(imageToupload!)) {
                        Navigator.pop(context);
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated editWidget to use ProfileImageCubit
  Widget editWidget(ProfileImageCubit imageCubit, BuildContext context) {
    return IconButton(
      onPressed: () {
        showImagePicker(context, (Image newImage) {
          // Use the cubit to set the new avatar image
          imageCubit.setAvatarImg(newImage);
          // You can add additional logic here to update the profile picture on the server if needed
        });
      },
      icon: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kDarkPurple,
            border: Border.all(color: Colors.white54, width: 3),
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.amber,
            size: 30,
          )),
    );
  }
}
