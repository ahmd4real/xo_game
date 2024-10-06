import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';

class AuthServices {
  final String baseUrl;

  AuthServices({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password, BuildContext context) async {
  final response = await http.post(
    Uri.parse('${baseUrl}Login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    kToken = data['jwt'];
    final prefs = await SharedPreferences.getInstance();

    // Check if user is logging in for the first time
    bool isFirstLogin = !prefs.containsKey('profilePicture');

   print ('isFirstLogin: $isFirstLogin');
    // Store user-related data in SharedPreferences
    prefs.setString('jwt', data['jwt']);
    prefs.setString('email', data['email'] ?? '');
    prefs.setString('refreshToken', data['refreshToken'] ?? '');
    prefs.setBool('isLoggedIn', true);
    prefs.setString('expirationOfJwt', data['expirationOfJwt'] ?? '');
    prefs.setString('userName', data['userName'] ?? '');
    prefs.setInt('userId', data['userId'] ?? 0);

    // Handle profile picture logic based on login scenario
    profilePic = data['profilePicture'] ?? ''; // Update the global profilePic variable
    prefs.setString('profilePicture', profilePic ?? ''); // Store profile picture in SharedPreferences

    if (  profilePic == null || profilePic!.isEmpty) {
      context.read<ProfileImageCubit>().setAvatarImg(
        Image.asset(kAvatar),
      );
    } else {
      context.read<ProfileImageCubit>().setAvatarImg(
        Image.network('https://xogame.runasp.net/$profilePic'),
      );
    }

    return data;
  } else {
    throw Exception('Email or Password not correct');
    //throw Exception('Failed to login ${response.statusCode}');
  }
}


  Future<bool> signUp(String userName, String email, String password,
      String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}SignUp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userName": userName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword
        }),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('userName', userName);

        return true;
      } else if (response.statusCode == 404) {
        throw Exception('This Email Already Exists');
      } else {
        throw Exception(
            'Failed To SignUp');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendVerifyCode(String email, bool reset) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}SendCode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'reset': reset}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateCode(String email, String code,
      {bool isForResetPassword = false}) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}ValidateCode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
          'isForResetPassword': isForResetPassword
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('${baseUrl}resetpassword'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
