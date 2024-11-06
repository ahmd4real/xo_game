
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/utilities.dart';

class CustomButtomSheet_imgPick extends StatelessWidget {
  final Function(Image) setImage;

  const CustomButtomSheet_imgPick({required this.setImage, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
       color:  kDarkPurple
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.2,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomSheetBuilderIcon(
            source: ImageSource.camera,
            icon: Icons.photo_camera_rounded,
            text: 'camera',
            
            setImage: setImage,
          ),
          BottomSheetBuilderIcon(
            source: ImageSource.gallery,
            icon: Icons.image_outlined,
            text: 'gallery',
            setImage: setImage,
          ),
        ],
      ),
    );
  }
}

class BottomSheetBuilderIcon extends StatelessWidget {
  final ImageSource source;
  final IconData icon;
  final String text;
  final Function(Image) setImage;

  const BottomSheetBuilderIcon({
    required this.source,
    required this.icon,
    required this.text,
    required this.setImage,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              height: 75,
              width: 75,
              child: Icon(
                icon,
                size: 35.0,
                color: kGreen,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16, color: Colors.grey,fontFamily: font ),
            )
          ],
        ),
        onTap: () async {
          await imagePick(source, setImage);
          Navigator.pop(context);
        },
      ),
    );
  }
}