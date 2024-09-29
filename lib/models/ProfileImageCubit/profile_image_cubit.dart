import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? profilePic;

class ProfileImageCubit extends Cubit<ProfileImageState> {
  ProfileImageCubit()
      : super(ProfileImageState(
          avatarImg: _getProfileImage(),
        ));

  final ImagePicker _imagePicker = ImagePicker();

  // Helper function to get the profile image from the local path or network
  static Image _getProfileImage() {
    if (profilePic != null && profilePic!.isNotEmpty) {
      if (File(profilePic!).existsSync()) {
        return Image.file(File(profilePic!));
      } else {
        return Image.network('https://xogame.runasp.net/$profilePic');
      }
    } else {
      return Image.asset('assets/images/avatar.png');
    }
  }

  // Picks image and saves it permanently
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        // Save the image in a permanent directory
        final permanentPath =
            await _saveImageToPermanentDirectory(File(pickedImage.path));

        // Update the UI with the new image
        emit(state.copyWith(avatarImg: Image.file(File(permanentPath))));

        // Store the path in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profilePicture', permanentPath);
      }
    } catch (e) {
      emit(ErrorAvatarState(errorMsg: e.toString()));
    }
  }

  // Saves the image to the app's documents directory
  Future<String> _saveImageToPermanentDirectory(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await imageFile.copy(imagePath);
    return savedImage.path;
  }

  // Directly sets avatar image (can be used for network or local images)
  void setAvatarImg(Image? image) {
    emit(state.copyWith(avatarImg: image));
  }
}


// State class
@immutable
class ProfileImageState {
  final Image avatarImg;
  const ProfileImageState({required this.avatarImg});

  ProfileImageState copyWith({Image? avatarImg}) {
    return ProfileImageState(
      avatarImg: avatarImg ?? this.avatarImg,
    );
  }
}

class ErrorAvatarState extends ProfileImageState {
  final String errorMsg;

  ErrorAvatarState({required this.errorMsg})
      : super(avatarImg: Image.asset('assets/images/avatar.png'));
}



