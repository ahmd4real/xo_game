import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/models/Internet/internet_bloc.dart';
import 'package:xo_game/models/Login/login_bloc.dart';
import 'package:xo_game/models/SignUp/sign_up_bloc.dart';
import 'package:xo_game/models/Verification/verification_bloc.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';
import 'package:xo_game/models/player.dart';
import 'package:xo_game/services/auth_services.dart';
import 'package:xo_game/services/services.dart';

import 'package:xo_game/view/screens/home_page.dart';

  String userName = "";
  int points = 0;
  int userId = 0;
  Player user = Player();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  kToken = prefs.getString('jwt') ?? '';
  profilePic = prefs.getString('profilePicture');
  yourId = prefs.getInt('userId') ?? 0;
  userName = prefs.getString('userName') ?? "";
   
    user = await getPlayerInfo(yourId);

    points = user.points ?? 0;
  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = AuthServices(baseUrl: baseUrl);
    return MultiBlocProvider(




      providers: [
        BlocProvider(
            create: (context) => GameCubit(gameMode: GameMode.playerVsPlayer)),
        BlocProvider(create: (context) => AuthBloc(authServices: authServices)),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(authServices: authServices),
        ),
        BlocProvider<VerificationCodeBloc>(
          create: (context) => VerificationCodeBloc(authServices: authServices),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authServices: authServices),
        ),
        BlocProvider<ProfileImageCubit>(
          create: (context) => ProfileImageCubit(),
        ),
        BlocProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
      ],
      child: MaterialApp(
        
          theme: ThemeData(
            scaffoldBackgroundColor: background,
            appBarTheme: AppBarTheme(
              backgroundColor: background,
              iconTheme: const IconThemeData(color: Color(0xFFFFC107)),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home:HomePage() 
          
          ),
    );
  }
}
