import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/view/widgets/custom_image_picker.dart';

Widget titleWidget(BuildContext context, {int sz = 8}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FadeInLeft(
            child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / sz,
          child: Image.asset('assets/images/tic.png'),
        )),
        FadeInUp(
            child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / sz,
          child: Image.asset('assets/images/tac.png'),
        )),
        FadeInRight(
            child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / sz,
          child: Image.asset('assets/images/toe.png'),
        ))
      ],
    ),
  );
}

void showGameEndDialog(
  BuildContext context,
  String message,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: kDarkPurple, width: 2),
        ),
        content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              message != 'It\'s a draw!' ? 'assets/images/win.png' : 'assets/images/draw.png',
              width: MediaQuery.sizeOf(context).width / 2,
              height: MediaQuery.sizeOf(context).width / 2,
            )),
        actions: [
          Center(
            child: Text(
              textAlign: TextAlign.center,
              message,
              style: const TextStyle(
                fontFamily: font,
                color: Colors.amber,
                fontSize: 24,
              ),
            ),
          ),
          if(message!='It\'s a draw!')
          Center(
              child: Swing(
            infinite: true,
            child: Image.asset(winnerWord),
          )),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                context.read<GameCubit>().resetGame();
              },
              child: Image.asset('assets/images/play_again.png',
                  width: MediaQuery.sizeOf(context).width / 4,
                  height: MediaQuery.sizeOf(context).width / 
                  4),
            ),
          ),
        ],
      );
    },
  );
}

Widget symbolWidget(String symbol, double sz) {
  return Center(
    child: Text(
      symbol,
      style: TextStyle(
          fontFamily: font,
          color: symbol == "X" ? kRed : Colors.amber,
          fontSize: sz,
          shadows: [
            Shadow(
              color: Colors.amber.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            Shadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ]),
    ),
  );
}

Future<String?> getData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

bool passwordMatched(String s1, String s2) {
  return s1 == s2;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

Widget snipkit(BuildContext context) {
  return SpinKitCircle(
    itemBuilder: (BuildContext context, int index) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
        ),
      );
    },
  );
}

final picker = ImagePicker();

showImagePicker(BuildContext context, Function(Image) setImage) async {
  if (Platform.isIOS) {
    const platform = MethodChannel('imagePickerOptionsChannel');
    try {
      final result = await platform.invokeMethod<int>('showImagePickerOptions');
      switch (result) {
        case 1:
          imagePick(ImageSource.camera, setImage);
          break;
        case 2:
          imagePick(ImageSource.gallery, setImage);
          break;
      }
    } on PlatformException catch (error) {
      print('Error in showImagePicker: $error');
    }
  } else {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return CustomButtomSheet_imgPick(setImage: setImage);
      },
    );
  }
}

imagePick(ImageSource source, Function(Image) setImage) async {
  await picker.pickImage(source: source, imageQuality: 50).then((value) {
    if (value != null) {
      cropImage(File(value.path), setImage);
    } else {
      print('No image selected');
    }
  });
}

CroppedFile? imageToupload;
cropImage(File imgFile, Function(Image) setImage) async {
  final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Edit Photo",
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.green,
            activeControlsWidgetColor: Colors.green,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Edit Photo",
        )
      ]);

  if (croppedFile != null) {
    imageCache.clear();
    setImage(Image.file(File(croppedFile.path)));
    imageToupload = croppedFile;
  }
}

Future<void> saveProfilePicture(String profilePicUrl) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('profilePic', profilePicUrl);
}

Future<String?> loadProfilePicture() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('profilePicture');
}
