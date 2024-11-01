import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/player.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';

import 'package:xo_game/utilities.dart';

Future<void> storeTokens(String jwt, String refreshToken, String jwtExpiry,
    String refreshTokenExpiry) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt', jwt);
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString('expirationOfJwt', jwtExpiry);
  await prefs.setString('expirationOfRefreshToken', refreshTokenExpiry);
}

Future<bool> isTokenExpired() async {
  final prefs = await SharedPreferences.getInstance();
  final jwtExpiryString = prefs.getString('expirationOfJwt');

  if (jwtExpiryString != null) {
    final expiryDate = DateTime.parse(jwtExpiryString);
    return DateTime.now().isAfter(expiryDate);
  }
  return true;
}

Future<void> ensureJwtToken() async {
  if (await isTokenExpired()) {
    await refreshJwtToken();
  }
}

Future<bool> refreshJwtToken() async {
  final refreshToken = await getData('refreshToken');
  final email = await getData('email');
  if (refreshToken != null) {
    final response = await http.post(
      Uri.parse('${baseUrl}tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken, 'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jwt = data['jwt'];
      final newRefreshToken = data['refreshToken'];
      final jwtExpiry = data['expirationOfJwt'];
      final refreshTokenExpiry = data['expirationOfRefreshToken'];

      await storeTokens(jwt, newRefreshToken, jwtExpiry, refreshTokenExpiry);

      print("Refreshed successfully");
      return true;
    } else {
      throw Exception('Failed to refresh token');
    }
  } else {
    throw Exception('No refresh token found');
  }
}

Future<bool> signOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = await getData('jwt');
  print('refreshToken: $token');

  final response = await http.delete(
    Uri.parse('${baseUrl}SignOut'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Successfully signed out');

    // Retrieve profilePic before clearing preferences
    final profilePicFromStorage = await getData('profilePic');
    print('Profile picture before clearing: $profilePicFromStorage');

    await prefs.clear();

    // Set the global profilePic to null
    profilePic = null;

    // Reset the ProfileImageCubit with the default avatar image
    context
        .read<ProfileImageCubit>()
        .setAvatarImg(Image.asset('assets/images/avatar.png'));

    print('Shared preferences cleared and profile image reset to default');

    return true;
  } else {
    print('Failed to sign out ${response.statusCode}');
    return false;
  }
}

Future<bool> changePassword(String oldPassword, String newPassword) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  print('jwt: $jwt');
  final response = await http.post(Uri.parse('${baseUrl}settings/password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt'
      },
      body:
          jsonEncode({"oldPassword": oldPassword, "newPassword": newPassword}));

  if (response.statusCode == 200) {
    print('Password changed successfully');
    return true;
  }
  print(response.statusCode);
  return false;
}

Future<int?> updateUserData({
  required bool updateUserName,
  String? newuserName,
}) async {
  await ensureJwtToken();

  List<Map<String, dynamic>> updateData =
      List<Map<String, dynamic>>.empty(growable: true);
  if (updateUserName) {
    updateData.add({
      "operationType": 0,
      "path": "firstName",
      "op": "replace",
      "from": "string",
      "value": newuserName
    });
  }

  try {
    final url = Uri.parse('${baseUrl}settings/insensitive-data');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final headers = {
      'Content-Type': 'application/json-patch+json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode(updateData);

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('User data updated successfully');
      return response.statusCode;
    } else {
      print('Failed to update user data: ${response.statusCode}');
      return response.statusCode;
    }
  } catch (error) {
    print('Error updating user data: $error');
    return null;
  }
}

Future<bool> uploadImage(CroppedFile croppedFile) async {
  File imageFile = File(croppedFile.path);
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${baseUrl}settings/profile-picture'),
  );
  request.headers.addAll({
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer ${await getData('jwt')}'
  });
  request.files.add(await http.MultipartFile.fromPath(
    'newPicture',
    imageFile.path,
    filename: imageFile.path,
  ));
  var response = await request.send();
  if (response.statusCode == 200) {
    print("File uploaded successfully!");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newProfilePicUrl = croppedFile.path;
    prefs.setString('profilePicture', newProfilePicUrl);

    print('Profile picture updated in SharedPreferences: $newProfilePicUrl');
    return true;
  } else {
    print("File upload failed: ${response.statusCode}");
    return false;
  }
}

Future<Player> getPlayerInfo(int playerId) async {
  http.Response response = await http.get(
    Uri.parse('https://xogame.runasp.net/api/Profile/$playerId'),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    return Player.fromJson(jsonDecode(response.body));
  }
  print('Failed to get player info: ${response.statusCode}');
  return Player();
}

Future<bool> addPoints(int playerId) async {
  http.Response response = await http.post(
    Uri.parse('https://xogame.runasp.net/api/Game/AddPoints/$playerId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $kToken',
    },
  );
  if (response.statusCode == 200) {
    print('Points added successfully');
    return true;
  }
  print('Failed to add points: ${response.statusCode}');
  return false;
}


Future<List<Player>> getTopPlayers() async {
  final response = await http.get(
    Uri.parse('https://xogame.runasp.net/api/Game/rated-players'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $kToken',
    },
  );

  if (response.statusCode == 200) {
    try {
      List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData.map((json) => Player.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing top players: $e');
      return [];
    }
  } else {
    print('Failed to get top players: ${response.statusCode}');
    return [];
  }
}
